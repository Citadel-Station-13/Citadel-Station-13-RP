//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Inventory slots specifically, not hands.
 */
/datum/mob_hud/inventory
	/// owning inventory
	var/datum/inventory/host

/datum/mob_hud/inventory/proc/add_item(obj/item/item, datum/inventory_slot/slot)

/datum/mob_hud/inventory/proc/remove_item(obj/item/item, datum/inventory_slot/slot)

/datum/mob_hud/inventory/proc/move_item(obj/item/item, datum/inventory_slot/from_slot, datum/inventory_slot/to_slot)

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

/atom/movable/screen/inventory/slot
	/// our inventory slot id
	var/inventory_slot_id

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * slot_or_index - slot ID or numerical hand index
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/inventory/slot/proc/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)
