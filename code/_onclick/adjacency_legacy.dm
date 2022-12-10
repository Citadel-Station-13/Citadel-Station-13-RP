//! random stuff that still needs rethinking
/**
 * Quick adjacency (to turf):
 * * If you are in the same turf, always true
 * * If you are not adjacent, then false
 */
/turf/proc/AdjacentQuick(atom/neighbor, atom/target = null)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return TRUE

	if(get_dist(src,T0) > 1)
		return FALSE

	return TRUE
