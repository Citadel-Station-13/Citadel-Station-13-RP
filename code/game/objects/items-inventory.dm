//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Getters *//

/**
 * checks if we're in inventory. if so, returns mob we're in
 */
/obj/item/proc/inv_get_in_mob() as /mob
	return inv_inside?.owner

/**
 * checks if we're held in hand. if so, returns mob we're in
 * * only returns the mob if we're in a hand slot / index, not a normal keyed inventory slot
 */
/obj/item/proc/inv_get_held_mob() as /mob
	return isnum(inv_slot_or_index) ? inv_inside.owner : null

/**
 * checks if we're worn. if so, return mob we're in
 * * only returns the mob if we're in a slot considered worn
 */
/obj/item/proc/inv_get_worn_mob() as /mob
	if(!inv_slot_or_index)
		return
	var/datum/inventory_slot/slot_meta = resolve_inventory_slot(inv_slot_or_index)
	return slot_meta.inventory_slot_flags & INV_SLOT_CONSIDERED_WORN ? inv_inside.owner : null
