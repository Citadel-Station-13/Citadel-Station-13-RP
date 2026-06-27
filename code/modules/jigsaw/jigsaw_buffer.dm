//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_buffer_enqueued
	var/lower_left_grid_x
	var/lower_left_grid_y
	var/orientation
	var/datum/prototype/jigsaw_template/template
	var/datum/dmm_context/context

/**
 * * All lists are immutable and potentially (likely) shared for efficiency.
 */
/datum/jigsaw_buffer_tile
	var/grid_x
	var/grid_y

	var/blocked_off = FALSE

/datum/jigsaw_buffer_tile/New(grid_x, grid_y)
	src.grid_x = grid_x
	src.grid_y = grid_y

/datum/jigsaw_buffer_tile/enqueued
	var/datum/jigsaw_buffer_enqueued/enqueued

	var/list/north_match
	var/list/north_require
	var/list/north_exclude

	var/list/south_match
	var/list/south_require
	var/list/south_exclude

	var/list/east_match
	var/list/east_require
	var/list/east_exclude

	var/list/west_match
	var/list/west_require
	var/list/west_exclude

/datum/jigsaw_buffer_tile/New(grid_x, grid_y, datum/jigsaw_buffer_enqueued/enqueued, datum/jigsaw_buffer_tile/tile)
	..(grid_x, grid_y)

	src.enqueued = enqueued

	src.north_match = tile.north_match
	src.north_require = tile.north_require
	src.north_exclude = tile.north_exclude

	src.south_match = tile.south_match
	src.south_require = tile.south_require
	src.south_exclude = tile.south_exclude

	src.east_match = tile.east_match
	src.east_require = tile.east_require
	src.east_exclude = tile.east_exclude

	src.west_match = tile.west_match
	src.west_require = tile.west_require
	src.west_exclude = tile.west_exclude

/datum/jigsaw_buffer_tile/enqueued/Destroy()
	src.enqueued = null
	return ..()

/datum/jigsaw_buffer_tile/block_off
	blocked_off = TRUE

/**
 * Datum used to hold current state for a jigsaw dungeon generation.
 */
/datum/jigsaw_buffer
	var/width
	var/height
	/**
	 * Grid. This is a flat spatial grid with width x height of the intended generation.
	 * * This is indexed as [x + width * (y - 1)], starting at 1,1 as lower left.
	 * * Value is a /datum/jigsaw_buffer_tile or null
	 */
	var/list/grid

	/**
	 * Loaded into world?
	 */
	var/loaded = FALSE

	/**
	 * List of enqueued placements.
	 */
	var/list/datum/jigsaw_buffer_enqueued/enqueued = list()
	/**
	 * List of map contexts.
	 */
	var/list/datum/map_context/enqueued_contexts = list()

/datum/jigsaw_buffer/New(width, height)
	src.width = width
	src.height = height

	src.grid = new /list(src.width * src.height)

/datum/jigsaw_buffer/Destroy()
	cleanup()
	return ..()

/datum/jigsaw_buffer/proc/get_tile_width()
	return src.width * TURF_ALIGNMENT

/datum/jigsaw_buffer/proc/get_tile_height()
	return src.height * TURF_ALIGNMENT

/datum/jigsaw_buffer/proc/fits_in_world_at(lower_left_x, lower_left_y)
	if(lower_left_x < 1 || lower_left_y < 1)
		return FALSE

	if(lower_left_x + src.get_tile_width() - 1 > world.maxx)
		return FALSE

	if(lower_left_y + src.get_tile_height() - 1 > world.maxy)
		return FALSE

	return TRUE

/datum/jigsaw_buffer/proc/block_off_according_to_world_at(lower_left_x, lower_left_y, respect_worldgen_overwrite_flags)
	// scan for obstructions
	var/x_low = lower_left_x
	var/y_low = lower_left_y
	var/x_high = lower_left_x + src.get_tile_width() - 1
	var/y_high = lower_left_y + src.get_tile_height() - 1

	for(var/x_broad in x_low to x_high step TURF_ALIGNMENT)
		for(var/y_broad in y_low to y_high step TURF_ALIGNMENT)
			var/real_grid_x = floor((x_broad - x_low) / TURF_ALIGNMENT)
			var/real_grid_y = floor((y_broad - y_low) / TURF_ALIGNMENT)

			if(src.grid[real_grid_x + src.width * (real_grid_y - 1)])
				continue

			var/found_obstruction = FALSE
			for(var/x_narrow in x_broad to x_broad + TURF_ALIGNMENT - 1)
				if(found_obstruction)
					break
				for(var/y_narrow in y_broad to y_broad + TURF_ALIGNMENT - 1)
					var/turf/T = locate(x_narrow, y_narrow, z)
					var/area/A = T.loc

					if(A.special)
						found_obstruction = TRUE
						break
					if(!A.allow_worldgen_overwrite && respect_worldgen_overwrite_flags)
						found_obstruction = TRUE
						break

			if(found_obstruction)
				src.grid[real_grid_x + src.width * (real_grid_y - 1)] = new /datum/jigsaw_buffer_tile/block_off(real_grid_x, real_grid_y)
				continue


// var/idx = ceil(root.x / TURF_ALIGNMENT) + grid_width * (ceil(root.y / TURF_ALIGNMENT) - 1)

#warn impl

/datum/jigsaw_buffer/proc/cleanup()
	for(var/i in 1 to length(grid))
		var/datum/jigsaw_buffer_tile/tile = grid[i]
		if(tile)
			qdel(tile)
	grid = list()

	QDEL_LIST(enqueued)
	QDEL_LIST(enqueued_contexts)
