//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: redo
/turf/CheckFall(atom/movable/falling_atom)
	if(!(mz_flags & MZ_OPEN_DOWN))
		return TRUE	// impact!
	return ..()

//* lookups

/turf/proc/above()
	RETURN_TYPE(/turf)
	return locate(x, y, SSmapping.cached_level_up[z])

/turf/proc/below()
	RETURN_TYPE(/turf)
	return locate(x, y, SSmapping.cached_level_down[z])

/**
 * This is the basic get multiz step.
 * It will not look across lateral transitions, only up/down.
 */
/turf/proc/vertical_step(dir)
	RETURN_TYPE(/turf)
	if((dir & (UP|DOWN)) == 0)
		return get_step(src, dir)
	else if(dir & UP)
		return get_step(locate(x, y, SSmapping.cached_level_up[z]), dir & ~(UP))
	else if(dir & DOWN)
		return get_step(locate(x, y, SSmapping.cached_level_down[z]), dir & ~(DOWN))
	CRASH("how did we get here?")

/**
 * Basic multiz get dir
 * Will not look across lateral transitions, only directly up/down.
 */
/turf/proc/vertical_dir(turf/other)
	if(other.z == z)
		return get_dir(src, other)
	else if(other.z == SSmapping.cached_level_up[z])
		return get_dir(src, other) | UP
	else if(other.z == SSmapping.cached_level_down[z])
		return get_dir(src, other) | DOWN

/**
 * This is the full get multiz step.
 * It will look across lateral transitions and other struct magic.
 */
/turf/proc/virtual_step(dir)
	RETURN_TYPE(/turf)
	return SSmapping.get_virtual_step(src, dir)
