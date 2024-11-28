//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets the item in a slot.
 *
 * * If multiple items are worn over each other in a slot, this gets the topmost.
 * * For compound items, this only returns the outermost / host / root.
 *
 * @params
 * * slot_id - slot ID
 *
 * @return /obj/item or null
 */
/datum/inventory/proc/get_item_in_slot(slot_id) as /obj/item
	. = owner._item_by_slot(slot_id)
	if(. == INVENTORY_SLOT_DOES_NOT_EXIST)
		return null

/**
 * Gets all items in a slot.
 *
 * * If multiple items are worn over each other in a slot, this gets all of them.
 * * If multiple items are compounded on one item (e.g. clothing accessories), this gets all of them.
 *
 * @params
 * * slot_id - slot ID
 *
 * @return /obj/item or null
 */
/datum/inventory/proc/get_items_in_slot(slot_id) as /list
	var/obj/item/in_slot = owner._item_by_slot(slot_id)
	if(in_slot == INVENTORY_SLOT_DOES_NOT_EXIST)
		return
	if(in_slot)
		. = in_slot.inv_slot_attached()
		if(!islist(.))
			. = . ? list(.) : list()
