//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/map_struct

/datum/map_struct/proc/do_construct(list/z_grid = src.z_grid, link, rebuild)
	PRIVATE_PROC(TRUE)

	// calculate and sort elevations
	// elevation_tuples = list[z] = elev
	var/list/elevation_tuples = list()
	for(var/i in 1 to length(z_planes))
		var/z_str = z_planes[i]
		var/list/datum/map_level/z_plane = z_planes[z_str]
		elevation_tuples["[z_str]"] = z_plane[1].ceiling_height || ceiling_height_default
	tim_sort(elevation_tuples, /proc/cmp_numeric_text_asc, TRUE)
	// unpack elevations
	var/list/elevation_tuple_z = list()
	var/list/elevation_tuple_height = list()
	for(var/z_str in elevation_tuples)
		var/height = elevation_tuples[z_str]
		elevation_tuple_z += text2num(z_str)
		elevation_tuple_height += height

	// set level data
	for(var/datum/map_level/level as anything in levels)
		if(level.struct_z == 0)
			level.virtual_elevation = 0
		else if(level.struct_z > 0)
			var/index_of_first_nonnegative
			var/total_height = 0
			for(index_of_first_nonnegative in 1 to length(elevation_tuple_z))
				if(elevation_tuple_z[index_of_first_nonnegative] >= 0)
					break
			var/last_virtual_z  = 0
			for(var/index in index_of_first_nonnegative to length(elevation_tuple_z))
				var/virtual_z = elevation_tuple_z[index]
				if(virtual_z != last_virtual_z)
					total_height += ceiling_height_default * ((virtual_z - 1) - last_virtual_z)
				// if it's on the level we're tallying to we ignore it as we don't tally ourselves
				// because virtual_elevation is meters off the ground.. of the ground.
				if(virtual_z == level.struct_z)
					break
				else if(virtual_z > level.struct_z)
					CRASH("overshot level somehow?")
				// tally current level
				total_height += elevation_tuple_height[index]
				// +1 to skip over the current level, which we already tallied
				last_virtual_z = virtual_z + 1
			level.virtual_elevation = total_height
		else if(level.struct_z < 0)
			var/index_of_first_negative
			var/total_height = 0
			for(index_of_first_negative in length(elevation_tuple_z) to 1 step -1)
				if(elevation_tuple_z[index_of_first_negative] < 0)
					break
			var/last_virtual_z = 0
			for(var/index in index_of_first_negative to 1 step -1)
				var/virtual_z = elevation_tuple_z[index]
				if(virtual_z != last_virtual_z)
					total_height -= ceiling_height_default * (last_virtual_z - (virtual_z + 1))
				// tally current level
				total_height -= elevation_tuple_height[index]
				// if we're on the level we're tallying to, we're done
				if(virtual_z == level.struct_z)
					break
				// sanity check
				else if(virtual_z < level.struct_z)
					CRASH("overshot level somehow?")
			level.virtual_elevation = total_height
