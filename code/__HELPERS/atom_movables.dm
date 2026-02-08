/**
 * returns the topmost atom on a turf we're in, or null
 * if a non movable is passed, itself is returned
 */
/proc/get_top_level_atom(atom/movable/AM)
	// if turf or area, return itself
	if(!istype(AM))
		return AM
	// if nullspace, return null
	if(!AM.loc)
		return
	// keep going up until we are on a turf
	while(!isturf(AM.loc))
		AM = AM.loc
	return AM

/**
 * Walks up the loc tree until it finds a holder of the given holder_type.
 */
/proc/get_holder_of_type(atom/A, holder_type)
	if(!istype(A))
		return
	for(A, A && !istype(A, holder_type), A=A.loc);
	return A

/atom/movable/proc/throw_at_random(include_own_turf, maxrange, speed)
	var/list/turfs = trange(maxrange, src)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at_old(pick(turfs), maxrange, speed, src)
