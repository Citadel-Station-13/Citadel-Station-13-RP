//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Inventory slots specifically, not hands.
 */
/datum/mob_hud/inventory
	/// owning inventory
	var/datum/inventory/host

	/// keyed slot id to screen object
	var/list/atom/movable/screen/inventory/slot/slot_by_id
	/// ordered hand objects
	var/list/atom/movable/inventory/hand/hands

	/// swap hand object
	var/atom/movable/inventory/swap_hand/swap_hand
	/// equip object
	var/atom/movable/inventory/equip_hand/equip_hand
	/// use hand on self object
	var/atom/movable/inventory/use_self_hand/use_self_hand

/datum/mob_hud/inventory/New(mob/owner, datum/inventory/host)
	src.host = host
	..()

/datum/mob_hud/inventory/proc/add_item(obj/item/item, datum/inventory_slot/slot_or_index)

/datum/mob_hud/inventory/proc/remove_item(obj/item/item, datum/inventory_slot/slot_or_index)

/datum/mob_hud/inventory/proc/move_item(obj/item/item, datum/inventory_slot/from_slot_or_index, datum/inventory_slot/to_slot_or_index)

/datum/mob_hud/inventory/proc/swap_active_hand(from_index, to_index)
	var/atom/movable/inventory/hands/old_hand = hands[from_index]
	var/atom/movable/inventory/hands/new_hand = hands[to_index]

#warn impl all

/atom/movable/screen/inventory
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

	/// our owning mob hud
	var/datum/mob_hud/inventory/hud

/atom/movable/screen/inventory/Initialize(mapload, datum/mob_hud/inventory/hud)
	. = ..()
	src.hud = hud
	sync_style(hud.style)

/atom/movable/screen/inventory/sync_style(datum/hud_style/style, style_alpha, style_color)
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
/atom/movable/screen/inventory/proc/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

#warn impl all

/atom/movable/screen/inventory/slot
	/// our inventory slot id
	var/inventory_slot_id

/atom/movable/inventory/hand
	/// target hand index
	var/hand_index

/atom/movable/inventory/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)

/atom/movable/inventory/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_INV_HAND(index)
	var/index_of_side = round(index / 2)
	name = "[index % 2? "left" : "right"] hand[index > 1? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/inventory/swap_hand
	icon_state = "swap"

/atom/movable/inventory/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	icon = style.inventory_icons_wide
	alpha = style_alpha
	color = style_color

/atom/movable/inventory/equip_hand
	icon_state = "equip"

// /atom/movable/inventory/hands/use_self_hand
