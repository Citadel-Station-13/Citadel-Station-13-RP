//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Get a coordinate set of list(x, y) of virtual coordinates for an turf.
 * @return (x, y)
 */
/datum/controller/subsystem/mapping/proc/get_virtual_coords_x_y(turf/A)
	var/datum/map_level/level = ordered_levels[A.z]
	return list(
		level.virtual_alignment_x + A.x,
		level.virtual_alignment_y + A.y,
	)

/**
 * Get a coordinate set of list(x, y, elevation) of virtual coordinates for an turf.
 * @return (x, y, elevation)
 */
/datum/controller/subsystem/mapping/proc/get_virtual_coords_x_y_elevation(turf/A)
	var/datum/map_level/level = ordered_levels[A.z]
	return list(
		level.virtual_alignment_x + A.x,
		level.virtual_alignment_y + A.y,
		level.virtual_elevation,
	)

/**
 * Get a coordinate set of list(x, y, z) of virtual coordinates for an turf.
 * @return (x, y, z)
 */
/datum/controller/subsystem/mapping/proc/get_virtual_coords_x_y_z(turf/A)
	var/datum/map_level/level = ordered_levels[A.z]
	return list(
		level.virtual_alignment_x + A.x,
		level.virtual_alignment_y + A.y,
		level.struct_z,
	)
