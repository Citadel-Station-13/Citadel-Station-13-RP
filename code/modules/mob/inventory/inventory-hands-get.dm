//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
 *
 * * returns null if we have no inventory.
 */
/mob/proc/get_held_items_as_weakrefs()
	RETURN_TYPE(/list)
	if(!inventory)
		return
	. = new /list(length(inventory.held_items))
	for(var/i in 1 to length(inventory.held_items))
		.[i] = WEAKREF(inventory.held_items[i])

#warn mirror & check below

//* By Side *//

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

//* Iteration *//

/**
 * returns held items
 */
/mob/proc/get_held_items()
	. = list()
	for(var/obj/item/I in inventory?.held_items)
		. += I

/**
 * get held items of type
 */
/mob/proc/get_held_items_of_type(type)
	. = list()
	for(var/obj/item/I as anything in get_held_items())
		if(istype(I, type))
			. += I

/**
 * get first held item of type
 */
/mob/proc/get_held_item_of_type(type)
	RETURN_TYPE(/obj/item)
	for(var/obj/item/I as anything in get_held_items())
		if(istype(I, type))
			return I

/**
 * get full indices
 */
/mob/proc/get_full_hand_indices()
	. = list()
	for(var/i in 1 to length(inventory?.held_items))
		if(!isnull(inventory?.held_items[i]))
			. += i

/**
 * get empty indices
 */
/mob/proc/get_empty_hand_indices()
	. = list()
	for(var/i in 1 to length(inventory?.held_items))
		if(isnull(inventory?.held_items[i]))
			. += i
