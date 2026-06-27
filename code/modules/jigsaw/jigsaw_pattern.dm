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
	 * Set if we have
	 * 1. no holes
	 * 2. no concave spots inside
	 *
	 * basically, if we're a rectangle.
	 * this stops the grid generator from having to fit us over more spts than
	 * it needs to.
	 */
	var/convex_optimizations = FALSE

/datum/jigsaw_pattern/New(width, height, override_tile_cost)
	src.width = width
	src.height = height
	src.override_tile_cost = override_tile_cost

	src.pattern = new /list(width * height)

/datum/jigsaw_pattern/proc/get_tile_cost()
	if(!isnull(override_tile_cost))
		return override_tile_cost

	if(isnull(cached_tile_cost))
		cached_tile_cost = 0
		for(var/i in 1 to width * height)
			if(pattern[i])
				cached_tile_cost += 1

	return cached_tile_cost
