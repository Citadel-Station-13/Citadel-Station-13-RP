//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * registers a /movable in a spatial grid
 */
/datum/component/spatial_grid
	dupe_mode = COMPONENT_DUPE_SELECTIVE
	registered_type = /datum/component/spatial_grid
	/// target spatial grid
	var/datum/spatial_grid/grid
	/// target grid width
	var/grid_width
	/// last grid index
	var/current_index

/datum/component/spatial_grid/Initialize(datum/spatial_grid/grid)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	if(!grid)
		CRASH("attempted to make a spatial grid component without a grid ref")

	src.grid = grid
	src.grid_width = grid.width

/datum/component/spatial_grid/RegisterWithParent()
	. = ..()
	construct()

/datum/component/spatial_grid/UnregisterFromParent()
	teardown()
	return ..()

/datum/component/spatial_grid/CheckDupeComponent(datum/component/C, datum/spatial_grid/grid)
	return grid != src.grid

/datum/component/spatial_grid/proc/construct(atom/root = parent)
	while(ismovable(root))
		RegisterSignal(root, COMSIG_MOVABLE_MOVED, PROC_REF(update))
		root = root.loc
	if(isturf(root))
		var/idx = ceil(root.x / TURF_CHUNK_RESOLUTION) + grid_width * (ceil(root.y / TURF_CHUNK_RESOLUTION) - 1)
		grid.direct_insert(parent, root.z, idx)
		current_index = idx

/datum/component/spatial_grid/proc/teardown(atom/root = parent)
	while(ismovable(root))
		UnregisterSignal(root, COMSIG_MOVABLE_MOVED)
		root = root.loc
	if(isturf(root))
		grid.direct_remove(parent, root.z, current_index)
		current_index = null

/datum/component/spatial_grid/proc/update(atom/movable/source, atom/oldloc)
	var/atom/newloc = source.loc
	if(newloc == oldloc)
		return
	// turf --> turf, try to do an optimized, lazy update
	if(isturf(oldloc) && isturf(newloc) && (oldloc.z == newloc.z))
		var/new_index = ceil(newloc.x / TURF_CHUNK_RESOLUTION) + grid_width * (ceil(newloc.y / TURF_CHUNK_RESOLUTION) - 1)
		var/z = oldloc.z
		if(new_index != current_index)
			grid.direct_remove(parent, z, current_index)
			grid.direct_insert(parent, z, new_index)
			current_index = new_index
	// turf --> somewhere else or somewhere else --> turf or somewhere else --> somewhere else, do full cycle
	else
		teardown(oldloc)
		construct(newloc)
