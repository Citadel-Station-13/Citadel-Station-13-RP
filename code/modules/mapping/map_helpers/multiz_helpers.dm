// generic polyfill for tg funcs
// these are "aware" about z groupings using flags
/proc/get_step_multiz(ref, dir)
	var/turf/us = get_turf(ref)
	if((dir & UP) && (us.mz_flags & MZ_OPEN_UP))
		return get_step(us, dir)
	if((dir & DOWN) && (us.mz_flags & MZ_OPEN_DOWN))
		return get_step(us, dir)
	return get_step(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/turf/T = (us.mz_flags & MZ_OPEN_UP) ? get_turf(us, UP) : null // GET_TURF_ABOVE
		var/dir = NONE
		if(T && (T.z == them.z))
			dir = UP
		else
			T = (us.mz_flags & MZ_OPEN_DOWN) ? get_turf(us, DOWN) : null // GET_TURF_BELOW
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)
		return (dir | get_dir(us, them))

/proc/get_lowest_turf(atom/ref)
	var/turf/us = get_turf(ref)
	var/turf/next = (us.mz_flags & MZ_OPEN_DOWN) ? get_turf(us, DOWN) : null // GET_TURF_BELOW
	while(next)
		us = next
		next = (us.mz_flags & MZ_OPEN_DOWN) ? get_turf(us, DOWN) : null // GET_TURF_BELOW
	return us

/proc/get_highest_turf(atom/ref)
	var/turf/us = get_turf(ref)
	var/turf/next = (us.mz_flags & MZ_OPEN_UP) ? get_turf(us, UP) : null // GET_TURF_ABOVE
	while(next)
		us = next
		next = (us.mz_flags & MZ_OPEN_UP) ? get_turf(us, UP) : null // GET_TURF_ABOVE
	return us
