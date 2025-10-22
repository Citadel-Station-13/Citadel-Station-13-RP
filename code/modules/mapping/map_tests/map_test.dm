//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Unit tests for maps, basically.
 *
 * * This is not in unit test directory because it's also meant to be able to be ran
 *   by a mapper, while in game.
 */
/datum/map_test
	/// name
	var/name = "-- no name --"
	/// description
	var/desc = "A map test. For some reason, no one annotated it."

// todo: uh, finish this file. this is a WIP system.

/**
 * Run the test.
 *
 * * 'z_indices' is a suggestion; map tests are meant to run whole-world, running on specific
 *   levels is very slow.
 *
 * @params
 * * z_indices - indexes to run on.
 */
/datum/map_test/proc/run_test(list/z_indices)
	return

/**
 * Emit a string.
 */
/datum/map_test/proc/info(msg)
	return

/**
 * Emit an annotated string.
 */
/datum/map_test/proc/info_loc(turf/loc, atom/target, msg)
	return

/**
 * Emit a string.
 */
/datum/map_test/proc/warn(msg)
	return

/**
 * Emit an annotated string.
 */
/datum/map_test/proc/warn_loc(turf/loc, atom/target, msg)
	return

/**
 * Emit a string.
 */
/datum/map_test/proc/error(msg)
	return

/**
 * Emit an annotated string.
 */
/datum/map_test/proc/error_loc(turf/loc, atom/target, msg)
	return
