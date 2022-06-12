/*
 * This is the home of multi-tile movement checks, and thus here be dragons. You are warned.
 */
/atom/movable/proc/check_multi_tile_move_density_dir(stepdir)
	// warning: this proc doesn't respect Exit --> Enter, due to overhead
	// if you have Exit() and Enter() have side effects it's a skill issue on your part anyways!
	if(!isturf(loc))
		return TRUE

	var/list/moving_to = list()
	for(var/turf/T as anything in locs)
		var/turf/T2 = get_step(T, stepdir)
		if(!T2)
			// bruh, edge of map
			return FALSE
		moving_to += T2
		if(T2 in locs)
			// still inside them
			continue
		else
			// check enter
			if(!T2.Enter(src, T))
				return FALSE
				
	// uh oh, second loop, check exits
	for(var/turf/T as anything in locs)
		if(!(T in moving_to))
			if(!T.Exit(src, get_step(T, stepdir)))
				return FALSE
				
	return TRUE
