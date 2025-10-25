//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Sort by ascending struct z
 */
/proc/cmp_map_level_struct_z_asc(datum/map_level/A, datum/map_level/B)
	return A.struct_z - B.struct_z

/**
 * Returns load order. This is needed because z-mimic requires levels to be ascending in order for two
 * given multi-z levels.
 */
/proc/cmp_map_level_load_sequence(datum/map_level/A, datum/map_level/B)
	if(A.struct_x != B.struct_x)
		return A.struct_x - B.struct_x
	if(A.struct_y != B.struct_y)
		return A.struct_y - B.struct_y
	return A.struct_z - B.struct_z
