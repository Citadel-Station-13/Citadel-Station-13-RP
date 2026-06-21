//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generation_enqueued
	var/lower_left_x
	var/lower_left_y
	var/lower_left_z
	var/orientation
	var/datum/jigsaw_template/template

/datum/jigsaw_generation_tile
	var/x
	var/y
	var/datum/jigsaw_generation_enqueued/enqueued
	var/list/north_match
	var/list/north_exclude
	var/list/south_match
	var/list/south_exclude
	var/list/east_match
	var/list/east_exclude
	var/list/west_match
	var/list/west_exclude

/datum/jigsaw_generation_tile/New(x, y)
	src.x = x
	src.y = y

/datum/jigsaw_generation_tile/block_off

/**
 * Datum used to hold current state for a jigsaw dungeon generation.
 */
/datum/jigsaw_generation
	var/alignment
	var/width
	var/height
	/**
	 * Grid. This is a flat spatial grid with width x height of the intended generation.
	 * * This is indexed as [x + width * (y - 1)], starting at 1,1 as lower left.
	 * * Value is a /datum/jigsaw_generation_tile or null
	 */
	var/list/grid
	/**
	 * List of enqueued placements.
	 */
	var/list/datum/jigsaw_generation_enqueued/enqueued = list()

/datum/jigsaw_generation/New(alignment, width, height)
	src.alignment = alignment
	src.width = width
	src.height = height

	src.grid = new /list(src.width * src.height)

/datum/jigsaw_generation/proc/get_tile_width()
	return src.width * src.alignment

/datum/jigsaw_generation/proc/get_tile_height()
	return src.height * src.alignment

// var/idx = ceil(root.x / TURF_CHUNK_RESOLUTION) + grid_width * (ceil(root.y / TURF_CHUNK_RESOLUTION) - 1)

#warn impl

/datum/jigsaw_generation/proc/cleanup()
	QDEL_LIST(enqueued)

	for(var/i in 1 to length(grid))
		var/datum/jigsaw_generation_tile/tile = grid[i]
		if(tile)
			qdel(tile)
	grid = list()
