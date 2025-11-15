//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets virual direction between two turfs
 *
 * * Ignores up / down / vertical directions.
 *
 * @return null if unreachable, or direction
 */
/datum/controller/subsystem/mapping/proc/get_virtual_dir(turf/A, turf/B)
	var/datum/map_level/level_a = ordered_levels[A.z]
	var/datum/map_level/level_b = ordered_levels[B.z]
	if(level_a == level_b)
		return get_dir(A, B)
	if(level_a.parent_map != level_b.parent_map)
		return null

	. = NONE
	var/a_sx = level_a.struct_x
	var/a_sy = level_a.struct_y
	var/a_sz = level_a.struct_z
	var/b_sx = level_b.struct_x
	var/b_sy = level_b.struct_y
	var/b_sz = level_b.struct_z
	if(a_sx > b_sx)
		. |= WEST
	else if(a_sx < b_sx)
		. |= EAST
	else
		if(A.x > B.x)
			. |= WEST
		else if(A.x < B.x)
			. |= EAST
	if(a_sy > b_sy)
		. |= SOUTH
	else if(a_sy < b_sy)
		. |= NORTH
	else
		if(A.y > B.y)
			. |= SOUTH
		else if(A.y < B.y)
			. |= NORTH
