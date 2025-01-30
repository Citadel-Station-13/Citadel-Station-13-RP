//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets the item held in a given hand index
 *
 * * This only includes the topmost item in a slot, and ignores compound / attached items.
 *
 * @return /obj/item or null
 */
/datum/inventory/proc/get_hand_single(index) as /obj/item
	if(index < 1 || index > length(held_items))
		return
	return held_items[index]

/**
 * Gets the item held in a given hand index
 *
 * * This includes all items in a hand slot including nested and compound/attached items.
 *
 * @return list() of items
 */
/datum/inventory/proc/get_hand(index) as /list
	if(index < 1 || index > length(held_items))
		return
	var/obj/item/held = held_items[index]
	if(!held)
		return
	return held.inv_slot_attached()

// todo: deal with below; new inventory-level api, don't just mirror from mob?

/**
 * Gets items in given hand indices.
 *
 * * This does not check that 'indices' list is deduped, or that the hands exist.
 *
 * Non-compound mode:
 * * This returns a list, and includes only the topmost item in a slot.
 *
 * Compound mode:
 * * This returns a list, and includes all items in compound items.
 *
 * @params
 * * indices - List of indices, or null for all hands. This list must be deduped, or the resulting list will be duped.
 * * compound - Compound mode?
 *
 * @return list() of items
 */
/datum/inventory/proc/get_hands_unsafe(list/indices, compound) as /list
	. = list()
	if(indices)
		for(var/index in indices)
			if(index < 1 || index > length(held_items))
				continue
			var/obj/item/maybe_held = held_items[index]
			if(maybe_held)
				. += compound ? maybe_held.inv_slot_attached() : maybe_held
	else
		for(var/obj/item/held in held_items)
			. += compound ? held.inv_slot_attached() : held

// todo: old below

//* Basic *//

/**
 * Gets the item held in a given hand index
 *
 * * This expects a valid index.
 *
 * @return /obj/item or null.
 */
/mob/proc/get_item_in_hand(index)
	RETURN_TYPE(/obj/item)
	return inventory?.held_items[index]

/**
 * Gets the hand index that an item is in, if any.
 *
 * @return index of item, or null if not found.
 */
/datum/inventory/proc/get_held_index(obj/item/I)
	return held_items?.Find(I) || null

/**
 * Gets the hand index that an item is in, if any.
 *
 * @return index of item, or null if not found.
 */
/mob/proc/get_held_index(obj/item/I)
	return inventory?.held_items?.Find(I) || null

//* Special *//

/**
 * Get an indexed list of weakrefs or nulls of held items.
 *
 * * returns null if we have no inventory.
 */
/datum/inventory/proc/get_held_items_as_weakrefs()
	RETURN_TYPE(/list)
	. = new /list(length(held_items))
	for(var/i in 1 to length(held_items))
		.[i] = WEAKREF(held_items[i])

/**
 * Get an indexed list of weakrefs or nulls of held items.
 */
/mob/proc/get_held_items_as_weakrefs()
	RETURN_TYPE(/list)
	if(!inventory)
		return list()
	. = new /list(length(inventory.held_items))
	for(var/i in 1 to length(inventory.held_items))
		.[i] = WEAKREF(inventory.held_items[i])

//* Iteration *//

/**
 * @return list of held items
 */
/datum/inventory/proc/get_held_items()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/I in held_items)
		. += I

/**
 * @return list of held items
 */
/mob/proc/get_held_items()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/I in inventory?.held_items)
		. += I

/**
 * @return list of held items of type
 */
/datum/inventory/proc/get_held_items_of_type(type)
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/I as anything in held_items)
		if(istype(I, type))
			. += I

/**
 * @return list of held items of type
 */
/mob/proc/get_held_items_of_type(type)
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/I as anything in inventory?.held_items)
		if(istype(I, type))
			. += I

/**
 * @return first held item of type, if found
 */
/datum/inventory/proc/get_held_item_of_type(type)
	RETURN_TYPE(/obj/item)
	for(var/obj/item/I as anything in held_items)
		if(istype(I, type))
			return I

/**
 * @return first held item of type, if found
 */
/mob/proc/get_held_item_of_type(type)
	RETURN_TYPE(/obj/item)
	for(var/obj/item/I as anything in inventory?.held_items)
		if(istype(I, type))
			return I

/**
 * @return list of full hands
 */
/datum/inventory/proc/get_full_hand_indices()
	. = list()
	for(var/i in 1 to length(held_items))
		if(held_items[i])
			. += i

/**
 * @return list of full hands
 */
/mob/proc/get_full_hand_indices()
	. = list()
	for(var/i in 1 to length(inventory?.held_items))
		if(inventory.held_items[i])
			. += i

/**
 * @return list of empty hands
 */
/datum/inventory/proc/get_empty_hand_indices()
	. = list()
	for(var/i in 1 to length(held_items))
		if(!held_items[i])
			. += i

/**
 * @return list of empty hands
 */
/mob/proc/get_empty_hand_indices()
	. = list()
	for(var/i in 1 to length(inventory?.held_items))
		if(!inventory.held_items[i])
			. += i

//*                   By Side                       *//
//* This is not on /datum/inventory level as        *//
//* oftentimes a mob has no semantic 'sided hands'. *//

/**
 * returns first item on left
 */
/mob/proc/get_left_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(isnull(inventory?.held_items[i]))
			continue
		return inventory?.held_items[i]

/**
 * returns first item on right
 */
/mob/proc/get_right_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 2 to length(inventory?.held_items) step 2)
		if(isnull(inventory?.held_items[i]))
			continue
		return inventory?.held_items[i]

/**
 * returns all items on left
 */
/mob/proc/get_left_held_items()
	RETURN_TYPE(/obj/item)
	. = list()
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(isnull(inventory?.held_items[i]))
			continue
		. += inventory?.held_items[i]

/**
 * returns all items on right
 */
/mob/proc/get_right_held_items()
	RETURN_TYPE(/obj/item)
	. = list()
	for(var/i in 2 to length(inventory?.held_items) step 2)
		if(isnull(inventory?.held_items[i]))
			continue
		. += inventory?.held_items[i]
