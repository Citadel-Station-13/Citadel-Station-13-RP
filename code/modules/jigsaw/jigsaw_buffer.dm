//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_buffer_enqueued
	var/lower_left_x
	var/lower_left_y
	var/lower_left_z
	var/orientation
	var/datum/prototype/jigsaw_template/template
	var/datum/dmm_context/context

/**
 * * All lists are immutable and potentially (likely) shared for efficiency.
 */
/datum/jigsaw_buffer_tile
	var/x
	var/y
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

/datum/jigsaw_buffer_tile/New(datum/jigsaw_buffer_enqueued/enqueued, datum/jigsaw_tile/tile, x, y)
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

	src.x = x
	src.y = y

/datum/jigsaw_buffer_tile/Destroy()
	src.enqueued = null
	return ..()

/datum/jigsaw_buffer_tile/block_off

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
