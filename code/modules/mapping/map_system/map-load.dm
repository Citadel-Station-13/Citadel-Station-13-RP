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

	var/datum/map_struct/created_struct
	if(create_struct)
		var/list/creating_grid = list()
		for(var/datum/map_level/level as anything in levels)
			if(!level.struct_create_pos)
				CRASH("no struct create pos on [level] ([level.resolve_map_path()])")
			if(creating_grid[level.struct_create_pos])
				var/datum/map_level/conflicting = creating_grid[level.struct_create_pos]
				CRASH("duplicate create pos [level.struct_create_pos] between [level] ([level.resolve_map_path]) and [conflicting][ ([conflicting.resolve_map_path()])]")
			creating_grid[level.struct_create_pos] = level
		created_struct = new
		if(!created_struct.construct(creating_grid, FALSE))
			CRASH("failed to create struct!")
	if(overmap_initializer)
		if(!created_struct)
			if(length(levels) > 1)
				CRASH("multi-z map without struct creation but with overmap initializer!")
			created_struct = new
			if(!created_struct.construct(list("0,0,0" = levels[1]), FALSE))
				CRASH("failed to auto-create 1-z default struct")
		overmap_initializer.initialize(creating)

/**
 * anything to do after loading with any dependencies
 *
 * called after level on_loaded_finalize's
 */
/datum/map/proc/on_loaded_finalize()
	SHOULD_CALL_PARENT(TRUE)

//* Unloading *//

// No hooks yet.
