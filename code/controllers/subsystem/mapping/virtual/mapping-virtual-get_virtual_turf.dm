//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Get turf on a map.
 * * `x_o` and `y_o` are in meters.
 * * Ignores up / down / vertical directions.
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

/**
 * TODO: optimize
 *
 * @params
 * * v_x - virtual x
 * * v_y - virtual y
 * * s_z - struct z
 */
/datum/controller/subsystem/mapping/proc/get_virtual_turf(datum/map/map, v_x, v_y, s_z)
	var/list/plane = map.loaded_z_planes["[s_z]"]
	if(!plane)
		return
	for(var/datum/map_level/level as anything in plane)
		if(v_x <= level.virtual_alignment_x)
			continue
		if(v_y <= level.virtual_alignment_y)
			continue
		if(v_x > level.virtual_alignment_x + world.maxx)
			continue
		if(v_y > level.virtual_alignment_y + world.maxx)
			continue
		return locate(v_x - level.virtual_alignment_x, v_y - level.virtual_alignment_y, level.z_index)
