//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shieldcall handling datums
 */
/datum/shieldcall
	/// priority ; should never change once we're registered on something. lower has higher priority.
	var/priority = 0
	/// goes to mob when in inventory - whether equipped to slot or in hand
	/// do not modify while applied. it will not un/register properly.
	var/shields_in_inventory = TRUE

/**
 * sent over from the atom
 *
 * @params
 * * defending - the atom in question
 * * shieldcall_args - indexed list of shieldcall args.
 */
/datum/shieldcall/proc/handle_shieldcall(atom/defending, list/shieldcall_args)
	return
