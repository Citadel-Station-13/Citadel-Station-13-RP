//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

SUBSYSTEM_DEF(spatial_grids)
	name = "Spatial Grids"
	init_order = INIT_ORDER_SPATIAL_GRIDS
	subsystem_flags = SS_NO_FIRE

	/// /living mobs. they don't have to be alive, just a subtype of /living.
	var/datum/spatial_grid/living

/datum/controller/subsystem/spatial_grids/Initialize()
	make_grids()
	return ..()

/datum/controller/subsystem/spatial_grids/proc/make_grids()
	living = new /datum/spatial_grid(/mob/living, 16)

/datum/controller/subsystem/spatial_grids/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	living.sync_world_z(new_z_count)

/**
 * index = ceil(x / resolution) + width * ceil(y / resolution)
 */
/datum/spatial_grid
	/// our grid; list[z] = grid: list()
	var/list/grids = list()
	/// our grid width
	var/width
	/// our grid height
	var/height
	/// our grid resolution in tiles
	var/resolution = 16
	/// expected type
	var/expected_type = /atom/movable

/datum/spatial_grid/New(expected_type, resolution)
	// make sure resolution is reasonable
	if(resolution <= 8 || resolution >= 128)
		stack_trace("invalid resolution: [resolution]")
		resolution = 16
	// initialize grid
	src.width = ceil(world.maxx / resolution)
	src.height = ceil(world.maxy / resolution)
	src.grids = new /list()
	src.resolution = resolution
	src.expected_type = expected_type

	sync_world_z(world.maxz)

/datum/spatial_grid/proc/sync_world_z(size)
	src.grids.len = max(src.grids.len, size)
	for(var/i in 1 to length(size))
		if(src.grids[i])
			continue
		src.grids[i] = new /list(src.width * src.height)

/**
 * injects a movable at an index
 */
/datum/spatial_grid/proc/direct_insert(atom/movable/AM, z, index)
	var/list/grid = grids[z]
	var/entry = grid[index]
	if(entry)
		if(islist(entry))
			grid[index] += AM
		else
			grid[index] = list(grid[index], AM)
	else
		grid[index] = AM

/**
 * removes a movable
 */
/datum/spatial_grid/proc/direct_remove(atom/movable/AM, z, index)
	var/list/grid = grids[z]
	var/entry = grid[index]
	if(islist(entry))
		entry -= AM
		if(length(entry) <= 1)
			grid[index] = entry
	else
		grid[index] = null

/**
 * queries things within distance in tiles
 *
 * * distance is in tiles
 * * our measurement of distance uses get_dist().
 * * return order is undefined!
 *
 * @return list() of atoms
 */
/datum/spatial_grid/proc/range_query(turf/epicenter, distance)
	. = list()
	var/min_x = ceil((epicenter.x - distance) / src.resolution)
	var/min_y = floor((epicenter.y - distance) / src.resolution)
	var/max_x = ceil((epicenter.x + distance) / src.resolution)
	var/max_y = floor((epicenter.y + distance) / src.resolution)
	var/list/grid = src.grids[epicenter.z]
	for(var/x in max(1, min_x) to min(src.width, max_x))
		for(var/y in max(1, min_y) to min(src.height, max_y))
			var/index = x + src.width * y
			if(grid[index])
				var/entry = grid[index]
				if(islist(entry))
					for(var/atom/movable/AM as anything in entry)
						if(get_dist(AM, epicenter) <= distance)
							. += AM
				else if(get_dist(entry, epicenter) <= distance)
					. += entry

/**
 * gets all registered movables
 *
 * * somewhat inefficient, why are you doing this?
 */
/datum/spatial_grid/proc/all_atoms(z)
	. = list()
	if(z)
		var/list/grid = src.grids[z]
		for(var/i in 1 to length(grid))
			if(!grid[i])
				continue
			. += grid[i]
	else
		for(var/i in 1 to world.maxz)
			var/list/grid = src.grids[i]
			for(var/i in 1 to length(grid))
				if(!grid[i])
					continue
				. += grid[i]
