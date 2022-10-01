//! Adjacency System

/**
 * checks simple adjacency, aka "are we semantically next to something and can reach them"
 * This will not automatically get turf if you're nested in something else, e.g. in a closet!
 *
 * **DO NOT** default recursion to on.
 *
 * @params
 * - neighbor - what we're trying to reach
 * - recurse - levels we're allowed to recurse up if we're not on a turf
 */
/atom/proc/Adjacent(atom/neighbor, recurse)
	return FALSE

/area/Adjacent(atom/neighbor, recurse)
	CRASH("Call to /area/Adjacent; this is wrong.")

/atom/movable/Adjacent(atom/neighbor, recurse)
	if(neighbor == loc)
		return TRUE
	var/turf/T = loc
	if(!istype(T))
		if(recurse)
			return loc? loc.Adjacent(neighbor, recurse - 1) : FALSE
		return FALSE
	for(T in locs)
		if(T.TurfAdjacency(get_turf(neighbor), neighbor, src))
			return TRUE
	return FALSE

/turf/Adjacent(atom/neighbor, recurse)
	return TurfAdjacency(get_turf(neighbor), neighbor, null)

/**
 * Turf adjacency
 *
 * - Always true if you're in the same turf
 * - If you're vertically/horizontally adjacent, ensure there's no border obects
 * - If you're diagonally adjacent, ensure you can pass to it with mutually adjacent squares
 */
/turf/proc/TurfAdjacency(turf/neighbor_turf, atom/target, atom/movable/mover)
	if(neighbor_turf == src)
		return TRUE
	if(get_dist(src, neighbor_turf) > 1 || z != neighbor_turf.z)
		return FALSE
	// non diagonal
	if(neighbor_turf.x == x || neighbor_turf.y == y)
		return ClickCross(get_dir(src, neighbor_turf), TRUE, target, mover) && neighbor_turf.ClickCross(get_dir(neighbor_turf, src), TRUE, target, mover)

	// diagonal
	var/reverse_dir = get_dir(neighbor_turf, src)
	var/d1 = NSCOMPONENT(reverse_dir)
	var/d2 = EWCOMPONENT(reverse_dir)
	var/turf/checking

	// because byond's parser is awful and doesn't let us skip lines on ifs with comments after '\'s,
	// we're going to comment above:
	// criteria in order for both are:
	// - not dense
	// - could leave target
	// - could go from diagonal to self
	// - could go from diagonal to target
	// - could leave self
	checking = get_step(neighbor_turf, d1)
	if(!checking.density &&	\
		neighbor_turf.ClickCross(d1, TRUE, target, mover) && \
		checking.ClickCross(d2, FALSE, target, mover) && \
		checking.ClickCross(turn(d1, 180), FALSE, target, mover) && \
		ClickCross(turn(d2, 180), TRUE, target, mover))
		return TRUE
	checking = get_step(neighbor_turf, d2)
	if(!checking.density && \
		neighbor_turf.ClickCross(d2, TRUE, target, mover) && \
		checking.ClickCross(d1, FALSE, target, mover) && \
		checking.ClickCross(turn(d2, 180), FALSE, target, mover) && \
		ClickCross(turn(d1, 180), TRUE, target, mover))
		return TRUE
	return FALSE

/**
 * Checks if there's uninterrupted airspace from this turf to another
 *
 * Interrputions:
 * Dense objects without ATOM_PASS_CLICK
 */
/turf/proc/ClickCross(d, border_only, atom/target, atom/movable/mover)
	var/turf/going_to = get_step(src, d)
	if(border_only)
		for(var/obj/O in src)
			if(!(O.flags & ON_BORDER))
				continue
			if(O == target || O == mover || (O.pass_flags_self & ATOM_PASS_CLICK))
				continue
			if(mover? O.CheckExit(mover, going_to) : !O.density)
				continue
			return FALSE
	else
		for(var/obj/O in src)
			if(O == target || O == mover || (O.pass_flags_self & ATOM_PASS_CLICK))
				continue
			if(mover? O.CanPass(mover, src) : !O.density)
				continue
			return FALSE
	return TRUE
