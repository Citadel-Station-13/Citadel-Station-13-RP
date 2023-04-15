///Returns a list with all the adjacent open turfs. Clears the list of nulls in the end.
/proc/get_adjacent_open_turfs(atom/center)
	var/list/hand_back = list()
	// Inlined get_open_turf_in_dir, just to be fast
	var/turf/open/new_turf = get_step(center, NORTH)
	if(istype(new_turf))
		hand_back += new_turf
	new_turf = get_step(center, SOUTH)
	if(istype(new_turf))
		hand_back += new_turf
	new_turf = get_step(center, EAST)
	if(istype(new_turf))
		hand_back += new_turf
	new_turf = get_step(center, WEST)
	if(istype(new_turf))
		hand_back += new_turf
	return hand_back
