//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets all equipped items.
 *
 * In non-compound mode:
 * * If multiple items are worn over each other in a slot, this gets the topmost.
 * * For compound items, this only returns the outermost / host / root.
 *
 * In compound mode:
 * * If multiple items are worn over each other in a slot, this gets all of them.
 * * If multiple items are compounded on one item (e.g. clothing accessories), this gets all of them.
 *
 * @params
 * * filter_exclude - INV_SLOT_FILTER to exclude.
 * * compound - Enable compound mode.
 *
 * @return list() of items
 */
/datum/inventory/proc/get_everything(filter_exclude, compound) as /list
	. = list()
	if(compound)
		for(var/slot_id in base_inventory_slots)
			var/datum/inventory_slot/slot_meta = resolve_inventory_slot(slot_id)
			if(slot_meta.inventory_filter_flags & filter_exclude)
				continue
			var/obj/item/in_slot = owner._item_by_slot(slot_id)
			if(in_slot)
				. += in_slot.inv_slot_attached()
	else
		for(var/slot_id in base_inventory_slots)
			var/datum/inventory_slot/slot_meta = resolve_inventory_slot(slot_id)
			if(slot_meta.inventory_filter_flags & filter_exclude)
				continue
			var/obj/item/in_slot = owner._item_by_slot(slot_id)
			if(in_slot)
				. += in_slot
	if(!(filter_exclude & INV_FILTER_HANDS))
		. += get_held_items()
