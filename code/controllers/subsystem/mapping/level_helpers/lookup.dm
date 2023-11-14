//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_id(z)
	return ordered_levels[z]?.id

/**
 * returns the canon/IC-friendly level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_id(z)
	return ordered_levels[z]?.display_id

/**
 * returns the map level name of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_name(z)
	return ordered_levels[z]?.name

/**
 * returns the canon/IC-friendly level mame of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_name(z)
	return ordered_levels[z]?.display_name

/**
 * returns level datum in dir of level
 */
/datum/controller/subsystem/mapping/proc/level_datum_in_dir(z, dir)
	#warn impl

/**
 * returns level index in dir of level
 */
/datum/controller/subsystem/mapping/proc/level_index_in_dir(z, dir)
	#warn impl
