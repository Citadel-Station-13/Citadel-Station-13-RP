//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets virual direction between two turfs
 *
 * If the atoms aren't in managed space, acts like get_dir_multiz - works on zstacks only or same level.
 *
 * Returns NONE for unreachable,
 * if A is in managed space and B isn't or vice versa,
 * OR if they both aren't and aren't in the same zlevel or zstack,
 * OR if hey both are and aren't in the same struct
 */
/datum/controller/subsystem/mapping/proc/get_virtual_dir(turf/A, turf/B)
	// todo: impl
	return get_dir(A, B)
	// A = get_turf(A)
	// B = get_turf(B)
	// if(A.z == B.z)
	// 	return get_dir(A, B)
	// if(!level_is_virtualized(A) || !level_is_virtualized(B))
	// 	// last ditch - check stacks
	// 	var/list/stack = z_stack_lookup
	// 	var/pos = stack.Find(B.z)
	// 	if(!pos)
	// 		return NONE		// couldn't find
	// 	// found, old get_dir_multiz
	// 	. = get_dir(A, B)
	// 	if(stack.Find(A.z) < pos)
	// 		. |= UP
	// 	else
	// 		. |= DOWN
	// 	return
	// if(struct_by_z[A.z] != struct_by_z[B.z])
	// 	return NONE
	// var/datum/space_level/S1 = ordered_levels[A.z]
	// var/datum/space_level/S2 = ordered_levels[B.z]
	// . = NONE
	// if(S1.struct_z > S2.struct_z)
	// 	. |= DOWN
	// else if(S1.struct_z < S2.struct_z)
	// 	. |= UP
	// if(S1.struct_x == S2.struct_x)
	// 	return . | (S1.struct_y > S2.struct_y? SOUTH : NORTH)
	// else if(S1.struct_y == S2.struct_y)
	// 	return . | (S1.struct_x > S2.struct_x? WEST : EAST)
	// else
	// 	. |= (S1.struct_y > S2.struct_y)? SOUTH : NORTH
	// 	. |= (S1.struct_x > S2.struct_x)? WEST : EAST
