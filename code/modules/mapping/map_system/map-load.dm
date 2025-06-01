//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains loading / unloading logic.
 */

//* Loading *//

/**
 * anything to do immediately on load
 *
 * called after level on_loaded_immediate's
 */
/datum/map/proc/on_loaded_immediate()
	SHOULD_CALL_PARENT(TRUE)

	loaded = TRUE
	loaded_z_indices = list()
	loaded_z_grid = list()
	loaded_z_stacks = list()
	loaded_z_planes = list()

	var/struct_min_x = INFINITY
	var/struct_min_y = INFINITY
	var/struct_min_z = INFINITY
	var/struct_max_x = -INFINITY
	var/struct_max_y = -INFINITY
	var/struct_max_z = -INFINITY

	var/list/elevation_by_z_str = list()

	// gather level data for loaded lists, and give levels virtual alignment here
	for(var/idx in 1 to length(levels))
		var/datum/map_level/level = levels[idx]
		loaded_z_indices += level.z_index

		if(!level.struct_active)
			continue
		loaded_z_grid["[level.struct_x],[level.struct_y],[level.struct_z]"] = level

		struct_min_x = min(struct_min_x, level.struct_x)
		struct_max_x = max(struct_max_x, level.struct_x)
		struct_min_y = min(struct_min_y, level.struct_y)
		struct_max_y = max(struct_max_y, level.struct_y)
		struct_min_z = min(struct_min_z, level.struct_z)
		struct_max_z = max(struct_max_z, level.struct_z)

		var/x_y_str = "[level.struct_x],[level.struct_y]"
		if(!loaded_z_stacks[x_y_str])
			loaded_z_stacks[x_y_str] = list()
		loaded_z_stacks[x_y_str] += level

		var/z_str = "[level.struct_z]"
		if(!loaded_z_planes[z_str])
			loaded_z_planes[z_str] = list()
		loaded_z_planes[z_str] += level

		level.virtual_alignment_x = level.struct_x * (world.maxx - LEVEL_BORDER_WIDTH * 2) - LEVEL_BORDER_WIDTH
		level.virtual_alignment_y = level.struct_y * (world.maxy - LEVEL_BORDER_WIDTH * 2) - LEVEL_BORDER_WIDTH

	// sort z stacks
	for(var/x_y_str in loaded_z_stacks)
		var/list/datum/map_level/levels_in_stack = loaded_z_stacks[x_y_str]
		tim_sort(levels_in_stack, /proc/cmp_map_level_struct_z_asc)
	// sort z planes and gather elevations
	for(var/z_str in loaded_z_planes)
		var/list/datum/map_level/levels_in_plane = loaded_z_planes[z_str]
		tim_sort(levels_in_plane, /proc/cmp_map_level_load_sequence)
		elevation_by_z_str["[z_str]"] = levels_in_plane[1].ceiling_height || ceiling_height_default

	// calculate loaded sparse size
	loaded_sparse_size_x = struct_max_x - struct_min_x + 1
	loaded_sparse_size_y = struct_max_y - struct_min_y + 1
	loaded_sparse_size_z = struct_max_z - struct_min_z + 1

	// sort elevations bottom to top
	tim_sort(elevation_by_z_str, /proc/cmp_numeric_text_asc)
	// convert elevations to lockstep
	var/list/elevation_lockstep_indices = list()
	var/list/elevation_lockstep_heights = list()
	for(var/i in 1 to length(elevation_by_z_str))
		var/z_str = elevation_by_z_str[i]
		elevation_lockstep_indices += text2num(z_str)
		elevation_lockstep_heights += elevation_by_z_str[z_str]
	// compute and set elevations on levels
	for(var/datum/map_level/level as anything in levels)
		if(!level.struct_active)
			continue
		if(level.struct_z > 0)
			var/index_of_first_nonnegative
			var/total_height = 0
			for(index_of_first_nonnegative in 1 to length(elevation_lockstep_indices))
				if(elevation_lockstep_indices[index_of_first_nonnegative] >= 0)
					break
			var/last_virtual_z  = 0
			for(var/index in index_of_first_nonnegative to length(elevation_lockstep_indices))
				var/virtual_z = elevation_lockstep_indices[index]
				if(virtual_z != last_virtual_z)
					total_height += ceiling_height_default * ((virtual_z - 1) - last_virtual_z)
				// if it's on the level we're tallying to we ignore it as we don't tally ourselves
				// because virtual_elevation is meters off the ground.. of the ground.
				if(virtual_z == level.struct_z)
					break
				else if(virtual_z > level.struct_z)
					CRASH("overshot level somehow?")
				// tally current level
				total_height += elevation_lockstep_heights[index]
				// +1 to skip over the current level, which we already tallied
				last_virtual_z = virtual_z + 1
			level.virtual_elevation = total_height
		else if(level.struct_z < 0)
			var/index_of_first_negative
			var/total_height = 0
			for(index_of_first_negative in length(elevation_lockstep_indices) to 1 step -1)
				if(elevation_lockstep_indices[index_of_first_negative] < 0)
					break
			var/last_virtual_z = 0
			for(var/index in index_of_first_negative to 1 step -1)
				var/virtual_z = elevation_lockstep_indices[index]
				if(virtual_z != last_virtual_z)
					total_height -= ceiling_height_default * (last_virtual_z - (virtual_z + 1))
				// tally current level
				total_height -= elevation_lockstep_heights[index]
				// if we're on the level we're tallying to, we're done
				if(virtual_z == level.struct_z)
					break
				// sanity check
				else if(virtual_z < level.struct_z)
					CRASH("overshot level somehow?")
			level.virtual_elevation = total_height

	if(overmap_initializer)
		SSovermaps.initialize_entity(overmap_initializer, src)

/**
 * anything to do after loading with any dependencies
 *
 * called after level on_loaded_finalize's
 */
/datum/map/proc/on_loaded_finalize()
	SHOULD_CALL_PARENT(TRUE)

//* Unloading *//

/**
 * TOOD: not hooked in yet
 *
 * Fired before zclear fires on the zlevels that consist of us
 * * Levels have their on_unload_pre_zclear called before this.
 */
/datum/map/proc/on_unload_pre_zclear()
	SHOULD_CALL_PARENT(TRUE)

/**
 * TOOD: not hooked in yet
 *
 * Fired after zclear fires on the zlevels that consist of us
 * * Levels have their on_unload_finalize called before this.
 * * zlevels and then ourselves are un-referenced and/or garbage collected (if necessary) after.
 */
/datum/map/proc/on_unload_finalize()
	SHOULD_CALL_PARENT(TRUE)

	loaded = FALSE
	loaded_z_indices = null
	loaded_z_grid = null
	loaded_sparse_size_x = null
	loaded_sparse_size_y = null
	loaded_sparse_size_z = null
	loaded_z_planes = null
	loaded_z_stacks = null

	for(var/datum/map_level/level as anything in levels)
		level.virtual_alignment_x = null
		level.virtual_alignment_y = null
		level.virtual_elevation = null
