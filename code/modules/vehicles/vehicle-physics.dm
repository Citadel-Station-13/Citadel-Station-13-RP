//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Returns if something is basically next to us.
 *
 * This is used because vehicles are potentially multi-tile and/or pixel moving.
 */
/obj/vehicle/proc/sufficiently_adjacent(atom/other)
	return bounds_dist(src, other) <= 16
