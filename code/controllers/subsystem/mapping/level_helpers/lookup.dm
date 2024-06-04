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
 *
 * if diagonal, only returns a level if both steps are consistent with each other.
 */
/datum/controller/subsystem/mapping/proc/level_datum_in_dir(z, dir)
	if(dir & (dir - 1))
		// if diagonal, pass to level for advanced handling
		return ordered_levels[z].level_in_dir(dir)?.z_index
	var/index
	switch(dir)
		if(NORTH)
			index = cached_level_north[z]
		if(SOUTH)
			index = cached_level_south[z]
		if(EAST)
			index = cached_level_east[z]
		if(WEST)
			index = cached_level_west[z]
		if(UP)
			index = cached_level_up[z]
		if(DOWN)
			index = cached_level_down[z]
	return ordered_levels[index]

/**
 * returns level index in dir of level
 *
 * if diagonal, only returns a level if both steps are consistent with each other.
 */
/datum/controller/subsystem/mapping/proc/level_index_in_dir(z, dir)
	if(dir & (dir - 1))
		// if diagonal, pass to level for advanced handling
		return ordered_levels[z].level_in_dir(dir)
	var/index
	switch(dir)
		if(NORTH)
			index = cached_level_north[z]
		if(SOUTH)
			index = cached_level_south[z]
		if(EAST)
			index = cached_level_east[z]
		if(WEST)
			index = cached_level_west[z]
		if(UP)
			index = cached_level_up[z]
		if(DOWN)
			index = cached_level_down[z]
	return index
