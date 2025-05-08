//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets virual angle between two turfs in horizontal terms
 * IGNORES STRUCT Z DEPTH!
 *
 * Angle is clockwise from north.
 *
 * If the atoms aren't in managed space, acts like GetAngle
 *
 * Returns null for unreachable,
 * if A is in managed space and B isn't or vice versa,
 * OR if they both aren't and aren't in the same zlevel,
 * OR if hey both are and aren't in the same struct
 */
/datum/controller/subsystem/mapping/proc/get_virtual_angle(atom/A, atom/B)
	// todo: impl
	return get_visual_angle(A, B)
	// A = get_turf(A)
	// B = get_turf(B)
	// if(A.z == B.z)
	// 	return get_physics_angle(A, B)
	// if(!level_is_virtualized(A) || !level_is_virtualized(B))
	// 	return null
	// if(struct_by_z[A.z] != struct_by_z[B.z])
	// 	return null
	// var/datum/space_level/S1 = ordered_levels[A.z]
	// var/datum/space_level/S2 = ordered_levels[B.z]
	// return get_angle_direct(S1.struct_x * world.maxx + A.x, S1.struct_y * world.maxy + A.y, S2.struct_x * world.maxx + B.x, S2.struct_y * world.maxy + B.y)
