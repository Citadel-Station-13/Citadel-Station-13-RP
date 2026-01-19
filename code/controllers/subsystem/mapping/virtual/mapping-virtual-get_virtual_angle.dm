//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets virtual horizontal compass angle between two turfs.
 * * undefined behavior if A / B are not turfs
 * * angle is clockwise from north.
 * * Ignores up / down / vertical directions.
 *
 * @return null unreachable or angle
 */
/datum/controller/subsystem/mapping/proc/get_virtual_angle(turf/A, turf/B)
	var/datum/map_level/level_a = ordered_levels[A.z]
	var/datum/map_level/level_b = ordered_levels[B.z]
	if(level_a == level_b)
		return get_visual_angle(A, B)
	if(level_a.parent_map != level_b.parent_map)
		return null

	return get_visual_angle_raw(
		level_a.virtual_alignment_x + A.x,
		level_a.virtual_alignment_y + A.y,
		level_b.virtual_alignment_x + B.x,
		level_b.virtual_alignment_y + B.y,
	)
