//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Hitscan Visuals *//

/**
 * returns a /datum/point based on where we currently are
 */
/obj/projectile/proc/get_tracer_point()
	RETURN_TYPE(/datum/point)
	var/datum/point/point = new
	if(trajectory_moving_to)
		// we're in move. use next px/py to respect 1. kick forwards 2. deflections
		point.x = (trajectory_moving_to.x - 1) * WORLD_ICON_SIZE + next_px
		point.y = (trajectory_moving_to.y - 1) * WORLD_ICON_SIZE + next_py
	else
		point.x = (x - 1) * WORLD_ICON_SIZE + current_px
		point.y = (y - 1) * WORLD_ICON_SIZE + current_py
	point.z = z
	return point

/**
 * * returns a /datum/point based on where we'll be when we loosely intersect a tile
 * * returns null if we'll never intersect it
 * * returns our current point if we're already loosely intersecting it
 * * loosely intersecting means that we are level with the tile in either x or y.
 */
/obj/projectile/proc/get_intersection_point(turf/colliding)
	RETURN_TYPE(/datum/point)
	ASSERT(!isnull(angle))

	// calculate where we are
	var/our_x
	var/our_y
	if(trajectory_moving_to)
		// we're in move. use next px/py to respect 1. kick forwards 2. deflections
		our_x = (trajectory_moving_to.x - 1) * WORLD_ICON_SIZE + next_px
		our_y = (trajectory_moving_to.y - 1) * WORLD_ICON_SIZE + next_py
	else
		our_x = (x - 1) * WORLD_ICON_SIZE + current_px
		our_y = (y - 1) * WORLD_ICON_SIZE + current_py

	// calculate how far we have to go to touch their closest x / y axis
	var/d_to_reach_x
	var/d_to_reach_y

	if(colliding.x != x)
		switch(calculated_sdx)
			if(0)
				return
			if(1)
				if(colliding.x < x)
					return
				d_to_reach_x = (((colliding.x - 1) * WORLD_ICON_SIZE + 0.5) - our_x) / calculated_dx
			if(-1)
				if(colliding.x > x)
					return
				d_to_reach_x = (((colliding.x - 0) * WORLD_ICON_SIZE + 0.5) - our_x) / calculated_dx
	else
		d_to_reach_x = 0

	if(colliding.y != y)
		switch(calculated_sdy)
			if(0)
				return
			if(1)
				if(colliding.y < y)
					return
				d_to_reach_y = (((colliding.y - 1) * WORLD_ICON_SIZE + 0.5) - our_y) / calculated_dy
			if(-1)
				if(colliding.y > y)
					return
				d_to_reach_y = (((colliding.y - 0) * WORLD_ICON_SIZE + 0.5) - our_y) / calculated_dy
	else
		d_to_reach_y = 0

	var/needed_distance = max(d_to_reach_x, d_to_reach_y)

	// calculate if we'll actually be touching the tile once we go that far
	var/future_x = our_x + needed_distance * calculated_dx
	var/future_y = our_y + needed_distance * calculated_dy
	// let's be slightly lenient and do 1 instead of 0.5
	if(future_x < (colliding.x - 1) * WORLD_ICON_SIZE && future_x > (colliding.x) * WORLD_ICON_SIZE + 1 && \
		future_y < (colliding.y - 1) * WORLD_ICON_SIZE && future_y > (colliding.y) * WORLD_ICON_SIZE + 1)
		return // not gonna happen

	// make the point based on how far we need to go
	var/datum/point/point = new
	point.x = future_x
	point.y = future_y
	point.z = z
	return point

/**
 * records the start of a hitscan
 *
 * this can edit the point passed in!
 */
/obj/projectile/proc/record_hitscan_start(datum/point/point, muzzle_marker, kick_forwards)
	if(!hitscanning)
		return
	if(isnull(point))
		point = get_tracer_point()
	tracer_vertices = list(point)
	tracer_muzzle_flash = muzzle_marker

	// kick forwards
	point.shift_in_projectile_angle(angle, kick_forwards)

/**
 * ends the hitscan tracer
 *
 * this can edit the point passed in!
 */
/obj/projectile/proc/record_hitscan_end(datum/point/point, impact_marker, kick_forwards)
	if(!hitscanning)
		return
	if(isnull(point))
		point = get_tracer_point()
	tracer_vertices += point
	tracer_impact_effect = impact_marker

	// kick forwards
	point.shift_in_projectile_angle(angle, kick_forwards)

/**
 * records a deflection (change in angle, aka generate new tracer)
 */
/obj/projectile/proc/record_hitscan_deflection(datum/point/point)
	if(!hitscanning)
		return
	if(isnull(point))
		point = get_tracer_point()
	// there's no way you need more than 25
	// if this is hit, fix your shit, don't bump this up; there's absolutely no reason for example,
	// to simulate reflectors working !!25!! times.
	if(length(tracer_vertices) >= 25)
		CRASH("tried to add more than 25 vertices to a hitscan tracer")
	tracer_vertices += point

/obj/projectile/proc/render_hitscan_tracers(duration = tracer_duration)
	// don't stay too long
	ASSERT(duration >= 0 && duration <= 10 SECONDS)
	// check everything
	if(!has_tracer || !duration || !length(tracer_vertices))
		return
	var/list/atom/movable/beam_components = list()

	// muzzle
	if(muzzle_type && tracer_muzzle_flash)
		var/datum/point/starting = tracer_vertices[1]
		var/atom/movable/muzzle_effect = starting.instantiate_movable_with_unmanaged_offsets(muzzle_type)
		if(muzzle_effect)
			// turn it
			var/matrix/muzzle_transform = matrix()
			muzzle_transform.Turn(original_angle)
			muzzle_effect.transform = muzzle_transform
			muzzle_effect.color = color
			muzzle_effect.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
			// add to list
			beam_components += muzzle_effect
	// impact
	if(impact_type && tracer_impact_effect)
		var/datum/point/starting = tracer_vertices[length(tracer_vertices)]
		var/atom/movable/impact_effect = starting.instantiate_movable_with_unmanaged_offsets(impact_type)
		if(impact_effect)
			// turn it
			var/matrix/impact_transform = matrix()
			impact_transform.Turn(angle)
			impact_effect.transform = impact_transform
			impact_effect.color = color
			impact_effect.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
			// add to list
			beam_components += impact_effect
	// path tracers
	if(tracer_type)
		var/tempref = "\ref[src]"
		for(var/i in 1 to length(tracer_vertices) - 1)
			var/j = i + 1
			var/datum/point/first_point = tracer_vertices[i]
			var/datum/point/second_point = tracer_vertices[j]
			generate_tracer_between_points(first_point, second_point, beam_components, tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, tempref)

	QDEL_LIST_IN(beam_components, duration)

/obj/projectile/proc/cleanup_hitscan_tracers()
	tracer_vertices = null

/obj/projectile/proc/finalize_hitscan_tracers(datum/point/end_point, impact_effect, kick_forwards)
	// if end wasn't recorded yet and we're still on a turf, record end
	if(isnull(tracer_impact_effect) && loc)
		record_hitscan_end(end_point, impact_marker = impact_effect, kick_forwards = kick_forwards)
	// render & cleanup
	render_hitscan_tracers()
	cleanup_hitscan_tracers()
