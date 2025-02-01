//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: deal with below; new inventory-level api, don't just mirror from mob?

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

/**
 * Returns if the mob is holding something in hand.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/is_holding(obj/item/I)
	return !!get_held_index(I)

/**
 * Returns if we are holding something in hand.
 */
/mob/proc/is_holding(obj/item/I)
	return !!get_held_index(I)

/**
 * Returns the number of nominal hand slots that are empty.
 *
 * @return number
 */
/datum/inventory/proc/count_empty_hands()
	. = 0
	for(var/i in 1 to length(held_items))
		if(isnull(held_items[i]))
			.++

/**
 * Returns the number of empty hands we have.
 *
 * * This is not based on usable hands, this based on the hands in our inventory, e.g. nominal hand count.
 * * This is 0 if we have no inventory.
 *
 * @return number
 */
/mob/proc/count_empty_hands()
	. = 0
	for(var/i in 1 to length(inventory?.held_items))
		if(isnull(inventory.held_items[i]))
			.++

/**
 * Returns the number of nominal hand slots that are full.
 *
 * @return number
 */
/datum/inventory/proc/count_full_hands()
	. = 0
	for(var/i in 1 to length(held_items))
		if(isnull(held_items[i]))
			continue
		.++

/**
 * Returns the number of full hands we have.
 *
 * * This is not based on usable hands, this based on the hands in our inventory, e.g. nominal hand count.
 * * This is 0 if we have no inventory.
 *
 * @return number
 */
/mob/proc/count_full_hands()
	. = 0
	for(var/i in 1 to length(inventory?.held_items))
		if(isnull(inventory.held_items[i]))
			continue
		.++
