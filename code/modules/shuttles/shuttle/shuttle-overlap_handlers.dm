//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * handles when an overlap occurs
 *
 * this is called before movable_overlap_handler.
 */
/datum/shuttle/proc/turf_overlap_handler(turf/from_turf, turf/to_turf)
	if(!to_turf.density)
		return
	// walls: obliteration.
	if(istype(to_turf, /turf/simulated/wall))
		var/turf/simulated/wall/wall = to_turf
		wall.atom_destruction(ATOM_DECONSTRUCT_DESTROYED)

/**
 * handles when an overlap occurs
 *
 * overlap always occurs on any movables that are non abstract and considered a game object
 */
/datum/shuttle/proc/movable_overlap_handler(atom/movable/entity, turf/from_turf, turf/to_turf)
	// we don't check for non-game/abstract, SSgrids does that.

	// get index in frontal pass
	// this is effectively our position left to right
	// 1 = leftmost turf of shuttle
	// matching [translating_forward_width] = rightmost turf of shuttle
	var/forward_lookup_index
	// get index in side pass
	// this is effectively our position front to back
	// 1 = frontmost turf of shuttle
	// matching [translating_side_length] = rearmost turf of shuttle
	var/side_lookup_index
	switch(translating_physics_direction)
		if(NORTH, SOUTH)
			forward_lookup_index = entity.x + translating_forward_offset
			side_lookup_index = entity.y + translating_side_offset
		if(EAST, WEST)
			forward_lookup_index = entity.y + translating_forward_offset
			side_lookup_index = entity.x + translating_side_offset
	forward_lookup_index = abs(forward_lookup_index)
	side_lookup_index = abs(side_lookup_index)

	// see if we should be kicked towards side
	var/use_side_heuristic = (forward_lookup_index > SHUTTLE_OVERLAP_FRONT_THRESHOLD) \
		&& ((side_lookup_index <= SHUTTLE_OVERLAP_SIDE_THRESHOLD) || (side_lookup_index > (translating_forward_width - SHUTTLE_OVERLAP_SIDE_THRESHOLD)))

	// get the cached target
	var/turf/overall_target = use_side_heuristic? (
			(side_lookup_index > (translating_forward_width / 2))? \
				translating_right_lookup[side_lookup_index] : \
				translating_left_lookup[side_lookup_index] \
		) : \
		(translating_forwards_lookup[forward_lookup_index])
	var/should_annihilate

	if(isnull(overall_target))
		// if no target, generate one
		var/turf/current_turf = get_turf(entity)
		if(use_side_heuristic)
			overall_target = movable_overlap_side_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || movable_overlap_front_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || SHUTTLE_OVERLAP_NO_FREE_SPACE
		else
			var/side_forgiveness = (forward_lookup_index <= SHUTTLE_OVERLAP_SIDE_FORGIVENESS \
				|| forward_lookup_index > (translating_forward_width - SHUTTLE_OVERLAP_SIDE_FORGIVENESS))
			overall_target = movable_overlap_front_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			) || (side_forgiveness && movable_overlap_side_heuristic(
				current_turf,
				translating_physics_direction,
				side_lookup_index,
				forward_lookup_index,
			)) || SHUTTLE_OVERLAP_NO_FREE_SPACE

			// cache; if we found none, we just tell stuff to get annihilated on hit
			translating_forwards_lookup[forward_lookup_index] = overall_target || SHUTTLE_OVERLAP_NO_FREE_SPACE

	if(overall_target == SHUTTLE_OVERLAP_NO_FREE_SPACE)
		// if we accepted there's no space,
		// obliterate it if possible
		should_annihilate = TRUE
		overall_target = movable_overlap_calculate_front_turf(entity, translating_physics_direction, side_lookup_index)

	// tell it to do stuff
	entity.shuttle_crushed(src, overall_target, should_annihilate)

// todo: get rid of all translating_ instance vars
/datum/shuttle/proc/movable_overlap_front_heuristic(turf/from_turf, direction, side_index, forward_index)
	var/forward_width = translating_forward_width

	var/turf/center = movable_overlap_calculate_front_turf(from_turf, direction, side_index)
	if(!center.density)
		return center

	var/turf/left = center
	var/turf/right = center

	var/left_dir = turn(direction, 90)
	var/right_dir = turn(direction, -90)

	for(var/i in 1 to SHUTTLE_OVERLAP_FRONT_DEFLECTION)
		// left
		if((forward_index - i) >= 1)
			left = get_step(left, left_dir)
		// right
		if((forward_index + i) <= (forward_width))
			right = get_step(right, right_dir)

		if(!left.density)
			if(!right.density)
				return pick(left, right)
			return left
		else if(!right.density)
			return right

// todo: get rid of all translating_ instance vars
/datum/shuttle/proc/movable_overlap_side_heuristic(turf/from_turf, direction, side_index, forward_index)
	var/midpoint = (translating_forward_width + 1) / 2
	var/go_left = (forward_index == midpoint)? prob(50) : (forward_index < midpoint)

	var/turf/center = go_left? \
		movable_overlap_calculate_left_turf(from_turf, direction, forward_index, translating_forward_width) : \
		movable_overlap_calculate_right_turf(from_turf, direction, forward_index, translating_forward_width)

	if(!center.density)
		return center

	// always slam them forwards if possible
	var/forwards_dir = direction
	var/turf/forwards = center
	for(var/i in 1 to min(SHUTTLE_OVERLAP_SIDE_FORWARDS_DEFLECTION, side_index))
		forwards = get_step(forwards, forwards_dir)
		if(!forwards.density)
			return forwards

	// then slam backwards if needed
	var/backwards_dir = turn(direction, 180)
	var/turf/backwards = center
	for(var/i in 1 to min(SHUTTLE_OVERLAP_SIDE_BACKWARDS_DEFLECTION, translating_side_length - side_index + 1))
		backwards = get_step(backwards, backwards_dir)
		if(!backwards.density)
			return backwards

/datum/shuttle/proc/movable_overlap_calculate_front_turf(atom/movable/entity, direction, side_index)
	// we abuse side_lookup_index to shift us forwards to the first tile that isn't the shuttle.
	// the shuttle system **should** prevent us from ever clipping through the zlevel borders
	// thanks to the bounding clip checks before movement.
	switch(direction)
		if(NORTH)
			return locate(
				entity.x,
				entity.y + side_index,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x,
				entity.y - side_index,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x + side_index,
				entity.y,
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x - side_index,
				entity.y,
				entity.z,
			)

/datum/shuttle/proc/movable_overlap_calculate_left_turf(atom/movable/entity, direction, front_index, width)
	// ditto
	switch(direction)
		if(NORTH)
			return locate(
				entity.x - front_index,
				entity.y,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x + front_index,
				entity.y,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x,
				entity.y + front_index,
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x,
				entity.y - front_index,
				entity.z,
			)

/datum/shuttle/proc/movable_overlap_calculate_right_turf(atom/movable/entity, direction, front_index, width)
	// ditto
	switch(direction)
		if(NORTH)
			return locate(
				entity.x - front_index + (width + 1),
				entity.y,
				entity.z,
			)
		if(SOUTH)
			return locate(
				entity.x + front_index - (width + 1),
				entity.y,
				entity.z,
			)
		if(EAST)
			return locate(
				entity.x,
				entity.y + front_index - (width + 1),
				entity.z,
			)
		if(WEST)
			return locate(
				entity.x,
				entity.y - front_index + (width + 1),
				entity.z,
			)

/datum/shuttle/proc/default_transit_movable_cleaner(atom/movable/AM)
	var/obliterate = TRUE
	if(AM.movable_flags & MOVABLE_NO_LOST_IN_SPACE)
		obliterate = FALSE

	if(obliterate)
		qdel(AM)
		return

	// find somewhere to throw them. given this is 'default' transit movable cleaner,
	// this is already kind of a fail-state.
	#warn impl
