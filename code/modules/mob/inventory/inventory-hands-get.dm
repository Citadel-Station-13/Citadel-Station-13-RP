//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

//* Basic *//

/**
 * Gets the item held in a given hand index
 *
 * * This expects a valid index.
 *
 * @return /obj/item or null.
 */
/datum/inventory/proc/get_held_item(index)
	RETURN_TYPE(/obj/item)
	return held_items[index]

/**
 * Gets the item held in a given hand index
 *
 * * This expects a valid index.
 *
 * @return /obj/item or null.
 */
/mob/proc/get_held_item(index)
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
		return I

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
/datum/inventory/proc/get_held_items_of_type(type)
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
