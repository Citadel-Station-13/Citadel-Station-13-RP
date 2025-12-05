//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * This silly proc attempts to simulate a movement cycle without doing it.
 * * Ideally this has no side effects, but if legacy code causes you to explode from
 *   looking at it wrong I cannot be held responsible; this is a best-guess heuristic.
 * * EXPENSIVE AS SHIT
 */
/turf/proc/can_potentially_pass(turf/neighbor, atom/movable/mover)
	if((get_dist(src, neighbor) > 1) || (z != neighbor.z))
		return FALSE
	var/atom/movable/reachability_delegate/delegate = new(src)
	delegate.pass_flags |= mover.pass_flags
	if(!delegate.Move(neighbor))
		return FALSE
	if(delegate.loc != neighbor)
		return FALSE
	return TRUE
