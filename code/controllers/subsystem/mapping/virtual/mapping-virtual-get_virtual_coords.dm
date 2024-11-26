//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Get a coordinate set of list(x, y, z) of virtual coordinates for an turf.
 *
 * Note: Z should be interpreted as DEPTH here, not real sector Z. Every world_struct starts at z = 1.
 * Also, x, y, and z can all be negative here.
 */
/datum/controller/subsystem/mapping/proc/get_virtual_coords(turf/A)
	// todo: impl
	return list(A.x, A.y, A.z)
	// A = get_turf(A)
	// if(!struct_by_z[A.z])
	// 	return list(A.x, A.y, A.z)
	// var/datum/world_struct/struct = struct_by_z[A.z]
	// var/datum/space_level/S = ordered_levels[A.z]
	// return list((S.struct_x * world.maxx) + A.x , (S.struct_y * world.maxy) + A.y, S.struct_z)
