//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* ID *//

/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_id(z)
	return ordered_levels[z]?.id

//* Adjacency *//

/**
 * returns level index in dir of level
 *
 * if diagonal, only returns a level if both steps are consistent with each other.
 */
/datum/controller/subsystem/mapping/proc/level_get_datum_in_dir(z, dir)
	if(dir & (dir - 1))
		// if diagonal, pass to level for advanced handling
		return ordered_levels[z].get_level_in_dir(dir)
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
/datum/controller/subsystem/mapping/proc/level_get_index_in_dir(z, dir)
	if(dir & (dir - 1))
		// if diagonal, pass to level for advanced handling
		return ordered_levels[z].get_level_in_dir(dir)?.z_index
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

//* Air *//

/datum/controller/subsystem/mapping/proc/level_get_indoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_indoors

/datum/controller/subsystem/mapping/proc/level_get_outdoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_outdoors

//* Attributes *//

/**
 * Returns an attribute of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_attribute(z, key)
	var/datum/map_level/L = ordered_levels[z]
	return L.get_attribute(key)

//* Base Turf / Area *//

/**
 * Gets baseturf type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_baseturf(z)
	var/datum/map_level/L = ordered_levels[z]
	return L.base_turf || world.turf
/**
 * Gets basearea type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_basearea(z)
	var/datum/map_level/L = ordered_levels[z]
	return L.base_area || world.area

//* Fluff *//

/**
 * returns the canon/IC-friendly level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_fluff_id(z)
	return ordered_levels[z]?.display_id

/**
 * returns the canon/IC-friendly level mame of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_get_fluff_name(z)
	return ordered_levels[z]?.display_name

//* Stack *//

/**
 * Gets the sorted Z stack list of a level - the levels accessible from a single level, in multiz
 */
/datum/controller/subsystem/mapping/proc/level_get_stack(z) as /list
	if(z_stack_dirty)
		recalculate_z_stack()
	var/list/L = z_stack_lookup[z]
	return L.Copy()

//* Struct *//

/**
 * Gets the parent map datum of a level.
 */
/datum/controller/subsystem/mapping/proc/level_get_map(z) as /datum/map
	return ordered_levels[z]?.parent_map
