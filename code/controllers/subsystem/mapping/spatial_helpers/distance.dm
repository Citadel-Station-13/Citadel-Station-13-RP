//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Get virtual distance between two turfs
 *
 * If the atoms aren't in managed space, acts ilke get_dist
 *
 * z_dist refers to the distance that zlevels count for - defaults to the z_canonical_dist of a struct, or 0 otherwise.
 *
 * Returns -1 for unreachable,
 * If A is in managed and B isn't, or vice versa,
 * OR if they both aren't and they aren't the same zlevel,
 * Or if they both are and aren't in the same struct.
 */
/datum/controller/subsystem/mapping/proc/get_virtual_dist(turf/A, turf/B, z_dist)
	// todo: get_dist after 515
	return get_manhattan_dist(A, B)
	// A = get_turf(A)
	// B = get_turf(B)
	// if(A.z == B.z)
	// 	return get_dist(A, B)
	// if(!is_level_virtualized(A) || !is_level_virtualized(B))
	// 	return -1
	// if(struct_by_z[A.z] != struct_by_z[B.z])
	// 	return -1
	// var/datum/space_level/S1 = ordered_levels[A.z]
	// var/datum/space_level/S2 = ordered_levels[B.z]
	// return sqrt(((S2.struct_x * world.maxx + B.x) - (S1.struct_x * world.maxx + A.x)) ** 2 + ((S2.struct_y * world.maxy + B.y) - (S1.struct_y * world.maxy + A.y)) ** 2 + ((S2.struct_z - S1.struct_z) * z_dist) ** 2)
