//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Inventory slots specifically, not hands.
 */
/datum/mob_hud/inventory
	/// owning inventory
	var/datum/inventory/host

	/// hidden classes
	var/list/hidden_classes

	/// keyed slot id to screen object
	var/list/atom/movable/screen/inventory/slot/slot_by_id
	/// ordered hand objects
	var/list/atom/movable/screen/inventory/hand/hands

	/// swap hand object
	var/atom/movable/screen/inventory/swap_hand/swap_hand
	/// equip object
	var/atom/movable/screen/inventory/equip_hand/equip_hand
	/// use hand on self object
	var/atom/movable/screen/inventory/use_self_hand/use_self_hand
	#warn add the drawer.

/datum/mob_hud/inventory/New(mob/owner, datum/inventory/host)
	src.host = host
	src.rebuild(host.build_inventory_slots_with_remappings(), host.get_nominal_hand_count())
	..()

/datum/mob_hud/Destroy()
	host = null
	cleanup()
	return ..()

/datum/mob_hud/inventory/screens()
	. = ..()
	// slots
	. += all_slot_screen_objects()
	// hands
	. += all_hand_screen_objects()
	// buttons
	. += all_button_screen_objects()

/datum/mob_hud/inventory/sync_client(client/C)
	. = ..()
	for(var/atom/movable/screen/screen_object in screens())
		screen_object.sync_style(hud_style, hud_alpha, hud_color)

/**
 * destroy everything
 */
/datum/mob_hud/inventory/proc/cleanup()
	// slots
	var/list/atom/movable/screen/inventory/slot/slot_objects = all_slot_screen_objects()
	remove_screen(slot_objects)
	QDEL_LIST(slot_objects)

	// hands
	var/list/atom/movable/screen/inventory/hand/hand_objects = all_hand_screen_objects()
	remove_screen(hand_objects)
	QDEL_LIST(hand_objects)

	// buttons
	var/list/atom/movable/screen/inventory/button_objects = all_button_screen_objects()
	remove_screen(button_objects)
	QDEL_NULL(button_objects)

/**
 * Accepts a list with keys as slot IDs, and values as null or a list of
 * INVENTORY_SLOT_REMAP_*'s.
 */
/datum/mob_hud/inventory/proc/rebuild(list/inventory_slots_with_mappings, number_of_hands)
	cleanup()

	// buttons
	add_screen((swap_hand = new))
	add_screen((equip_hand = new))
	add_screen((use_self_hand = new))

	// slots
	LAZYINITLIST(slot_by_id)
	for(var/slot_id in inventory_slots_with_mappings)
		var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
		if(!slot)
			stack_trace("failed to fetch slot during hud rebuild: [slot_id]")
			continue
		slot_by_id += new /atom/movable/screen/inventory/slot(null, slot, inventory_slot_with_mappings[slot_id] || list())

	// hands
	rebuild_hands(number_of_hands)

/**
 * Rebuilds our hands. Doesn't rebuild anything else.
 */
/datum/mob_hud/inventory/proc/rebuild_hands(number_of_hands)
	LAZYINITLIST(hands)
	#warn impl

/datum/mob_hud/inventory/proc/all_slot_screen_objects(filter_by_class)
	RETURN_TYPE(/list)
	. = list()
	if(filter_by_class)
		if(islist(filter_by_class))
			for(var/id in slot_by_id)
				var/atom/movable/screen/inventory/slot/slot_object = slot_by_id[id]
				if(slot_object.inventory_hud_class in filter_by_class)
					. += slot_object
		else
			for(var/id in slot_by_id)
				var/atom/movable/screen/inventory/slot/slot_object = slot_by_id[id]
				if(slot_object.inventory_hud_class == filter_by_class)
					. += slot_object
	else
		for(var/id in slot_by_id)
			. += slot_by_id[id]

/datum/mob_hud/inventory/proc/all_hand_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	for(var/atom/movable/object in hands)
		. += object

/datum/mob_hud/inventory/proc/all_button_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	if(swap_hand)
		. += swap_hand
	if(equip_hand)
		. += equip_hand
	if(use_self_hand)
		. += use_self_hand

/datum/mob_hud/inventory/proc/add_item(obj/item/item, datum/inventory_slot/slot_or_index)
	#warn impl

/datum/mob_hud/inventory/proc/remove_item(obj/item/item, datum/inventory_slot/slot_or_index)
	#warn impl

/datum/mob_hud/inventory/proc/move_item(obj/item/item, datum/inventory_slot/from_slot_or_index, datum/inventory_slot/to_slot_or_index)
	#warn impl

/datum/mob_hud/inventory/proc/swap_active_hand(from_index, to_index)
	var/atom/movable/screen/inventory/hands/old_hand = hands[from_index]
	var/atom/movable/screen/inventory/hands/new_hand = hands[to_index]

#warn impl all

/atom/movable/screen/inventory
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

	/// our owning mob hud
	var/datum/mob_hud/inventory/hud

/atom/movable/screen/inventory/Initialize(mapload, datum/mob_hud/inventory/hud)
	. = ..()
	src.hud = hud
	sync_style(hud.hud_style)

/atom/movable/screen/inventory/check_allowed(mob/user)
	return ..() && hud.owner == user

/atom/movable/screen/inventory/on_click(mob/user, list/params)
	var/obj/item/held = user.get_active_held_item()
	handle_inventory_click(user, held)

/atom/movable/screen/inventory/sync_style(datum/hud_style/style, style_alpha, style_color)
	alpha = style_alpha
	color = style_color

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/inventory/proc/handle_inventory_click(mob/user, obj/item/with_item)
	return

#warn impl all

/**
 * Slot screen objects
 */
/atom/movable/screen/inventory/slot
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

/atom/movable/screen/inventory/slot/Initialize(mapload, datum/mob_hud/inventory/hud, datum/inventory_slot/slot, list/slot_remappings)
	. = ..()
	inventory_slot_id = slot.id
	inventory_hud_class = slot_remappings[INVENTORY_SLOT_REMAP_CLASS] || slot.inventory_hud_class
	inventory_hud_main_axis = slot_remappings[INVENTORY_SLOT_REMAP_MAIN_AXIS] || slot.inventory_hud_main_axis
	inventory_hud_cross_axis = slot_remappings[INVENTORY_SLOT_REMAP_CROSS_AXIS] || slot.inventory_hud_cross_axis
	inventory_hud_anchor = slot_remappings[INVENTORY_SLOT_REMAP_ANCHOR] || slot.inventory_hud_anchor
	name = slot_remappings[INVENTORY_SLOT_REMAP_NAME] || slot.display_name || slot.name

/atom/movable/screen/inventory/slot/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons_slot

/atom/movable/screen/inventory/slot/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

/**
 * Hand screen objects
 */
/atom/movable/screen/inventory/hand
	/// target hand index
	var/hand_index

/atom/movable/screen/inventory/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)

/atom/movable/screen/inventory/hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/inventory/hand/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

/atom/movable/screen/inventory/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_INV_HAND(index)
	var/index_of_side = round(index / 2)
	name = "[index % 2? "left" : "right"] hand[index > 1? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/**
 * Button: 'swap hand'
 */
/atom/movable/screen/inventory/swap_hand
	icon_state = "swap"

/atom/movable/screen/inventory/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons_wide

/atom/movable/screen/inventory/swap_hands/on_click(mob/user, list/params)

/**
 * Button: 'auto equip'
 */
/atom/movable/screen/inventory/equip_hand
	icon_state = "equip"

/atom/movable/screen/inventory/equip_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/inventory/equip_hand/on_click(mob/user, list/params)

/**
 * Button: 'activate inhand'
 */
/atom/movable/screen/inventory/hands/use_self_hand
	#warn does main have this?
