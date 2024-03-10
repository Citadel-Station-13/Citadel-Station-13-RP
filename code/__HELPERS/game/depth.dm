/**
 * get something's depth to turf, or INFINITY if not in turf
 *
 * * turfs return 0
 * * areas crash on invoke
 * * something directly in a turf's contents counts as 0
 * * something in nullspace or nested inside something in nullspace counts as INFINITY
 */
/atom/proc/depth_from_turf()
	. = 0
	var/atom/scanning = loc
	while(!isturf(scanning))
		if(isnull(scanning))
			return INFINITY
		++.
		scanning = scanning.loc

/turf/depth_from_turf()
	return 0

/area/depth_from_turf()
	CRASH("invalid call")

/**
 * get something's depth from another atom, where being in that atom's contents is 0
 *
 * * this makes no sense if containing is null.
 */
/atom/movable/proc/depth_inside_atom(atom/containing)
	. = 0
	var/atom/scanning = loc
	while(scanning)
		if(isnull(scanning))
			return INFINITY
		if(scanning == containing)
			return
		.++
		scanning = scanning.loc
