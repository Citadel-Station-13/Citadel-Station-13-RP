//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Get virtual distance between two turfs.
 * * Does not check vertical distance.
 * * Ignores up / down / vertical directions.
 */
/datum/controller/subsystem/mapping/proc/get_virtual_horizontal_dist(turf/A, turf/B)
	var/datum/map_level/level_a = ordered_levels[A.z]
	var/datum/map_level/level_b = ordered_levels[B.z]
	return max(
		abs((level_a.virtual_alignment_x + A.x) - (level_b.virtual_alignment_x + B.x)),
		abs((level_a.virtual_alignment_y + A.y) - (level_b.virtual_alignment_y + B.y)),
	)

/**
 * Get virtual distance between two turfs.
 * * Does not check vertical distance.
 * * Ignores up / down / vertical directions.
 */
/datum/controller/subsystem/mapping/proc/get_virtual_horizontal_euclidean_dist(turf/A, turf/B)
	var/datum/map_level/level_a = ordered_levels[A.z]
	var/datum/map_level/level_b = ordered_levels[B.z]
	return sqrt(
		((level_a.virtual_alignment_x + A.x) - (level_b.virtual_alignment_x + B.x)) ** 2,
		((level_a.virtual_alignment_y + A.y) - (level_b.virtual_alignment_y + B.y)) ** 2,
	)
