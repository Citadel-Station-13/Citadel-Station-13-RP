//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This is the basic get multiz step.
 * It will not look across lateral transitions, only up/down.
 */
/proc/get_step_multiz(atom/A, dir)
	if((dir & (UP|DOWN)) == 0)
		return get_step(A, dir)
	var/turf/us = get_turf(A)
	if(dir & UP)
		return get_step(locate(us.x, us.y, SSmapping.cached_level_up[us.z]), dir & ~UP)
	if(dir & DOWN)
		return get_step(locate(us.x, us.y, SSmapping.cached_level_down[us.z]), dir & ~DOWN)

/**
 * Basic multiz get dir
 * Will not look across lateral transitions, only directly up/down.
 *
 * returns null if B is not on the same level or on a level directly above/below to A.
 */
/proc/get_dir_multiz(atom/us, atom/them)
	var/turf/AT = get_turf(us)
	var/turf/BT = get_turf(them)
	if(AT.z == BT.z)
		return get_dir(AT, BT)
	else if(BT.z == SSmapping.cached_level_up[AT.z])
		return get_dir(AT, BT) | UP
	else if(BT.z == SSmapping.cached_level_down[AT.z])
		return get_dir(AT, BT) | DOWN
