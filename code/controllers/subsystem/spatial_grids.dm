//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: Recover() that calls full_rebuild(); forcefully resets spatial grid and rebuilds component on all relevant auto-bound atoms.
//       why? because admins might fuck up and because things might break. don't argue about 'this isn't necessary if admins don't fuck up',
//       they **will** fuck up eventually and it's good practice to have error-recovery be built into things.

SUBSYSTEM_DEF(spatial_grids)
	name = "Spatial Grids"
	init_order = INIT_ORDER_SPATIAL_GRIDS
	init_stage = INIT_STAGE_WORLD
	subsystem_flags = SS_NO_FIRE

	/// /living mobs. they don't have to be alive, just a subtype of /living.
	var/datum/spatial_grid/living
	/// /obj/vehicle
	var/datum/spatial_grid/vehicles
	/// /obj/overmap/entity's
	var/datum/spatial_grid/overmap_entities

/datum/controller/subsystem/spatial_grids/Initialize()
	make_grids()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/spatial_grids/proc/make_grids()
	living = new /datum/spatial_grid(/mob/living)
	vehicles = new /datum/spatial_grid(/obj/vehicle)
	overmap_entities = new /datum/spatial_grid(/obj/overmap/entity)

/datum/controller/subsystem/spatial_grids/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	if(!initialized)
		return
	living?.sync_world_z(new_z_count)
	vehicles?.sync_world_z(new_z_count)
	overmap_entities?.sync_world_z(new_z_count)

/**
 * index = ceil(x / resolution) + width * (ceil(y / resolution) - 1)
 *
 * * at time of writing, spatial grids are intentionally aligned with turf reservation resolution. this is intentional so looking stuff up in grids on a reservation is lightning-fast.
 */
/datum/spatial_grid
	/// our grid; list[z] = grid: list()
	var/list/grids = list()
	/// our z-lookups; list[z] = list()
	///
	/// * only made if optimize_get_all_on_z is enabled
	var/list/z_all_atoms
	/// our grid width
	var/width
	/// our grid height
	var/height
	/// expected type
	var/expected_type = /atom/movable
	/// optimize get all atoms on z
	var/optimize_get_all_on_z = FALSE

/datum/spatial_grid/New(expected_type, init_flags)
	// initialize grid
	src.width = ceil(world.maxx / TURF_CHUNK_RESOLUTION)
	src.height = ceil(world.maxy / TURF_CHUNK_RESOLUTION)
	src.grids = list()
	src.expected_type = expected_type

	src.optimize_get_all_on_z = !!(init_flags & SPATIAL_GRID_INIT_OPTIMIZE_ALL_Z)
	if(src.optimize_get_all_on_z)
		src.z_all_atoms = list()

	sync_world_z(world.maxz)

/datum/spatial_grid/proc/sync_world_z(size)
	src.grids.len = max(src.grids.len, size)
	src.z_all_atoms?.len = max(src.z_all_atoms.len, size)
	for(var/i in 1 to size)
		if(src.grids[i])
			continue
		var/list/creating_grid = list()
		creating_grid.len = src.width * src.height
		src.grids[i] = creating_grid
	if(optimize_get_all_on_z)
		for(var/i in 1 to size)
			if(src.z_all_atoms[i])
				continue
			src.z_all_atoms[i] = list()

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

	if(optimize_get_all_on_z)
		z_all_atoms[z] += AM

/**
 * removes a movable
 */
/datum/spatial_grid/proc/direct_remove(atom/movable/AM, z, index)
	var/list/grid = grids[z]
	var/entry = grid[index]
	if(islist(entry))
		entry -= AM
		switch(length(entry))
			if(0)
				grid[index] = null
			if(1)
				grid[index] = entry[1]
	else
		grid[index] = null

	if(optimize_get_all_on_z)
		z_all_atoms[z] -= AM

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
	var/min_x = ceil((epicenter.x - distance) / TURF_CHUNK_RESOLUTION)
	var/min_y = ceil((epicenter.y - distance) / TURF_CHUNK_RESOLUTION)
	var/max_x = ceil((epicenter.x + distance) / TURF_CHUNK_RESOLUTION)
	var/max_y = ceil((epicenter.y + distance) / TURF_CHUNK_RESOLUTION)
	var/list/grid = src.grids[epicenter.z]
	for(var/x in max(1, min_x) to min(src.width, max_x))
		for(var/y in max(1, min_y) to min(src.height, max_y))
			var/index = x + src.width * (y - 1)
			if(grid[index])
				var/entry = grid[index]
				if(islist(entry))
					for(var/atom/movable/AM as anything in entry)
						if(get_dist(AM, epicenter) <= distance)
							. += AM
				else if(get_dist(entry, epicenter) <= distance)
					. += entry

/**
 * pixel movement query
 *
 * * distance is in chebyshev distance, which is the same as bounds_dist()
 *
 * @return list() of atoms
 */
/datum/spatial_grid/proc/pixel_query(atom/epicenter, distance)
	. = list()
	for(var/atom/movable/AM as anything in range_query(get_turf(epicenter), ceil(distance / WORLD_ICON_SIZE)))
		if(bounds_dist(epicenter, AM) <= distance)
			. += AM

/**
 * gets all registered movables
 *
 * * somewhat inefficient, why are you doing this?
 */
/datum/spatial_grid/proc/all_atoms(z)
	if(optimize_get_all_on_z)
		if(z)
			return z_all_atoms[z]:Copy()
		else
			var/list/built = list()
			for(var/i in 1 to world.maxz)
				built += z_all_atoms[i]
			return built

	. = list()
	if(z)
		var/list/grid = src.grids[z]
		for(var/i in 1 to length(grid))
			if(!grid[i])
				continue
			. += grid[i]
	else
		for(var/level in 1 to world.maxz)
			var/list/grid = src.grids[level]
			for(var/i in 1 to length(grid))
				if(!grid[i])
					continue
				. += grid[i]

//* basically the above but only within a certain turf reservation *//

/datum/spatial_grid/proc/reservation_range_query(datum/map_reservation/reservation, turf/epicenter, distance)
	ASSERT(reservation.spatial_z == epicenter.z)
	. = list()
	var/min_x = ceil((epicenter.x - distance) / TURF_CHUNK_RESOLUTION)
	var/min_y = ceil((epicenter.y - distance) / TURF_CHUNK_RESOLUTION)
	var/max_x = ceil((epicenter.x + distance) / TURF_CHUNK_RESOLUTION)
	var/max_y = ceil((epicenter.y + distance) / TURF_CHUNK_RESOLUTION)
	var/list/grid = src.grids[epicenter.z]
	for(var/x in max(1, min_x, reservation.spatial_bl_x) to min(src.width, max_x, reservation.spatial_tr_x))
		for(var/y in max(1, min_y, reservation.spatial_bl_y) to min(src.height, max_y, reservation.spatial_tr_y))
			var/index = x + src.width * (y - 1)
			if(grid[index])
				var/entry = grid[index]
				if(islist(entry))
					for(var/atom/movable/AM as anything in entry)
						if(get_dist(AM, epicenter) <= distance)
							. += AM
				else if(get_dist(entry, epicenter) <= distance)
					. += entry

/datum/spatial_grid/proc/reservation_all_atoms(datum/map_reservation/reservation)
	. = list()
	var/list/grid = src.grids[reservation.spatial_z]
	for(var/x in reservation.spatial_bl_x to reservation.spatial_tr_x)
		for(var/y in reservation.spatial_bl_y to reservation.spatial_tr_y)
			var/index = x + src.width * (y - 1)
			if(!grid[index])
				continue
			. += grid[index]

//* basically the above but only within a certain turf reservation, if reservation exists; otherwise, proceed as normal *//
//* if on a reservation level, but no reservation, we return nothing.                                                   *//

/datum/spatial_grid/proc/automatic_range_query(turf/epicenter, distance)
	// check if we're on a reserved level
	var/list/spatial_lookup = SSmapping.reservation_spatial_lookups[epicenter.z]
	if(!spatial_lookup)
		// we're not on a reserved level, use normal
		return range_query(epicenter, distance)
	// we're on a reserve level
	var/datum/map_reservation/reservation = spatial_lookup[ceil(epicenter.x / TURF_CHUNK_RESOLUTION) + (ceil(epicenter.y / TURF_CHUNK_RESOLUTION) - 1) * ceil(world.maxx / TURF_CHUNK_RESOLUTION)]
	// check if reservation exists
	if(reservation)
		// it does, get stuff in reservation
		return reservation_range_query(reservation, epicenter, distance)
	else
		// it doesn't, return nothing
		return list()
