//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * injects starting gear and equipment into maps.
 */
/datum/map_injection/starting_gear


#warn impl all

/**
 * a gear pack
 */
/datum/map_starting_gear
	/// list of typepaths associated to amounts
	///
	/// special handling:
	/// * /datum/material = amount
	/// * /obj/item/stack = amount
	var/list/gear = list()

/**
 * a gear pack - spread throughout markers
 */
/datum/map_starting_gear/distribute
	/// attempt to organize, instead of literally random
	var/organized = TRUE


/**
 * a gear pack - put in every spot with given tags
 */
/datum/map_starting_gear/stamp

