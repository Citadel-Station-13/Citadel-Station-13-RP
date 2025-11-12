//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Get turf on a map.
 * * `x_o` and `y_o` are in meters.
 *
 * TODO: support elevation.
 * @return turf or null
 */
/datum/controller/subsystem/mapping/proc/get_virtual_turf_of_offset(turf/from_turf, x_o, y_o)
	// x_o, y_o are now 0-indexed starting from the lower left turf of a level
	x_o = from_turf.x + x_o - 1
	y_o = from_turf.y + y_o - 1
	var/s_xo = floor(x_o / world.maxx)
	var/s_yo = floor(y_o / world.maxy)
	// TODO: string ops are bad can we not do this please
	var/datum/map_level/our_level = ordered_levels[from_turf.z]
	var/datum/map_level/offset_level = our_level.parent_map.loaded_z_grid["[our_level.struct_x + s_xo],[our_level.struct_y + s_yo],[our_level.struct_z]"]
	if(!offset_level)
		return null
	x_o %= world.maxx
	y_o %= world.maxy

	return locate(
		(x_o > 0 ? x_o : (world.maxx - x_o)) + 1,
		(y_o > 0 ? y_o : (world.maxy - y_o)) + 1,
		offset_level.z_index,
	);
