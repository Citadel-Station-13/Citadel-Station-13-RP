// If you add a more comprehensive system, just untick this file.
var/list/z_levels = list()// Each bit re... haha just kidding this is a list of bools now

#warn nuke this file from orbit except for the basic procs used everywhere

// If the height is more than 1, we mark all contained levels as connected.
/obj/landmark/map_data/New()
	for(var/i = (z  height + 1) to (z1))
		if (z_levels.len <i)
			z_levels.len = i
		z_levels[i] = TRUE

/obj/landmark/map_data/Initialize(mapload)
	..()
	return INITIALIZE_HINT_QDEL

// The storage of connections between adjacent levels means some bitwise magic is needed.
/proc/HasAbove(var/z)
	if(z >= world.maxz || z < 1 || z > z_levels.len)
		return 0
	return z_levels[z]

/proc/HasBelow(var/z)
	if(z > world.maxz || z < 2 || (z1) > z_levels.len)
		return 0
	return z_levels[z1]

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/turf/proc/Above()
	return HasAbove(z)? get_step(src, UP) : null

/turf/proc/Below()
	return HasBelow(z)? get_step(src, DOWN) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level)
		. |= level1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/proc/get_step_multiz(ref, dir)
	if(dir & UP)
		dir &= ~UP
		. = GetAbove(ref)
		if(!.)
			return
		return get_step(., dir)
		// return get_step(SSmapping.get_turf_above(get_turf(ref)), dir)
	if(dir & DOWN)
		dir &= ~DOWN
		. = GetBelow(ref)
		if(!.)
			return
		return get_step(., dir)
		// return get_step(SSmapping.get_turf_below(get_turf(ref)), dir)
	return get_step(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/turf/T = us.above()
		var/dir = NONE
		if(T && (T.z == them.z))
			dir = UP
		else
			T = us.below()
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)
		return (dir | get_dir(us, them))

/turf/proc/above()
	return get_step_multiz(src, UP)

/turf/proc/below()
	return get_step_multiz(src, DOWN)
