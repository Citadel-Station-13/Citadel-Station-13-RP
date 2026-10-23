//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_pattern
	var/width
	var/height
	var/override_tile_cost = null
	var/tmp/cached_tile_cost = null
	/**
	 * * index = (y - 1) * width + x, as a flat list.
	 * * this is as south-rotated. we iterate over this differently
	 *   if the thing accessing this wants a rotation.
	 */
	var/list/datum/jigsaw_tile/pattern

	/**
	 * Calculated attachment points.
	 * * list( list(x, y, orientation, list(match tags), list(require tags), list(exclude tags))... )
	 * * orientation is facing away from the join point; this allows
	 *   whatever is checking for valid joins to not have to rotate its own sense of sided-ness.
	 * * this allows a 'fast' linear list match/check for a given tag
	 *   rather than needing to rescan every time
	 * * calculated the first time we need it
	 * * x and y are in grid tiles, and are the offsets. '0, 0, NORTH, list(...)'
	 *   means the bottom left tile's SOUTH side has those tags, because
	 *   this allways an easy alignment check (as a NORTH side of a tile needs to match it).
	 * * As another example, `3, 0, WEST, list(...)` means the **fourth** tile (0-indexed for offset!)
	 *   from the left, on the bottom row, has those tags on the EAST side.
	 * * As another example, `1, 2, SOUTH, list(...)` means the second tile from the left,
	 *   third from the bottom, has those tags on the NORTH side.
	 */
	var/list/calculated_attachment_points

/datum/jigsaw_pattern/New(width, height, override_tile_cost)
	src.width = width
	src.height = height
	src.override_tile_cost = override_tile_cost

	src.pattern = new /list(width * height)

/datum/jigsaw_pattern/proc/drop_cache()
	cached_tile_cost = null
	calculated_attachment_points = null

/datum/jigsaw_pattern/proc/get_tile_cost()
	if(!isnull(override_tile_cost))
		return override_tile_cost

	if(isnull(cached_tile_cost))
		cached_tile_cost = 0
		for(var/i in 1 to width * height)
			if(pattern[i])
				cached_tile_cost += 1

	return cached_tile_cost

/datum/jigsaw_pattern/proc/get_attachment_points()
	if(calculated_attachment_points)
		return calculated_attachment_points

	calculated_attachment_points = list()

	for(var/x in 1 to width)
		for(var/y in 1 to height)
			var/datum/jigsaw_tile/tile = pattern[(y - 1) * width + x]

			// north
			if(tile.north_tags)
				var/is_edge = y == height || !pattern[(y) * width + x]
				if(is_edge)
					calculated_attachment_points[++calculated_attachment_points.len] = list(
						x - 1,
						y - 1,
						SOUTH,
						tile.north_tags,
						tile.north_require,
						tile.north_exclude,
					)

			// south
			if(tile.south_tags)
				var/is_edge = y == 1 || !pattern[(y - 2) * width + x]
				if(is_edge)
					calculated_attachment_points[++calculated_attachment_points.len] = list(
						x - 1,
						y - 1,
						NORTH,
						tile.south_tags,
						tile.south_require,
						tile.south_exclude,
					)

			// east
			if(tile.east_tags)
				var/is_edge = x == width || !pattern[(y - 1) * width + (x + 1)]
				if(is_edge)
					calculated_attachment_points[++calculated_attachment_points.len] = list(
						x - 1,
						y - 1,
						WEST,
						tile.east_tags,
						tile.east_require,
						tile.east_exclude,
					)

			// west
			if(tile.west_tags)
				var/is_edge = x == 1 || !pattern[(y - 1) * width + (x - 1)]
				if(is_edge)
					calculated_attachment_points[++calculated_attachment_points.len] = list(
						x - 1,
						y - 1,
						EAST,
						tile.west_tags,
						tile.west_require,
						tile.west_exclude,
					)

	return calculated_attachment_points
