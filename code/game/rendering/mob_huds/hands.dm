//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/mob_hud/hands
	/// ordered hand objects
	var/list/atom/movable/screen/hands/hand/hands
	/// swap hand object
	var/atom/movable/screen/hands/swap_hand/swap_hand
	/// equip object
	var/atom/movable/screen/hands/equip_hand/equip_hand
	/// use hand on self object
	var/atom/movable/screen/hands/use_self_hand/use_self_hand

/datum/mob_hud/hands/proc/add_item(obj/item/item, index)

/datum/mob_hud/hands/proc/remove_item(obj/item/item, index)

/datum/mob_hud/hands/proc/move_item(obj/item/item, from_index, to_index)

/datum/mob_hud/hands/proc/swap_active_hand(from_index, to_index)
	var/atom/movable/screen/hands/old_hand = hands[from_index]
	var/atom/movable/screen/hands/new_hand = hands[to_index]


#warn impl all

/atom/movable/screen/hands
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

	/// our owning mob hud
	var/datum/mob_hud/hands/hud

/atom/movable/screen/hands/Initialize(mapload, datum/mob_hud/hands/hud)
	. = ..()
	src.hud = hud
	sync_style(hud.style)

/atom/movable/screen/hands/sync_style(datum/hud_style/style, style_alpha, style_color)
	icon = style.inventory_icons
	alpha = style_alpha
	color = style_color

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * slot_or_index - slot ID or numerical hand index
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/hands/proc/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

#warn impl all

/atom/movable/screen/hands/hand
	/// target hand index
	var/hand_index

/atom/movable/screen/hands/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)

/atom/movable/screen/hands/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_INV_HAND(index)
	var/index_of_side = round(index / 2)
	name = "[index % 2? "left" : "right"] hand[index > 1? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/screen/hands/swap_hand
	icon_state = "swap"

/atom/movable/screen/hands/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	icon = style.inventory_icons_wide
	alpha = style_alpha
	color = style_color

/atom/movable/screen/hands/equip_hand
	icon_state = "equip"

// /atom/movable/screen/hands/use_self_hand
