//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of inventory screen objects.
 */
/atom/movable/screen/actor_hud/inventory
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'
	plane = HUD_PLANE
	layer = HUD_LAYER_INVENTORY

/atom/movable/screen/actor_hud/inventory/on_click(mob/user, list/params)
	var/obj/item/held = user.get_active_held_item()
	handle_inventory_click(user, held)

/atom/movable/screen/actor_hud/inventory/sync_to_preferences(datum/hud_preferences/preference_set)
	sync_style(preference_set.hud_style, preference_set.hud_alpha, preference_set.hud_color)

/atom/movable/screen/actor_hud/inventory/proc/sync_style(datum/hud_style/style, style_alpha, style_color)
	alpha = style_alpha
	color = style_color

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/actor_hud/inventory/proc/handle_inventory_click(mob/user, obj/item/with_item)
	return

/**
 * Base type of item-holding screen objects
 */
/atom/movable/screen/actor_hud/inventory/plate
	icon = null
	icon_state = null
	plane = HUD_ITEM_PLANE
	layer = HUD_ITEM_LAYER_BASE

	var/self_icon = 'icons/screen/hud/midnight/inventory.dmi'
	var/self_icon_state = ""
	var/self_alpha = 255
	var/self_color = "#ffffff"

/atom/movable/screen/actor_hud/inventory/plate/Destroy()
	if(length(vis_contents) != 0)
		vis_contents.len = 0
	return ..()

/atom/movable/screen/actor_hud/inventory/plate/update_icon(updates)
	cut_overlays()
	. = ..()
	var/image/self_render = new
	self_render.icon = self_icon
	self_render.icon_state = self_icon_state
	self_render.alpha = self_alpha
	self_render.color = self_color
	self_render.plane = HUD_PLANE
	self_render.layer = HUD_LAYER_INVENTORY
	add_overlay(self_render)

/atom/movable/screen/actor_hud/inventory/plate/sync_style(datum/hud_style/style, style_alpha, style_color)
	self_alpha = style_alpha
	self_color = style_color
	update_icon()

/atom/movable/screen/actor_hud/inventory/plate/proc/bind_item(obj/item/item)
	vis_contents += item

/atom/movable/screen/actor_hud/inventory/plate/proc/unbind_item(obj/item/item)
	vis_contents -= item

/**
 * Slot screen objects
 *
 * * Stores remappings so we don't have to do it separately
 * * Stores calculated screen_loc so we don't have to recalculate unless slots are mutated.
 */
/atom/movable/screen/actor_hud/inventory/plate/slot
	/// our inventory slot id
	var/inventory_slot_id
	/// our (potentially remapped) class
	var/inventory_hud_class = INVENTORY_HUD_CLASS_ALWAYS
	/// our (potentially remapped) main axis
	var/inventory_hud_main_axis = 0
	/// our (potentially remapped) cross axis
	var/inventory_hud_cross_axis = 0
	/// our (potentially remapped) anchor
	var/inventory_hud_anchor = INVENTORY_HUD_ANCHOR_AUTOMATIC

/atom/movable/screen/actor_hud/inventory/plate/slot/Initialize(mapload, datum/actor_hud/inventory/hud, datum/inventory_slot/slot, list/slot_remappings)
	// set statics
	inventory_slot_id = slot.id
	self_icon_state = slot.inventory_hud_icon_state
	// set mappings
	name = slot_remappings[INVENTORY_SLOT_REMAP_NAME] || slot.display_name || slot.name
	inventory_hud_class = slot_remappings[INVENTORY_SLOT_REMAP_CLASS] || slot.inventory_hud_class
	inventory_hud_main_axis = slot_remappings[INVENTORY_SLOT_REMAP_MAIN_AXIS] || slot.inventory_hud_main_axis
	inventory_hud_cross_axis = slot_remappings[INVENTORY_SLOT_REMAP_CROSS_AXIS] || slot.inventory_hud_cross_axis
	inventory_hud_anchor = slot_remappings[INVENTORY_SLOT_REMAP_ANCHOR] || slot.inventory_hud_anchor
	return ..()

/atom/movable/screen/actor_hud/inventory/plate/slot/sync_style(datum/hud_style/style, style_alpha, style_color)
	self_icon = style.inventory_icons_slot
	..()

/atom/movable/screen/actor_hud/inventory/plate/slot/handle_inventory_click(mob/user, obj/item/with_item)
	var/obj/item/in_slot = user.item_by_slot_id(inventory_slot_id)
	if(with_item)
		if(in_slot)
			with_item.lazy_melee_interaction_chain(in_slot, user, NONE, list())
		else
			user.equip_to_slot_if_possible(with_item, inventory_slot_id, NONE, user)
	else
		in_slot?.attack_hand(user, new /datum/event_args/actor/clickchain(user))

/**
 * Hand screen objects
 */
/atom/movable/screen/actor_hud/inventory/plate/hand
	/// target hand index
	var/hand_index
	/// should we have handcuffed overlay?
	var/handcuffed = FALSE
	/// should we have the active overlay?
	var/active = FALSE

/atom/movable/screen/actor_hud/inventory/plate/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)
	update_icon()

/atom/movable/screen/actor_hud/inventory/plate/hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	self_icon = style.inventory_icons
	..()

/atom/movable/screen/actor_hud/inventory/plate/hand/handle_inventory_click(mob/user, obj/item/with_item)
	hud.owner.mob.swap_hand(hand_index)

/atom/movable/screen/actor_hud/inventory/plate/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_HAND(index)
	name = "[index % 2? "left" : "right"] hand[index > 2? " #[index]" : ""]"
	self_icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/screen/actor_hud/inventory/plate/hand/proc/set_handcuffed(state)
	if(state == handcuffed)
		return
	handcuffed = state
	update_icon()

/atom/movable/screen/actor_hud/inventory/plate/hand/update_icon(updates)
	. = ..()
	if(handcuffed)
		add_overlay(image('icons/mob/screen_gen.dmi', "[hand_index % 2 ? "l_hand" : "r_hand"]_hud_handcuffs"))
	if(active)
		var/image/active_image = new
		active_image.icon = self_icon
		active_image.icon_state = "[self_icon_state]-active"
		active_image.plane = HUD_PLANE
		active_image.layer = HUD_LAYER_INVENTORY
		active_image.alpha = self_alpha
		active_image.color = self_color
		add_overlay(active_image)

/**
 * Button: 'swap hand'
 */
/atom/movable/screen/actor_hud/inventory/drawer
	name = "drawer"
	icon_state = "drawer"
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_DRAWER

/atom/movable/screen/actor_hud/inventory/drawer/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/actor_hud/inventory/drawer/on_click(mob/user, list/params)
	// todo: remote control
	hud.toggle_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_DRAWER)

/atom/movable/screen/actor_hud/inventory/drawer/update_icon_state()
	icon_state = "[(INVENTORY_HUD_CLASS_DRAWER in hud.hidden_classes) ? "drawer" : "drawer-active"]"
	return ..()

/**
 * Button: 'swap hand'
 */
/atom/movable/screen/actor_hud/inventory/swap_hand
	name = "swap active hand"
	icon_state = "hand-swap"

/atom/movable/screen/actor_hud/inventory/swap_hand/Initialize(mapload, datum/inventory/host, hand_count)
	. = ..()
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_HAND_SWAP(hand_count)

/atom/movable/screen/actor_hud/inventory/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons_wide

/atom/movable/screen/actor_hud/inventory/swap_hand/on_click(mob/user, list/params)
	// todo: remote control
	user.swap_hand()

/**
 * Button: 'auto equip'
 */
/atom/movable/screen/actor_hud/inventory/equip_hand
	name = "equip held item"
	icon_state = "button-equip"

/atom/movable/screen/actor_hud/inventory/equip_hand/Initialize(mapload, datum/inventory/host, hand_count)
	. = ..()
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_EQUIP_HAND(hand_count)

/atom/movable/screen/actor_hud/inventory/equip_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/actor_hud/inventory/equip_hand/on_click(mob/user, list/params)
	// todo: remote control
	user.attempt_smart_equip(user.get_active_held_item())
