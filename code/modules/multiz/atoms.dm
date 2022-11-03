/**
 * returns if an atom can enter our tile from a multiz move
 *
 * @params
 * AM - mover, null if doing a blank check
 * dir - direction of where they're coming from (e.g. if they're dropping from above, this is UP)
 * old_loc - old turf
 */
/atom/proc/z_pass_in(atom/movable/AM, dir, turf/old_loc)
	if(density && !(flags & ON_BORDER))		// dense objects like machinery block by default
		return FALSE
	return !AM || Cross(AM)

/**
 * returns if an atom can exit our tile into a multiz move
 *
 * @params
 * AM - mover, null if doing a blank check
 * dir - direction of where they're going to (e.g. if they're climbing above and out of us, this is UP)
 * new_loc - new turf
 */
/atom/proc/z_pass_out(atom/movable/AM, dir, turf/new_loc)
	return !AM || Uncross(AM)
