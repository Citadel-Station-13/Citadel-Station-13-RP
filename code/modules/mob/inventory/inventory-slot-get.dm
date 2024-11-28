//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets the item in a slot.
 *
 * * If multiple items are worn over each other in a slot, this gets the topmost.
 * * For compound items, this only returns the outermost / host / root.
 *
 * @params
 * * type_or_id - slot typepath or id
 *
 * @return /obj/item or null
 */
/datum/inventory/proc/get_slot_single(datum/inventory_slot/type_or_id) as /obj/item
	if(ispath(type_or_id))
		type_or_id = initial(type_or_id.id)
	. = owner._item_by_slot(type_or_id)
	if(. == INVENTORY_SLOT_DOES_NOT_EXIST)
		return null

/**
 * Gets all items in a slot.
 *
 * * If multiple items are worn over each other in a slot, this gets all of them.
 * * If multiple items are compounded on one item (e.g. clothing accessories), this gets all of them.
 *
 * @params
 * * type_or_id - slot typepath or id
 *
 * @return list() of items
 */
/datum/inventory/proc/get_slot(datum/inventory_slot/type_or_id) as /list
	if(ispath(type_or_id))
		type_or_id = initial(type_or_id.id)
	var/obj/item/in_slot = owner._item_by_slot(type_or_id)
	if(in_slot == INVENTORY_SLOT_DOES_NOT_EXIST)
		return
	if(in_slot)
		. = in_slot.inv_slot_attached()
		if(!islist(.))
			. = . ? list(.) : list()

/**
 * Gets the item in a list of slots.
 *
 * * This does not check that the provided slot list is deduped.
 *
 * Non-compound mode:
 * * If multiple items are worn over each other in a slot, this gets the topmost.
 * * For compound items, this only returns the outermost / host / root.
 *
 * Compound mode:
 * * If multiple items are worn over each other in a slot, this gets all of them.
 * * If multiple items are compounded on one item (e.g. clothing accessories), this gets all of them.
 *
 * @params
 * * types_or_ids - slot types / IDs. Defaults to all slots if not provided. This dupe must be deduped, or the resulting list will be duped.
 * * compound - Compound mode?
 *
 * @return list() of items
 */
/datum/inventory/proc/get_slots_unsafe(list/types_or_ids, compound) as /list
	. = list()
	for(var/datum/inventory_slot/slot_id as anything in types_or_ids || base_inventory_slots)
		if(ispath(slot_id))
			slot_id = initial(slot_id.id)
		var/obj/item/fetched = owner._item_by_slot(slot_id)
		if(istype(fetched))
			. += compound ? fetched.inv_slot_attached() : fetched
