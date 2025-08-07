//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This is the basic get multiz step.
 * It will not look across lateral transitions, only up/down.
 */
/proc/get_vertical_step(atom/A, dir)
	if((dir & (UP|DOWN)) == 0)
		return get_step(A, dir)
	var/turf/T = get_turf(A)
	if(dir & UP)
		return get_step(locate(T.x, T.y, SSmapping.cached_level_up[T.z]), dir & ~UP)
	if(dir & DOWN)
		return get_step(locate(T.x, T.y, SSmapping.cached_level_down[T.z]), dir & ~DOWN)

/**
 * Basic multiz get dir
 * Will not look across lateral transitions, only directly up/down.
 *
 * returns null if B is not on the same level or on a level directly above/below to A.
 */
/proc/get_vertical_dir(atom/A, atom/B)
	var/turf/AT = get_turf(A)
	var/turf/BT = get_turf(B)
	if(AT.z == BT.z)
		return get_dir(AT, BT)
	else if(BT.z == SSmapping.cached_level_up[AT.z])
		return get_dir(AT, BT) | UP
	else if(BT.z == SSmapping.cached_level_down[AT.z])
		return get_dir(AT, BT) | DOWN

/**
 * This is the full get multiz step.
 * It will look across lateral transitions and other struct magic.
 */
/proc/get_virtual_step(atom/A, dir)
	var/turf/T = get_turf(A)
	return SSmapping.get_virtual_step(T, dir)
