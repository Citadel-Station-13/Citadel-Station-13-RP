/proc/get_step_multiz(ref, dir)
	if(dir & UP)
		dir &= ~UP
		var/turf/T = get_turf(ref)
		return get_step(T.above(), dir)
	if(dir & DOWN)
		dir &= ~DOWN
		var/turf/T = get_turf(ref)
		return get_step(T.below(), dir)
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

/proc/get_dir_multiz_expensive(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/dir = NONE
		var/turf/T = us.above()
		var/list/L = list()
		while(T && !L[T])
			if(T.z == them.z)
				dir = UP
				break
			L[T] = TRUE
			T = T.above()
		if(!dir)		//try downwards
			T = us.below()
			while(T && !L[T])
				if(T.z == them.z)
					dir = DOWN
					break
				L[T] = TRUE
				T = T.below()
		if(!dir)		//not found
			return
		return get_dir(us, them) | dir

/turf/proc/above()
	return SSmapping.get_turf_above(src)

/turf/proc/below()
	return SSmapping.get_turf_below(src)

//laggy proc
/turf/proc/get_multiz_stack()
	. = list(src)
	var/turf/above = above()
	while(above && !(above in .))
		. |= above
		above = above()
	var/turf/below = below()
	while(below && !(below in .))
		. |= below
		below = below()

/proc/dir_inverse_multiz(dir)
	var/holder = dir & (UP|DOWN)
	if((holder == NONE) || (holder == (UP|DOWN)))
		return turn(dir, 180)
	dir &= ~(UP|DOWN)
	dir = turn(dir, 180)
	if(holder == UP)
		holder = DOWN
	else
		holder = UP
	dir |= holder
	return dir
