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
	// shit with no struct always goes last
	var/A_has_struct = A.is_in_struct()
	var/B_has_struct = B.is_in_struct()
	if(A_has_struct != B_has_struct)
		if(A_has_struct && !B_has_struct)
			return -1 // A before B
		else if(B_has_struct && !A_has_struct)
			return 1 // B before A
		CRASH("unreachable")
	if(A.struct_x != B.struct_x)
		return A.struct_x - B.struct_x
	if(A.struct_y != B.struct_y)
		return A.struct_y - B.struct_y
	return A.struct_z - B.struct_z
