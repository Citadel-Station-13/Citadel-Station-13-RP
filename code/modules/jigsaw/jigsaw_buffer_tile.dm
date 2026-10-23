//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * * All lists are immutable and potentially (likely) shared for efficiency.
 */
/datum/jigsaw_buffer_tile
	var/grid_x
	var/grid_y

	var/blocked_off = FALSE

	/**
	 * * Nullable
	 */
	var/datum/jigsaw_buffer_enqueued/enqueued

	var/list/north_tags
	var/list/north_require
	var/list/north_exclude

	var/list/south_tags
	var/list/south_require
	var/list/south_exclude

	var/list/east_tags
	var/list/east_require
	var/list/east_exclude

	var/list/west_tags
	var/list/west_require
	var/list/west_exclude

/datum/jigsaw_buffer_tile/New(grid_x, grid_y, datum/jigsaw_buffer_enqueued/enqueued, datum/jigsaw_tile/tile, orientation)
	src.grid_x = grid_x
	src.grid_y = grid_y

	if(enqueued)
		src.enqueued = enqueued

	if(tile)
		switch(orientation)
			// yeah so the fun part
			// these get rotated based on orientation
			// because these are always true-north (oriented to the buffer as a whole)

			if(SOUTH)
				// 0 deg clockwise

				src.north_tags = tile.north_tags
				src.north_require = tile.north_require
				src.north_exclude = tile.north_exclude

				src.south_tags = tile.south_tags
				src.south_require = tile.south_require
				src.south_exclude = tile.south_exclude

				src.east_tags = tile.east_tags
				src.east_require = tile.east_require
				src.east_exclude = tile.east_exclude

				src.west_tags = tile.west_tags
				src.west_require = tile.west_require
				src.west_exclude = tile.west_exclude

			if(NORTH)
				// 180 deg clockwise

				src.north_tags = tile.south_tags
				src.north_require = tile.south_require
				src.north_exclude = tile.south_exclude

				src.south_tags = tile.north_tags
				src.south_require = tile.north_require
				src.south_exclude = tile.north_exclude

				src.east_tags = tile.west_tags
				src.east_require = tile.west_require
				src.east_exclude = tile.west_exclude

				src.west_tags = tile.east_tags
				src.west_require = tile.east_require
				src.west_exclude = tile.east_exclude

			if(EAST)
				// 270 deg clockwise / 90 deg counterclockwise

				src.north_tags = tile.east_tags
				src.north_require = tile.east_require
				src.north_exclude = tile.east_exclude

				src.south_tags = tile.west_tags
				src.south_require = tile.west_require
				src.south_exclude = tile.west_exclude

				src.east_tags = tile.south_tags
				src.east_require = tile.south_require
				src.east_exclude = tile.south_exclude

				src.west_tags = tile.north_tags
				src.west_require = tile.north_require
				src.west_exclude = tile.north_exclude

			if(WEST)
				// 90 deg clockwise / 270 deg counterclockwise

				src.north_tags = tile.west_tags
				src.north_require = tile.west_require
				src.north_exclude = tile.west_exclude

				src.south_tags = tile.east_tags
				src.south_require = tile.east_require
				src.south_exclude = tile.east_exclude

				src.east_tags = tile.north_tags
				src.east_require = tile.north_require
				src.east_exclude = tile.north_exclude

				src.west_tags = tile.south_tags
				src.west_require = tile.south_require
				src.west_exclude = tile.south_exclude

/datum/jigsaw_buffer_tile/Destroy()
	src.enqueued = null
	return ..()

/datum/jigsaw_buffer_tile/block_off
	blocked_off = TRUE
