//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: deal with below; new inventory-level api, don't just mirror from mob?

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

/**
 * Drops all of the mob's held items.
 *
 * @params
 * * inv_op_flags - inventory operation flags
 *
 * @return Nothing
 */
/datum/inventory/proc/drop_held_items(inv_op_flags)
	for(var/obj/item/I in held_items)
		drop_item_to_ground(I, inv_op_flags)

/**
 * Drops all our held items.
 *
 * @params
 * * inv_op_flags - inventory operation flags
 *
 * @return Nothing
 */
/mob/proc/drop_held_items(inv_op_flags)
	for(var/obj/item/I as anything in get_held_items())
		inventory.drop_item_to_ground(I, inv_op_flags)

/**
 * Drops the item held in a given hand index.
 *
 * @params
 * * index - the hand index
 * * inv_op_flags - inventory operation flags
 *
 * @return INV_RETURN_* flags
 */
/datum/inventory/proc/drop_held_index(index, inv_op_flags)
	return drop_item_to_ground(get_held_index(index), inv_op_flags)

/**
 * Drops the item held in a given hand index.
 *
 * @params
 * * index - the hand index
 * * inv_op_flags - inventory operation flags
 *
 * @return INV_RETURN_* flags
 */
/mob/proc/drop_held_index(index, flags)
	return drop_item_to_ground(get_held_index(index), flags)
