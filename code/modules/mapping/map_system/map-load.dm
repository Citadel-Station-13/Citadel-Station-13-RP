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
	for(var/idx in 1 to length(levels))
		var/datum/map_level/level = levels[idx]
		loaded_z_indices += level.z_index

		if(level.is_in_struct())
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

	for(var/x_y_str in loaded_z_stacks)
		var/list/levels_in_stack = loaded_z_stacks[x_y_str]
		tim_sort(levels_in_plane, /proc/cmp_map_level_struct_z_asc)
	for(var/z_str in loaded_z_planes)
		var/list/levels_in_plane = loaded_z_planes[z_str]
		tim_sort(levels_in_plane, /proc/cmp_map_level_load_sequence)

	loaded_sparse_size_x = struct_max_x - struct_min_x + 1
	loaded_sparse_size_y = struct_max_y - struct_min_y + 1
	loaded_sparse_size_z = struct_max_z - struct_min_z + 1

	if(overmap_initializer)
		if(!created_struct)
			if(length(levels) > 1)
				CRASH("multi-z map without struct creation but with overmap initializer!")
			created_struct = new
			if(!created_struct.construct(list("0,0,0" = levels[1]), rebuild = FALSE))
				CRASH("failed to auto-create 1-z default struct")
		SSovermaps.initialize_entity(overmap_initializer, created_struct)

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
