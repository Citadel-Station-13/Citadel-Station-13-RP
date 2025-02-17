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
	phys_tracer_vertices = list(point)
	phys_tracer_do_muzzle = muzzle_marker

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
	phys_tracer_vertices += point
	phys_tracer_do_impact = impact_marker

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
	if(length(phys_tracer_vertices) >= 25)
		CRASH("tried to add more than 25 vertices to a hitscan tracer")
	phys_tracer_vertices += point

/obj/projectile/proc/render_hitscan_tracers(duration = tracer_lifetime)
	// don't stay too long
	ASSERT(duration >= 0 && duration <= 10 SECONDS)

	// check everything
	if(!has_tracer || !duration || !length(phys_tracer_vertices))
		return

	var/list/atom/movable/created = list()
	QDEL_LIST_IN(created, duration)

	// if tracer icon exists, use new rendering system
	if(tracer_icon && tracer_icon_state)
		for(var/i in 1 to length(phys_tracer_vertices) - 1)
			var/j = i + 1
			var/datum/point/point_a = phys_tracer_vertices[i]
			var/datum/point/point_b = phys_tracer_vertices[j]
			if(tracer_is_tiled)
				// fucked up
				var/total_pixel_length = pixel_length_between_points(point_a, point_b)
				var/tracer_angle = angle_between_points(point_a, point_b)
				var/dx = sin(tracer_angle)
				var/dy = cos(tracer_angle)
				var/iterations = total_pixel_length / WORLD_ICON_SIZE
				iterations = CEILING(iterations, 1)
				for(var/iter in 0 to iterations)
					var/resultant_x = (point_a.x + dx * iter * WORLD_ICON_SIZE) / WORLD_ICON_SIZE
					var/resultant_y = (point_a.y + dy * iter * WORLD_ICON_SIZE) / WORLD_ICON_SIZE
					var/turf/resultant_turf = locate(
						round(resultant_x),
						round(resultant_y),
						point_a.z,
					)
					var/resultant_px = resultant_x % WORLD_ICON_SIZE
					if(!resultant_px)
						resultant_px = WORLD_ICON_SIZE * 0.5
					else
						resultant_px -= WORLD_ICON_SIZE * 0.5
					var/resultant_py = resultant_y % WORLD_ICON_SIZE
					if(!resultant_py)
						resultant_py = WORLD_ICON_SIZE * 0.5
					else
						resultant_py -= WORLD_ICON_SIZE * 0.5
					if(resultant_turf)
						created += new /atom/movable/render/projectile_tracer/segment(resultant_turf, tracer_icon, "[tracer_icon_state]-beam", tracer_add_state, tracer_add_state_alpha, tracer_angle, resultant_px, resultant_py, color, auto_emissive_strength)
			else
				var/datum/point/midpoint = point_midpoint_points(point_a, point_b)
				var/turf/midpoint_turf = midpoint.return_turf()
				var/midpoint_px = midpoint.return_px()
				var/midpoint_py = midpoint.return_py()
				var/tracer_angle = angle_between_points(point_a, point_b)
				if(midpoint_turf)
					created += new /atom/movable/render/projectile_tracer/beam(midpoint_turf, tracer_icon, "[tracer_icon_state]-beam", tracer_add_state, tracer_add_state_alpha, tracer_angle, midpoint_px, midpoint_py, color, auto_emissive_strength, pixel_length_between_points(point_a, point_b))
		if(phys_tracer_do_muzzle)
			var/datum/point/starting = phys_tracer_vertices[1]
			var/turf/starting_turf = starting.return_turf()
			if(starting_turf)
				var/starting_px = starting.return_px()
				var/starting_py = starting.return_py()
				created += new /atom/movable/render/projectile_tracer/muzzle(starting_turf, tracer_icon, "[tracer_icon_state]-muzzle", tracer_add_state, tracer_add_state_alpha, original_angle, starting_px, starting_py, color, auto_emissive_strength)
		if(phys_tracer_do_impact)
			var/datum/point/ending = phys_tracer_vertices[length(phys_tracer_vertices)]
			var/turf/ending_turf = ending.return_turf()
			if(ending_turf)
				var/ending_px = ending.return_px()
				var/ending_py = ending.return_py()
				created += new /atom/movable/render/projectile_tracer/impact(ending_turf, tracer_icon, "[tracer_icon_state]-impact", tracer_add_state, tracer_add_state_alpha, angle, ending_px, ending_py, color, auto_emissive_strength)
		return

	//! legacy below !//

	var/list/atom/movable/beam_components = created

	// muzzle
	if(legacy_muzzle_type && phys_tracer_do_muzzle)
		var/datum/point/starting = phys_tracer_vertices[1]
		var/atom/movable/muzzle_effect = starting.instantiate_movable_with_unmanaged_offsets(legacy_muzzle_type)
		if(muzzle_effect)
			// turn it
			var/matrix/muzzle_transform = matrix()
			muzzle_transform.Turn(original_angle)
			muzzle_effect.transform = muzzle_transform
			muzzle_effect.color = color
			muzzle_effect.set_light(legacy_muzzle_flash_range, legacy_muzzle_flash_intensity, legacy_muzzle_flash_color_override? legacy_muzzle_flash_color_override : color)
			// add to list
			beam_components += muzzle_effect
	// impact
	if(legacy_impact_type && phys_tracer_do_impact)
		var/datum/point/starting = phys_tracer_vertices[length(phys_tracer_vertices)]
		var/atom/movable/impact_effect = starting.instantiate_movable_with_unmanaged_offsets(legacy_impact_type)
		if(impact_effect)
			// turn it
			var/matrix/impact_transform = matrix()
			impact_transform.Turn(angle)
			impact_effect.transform = impact_transform
			impact_effect.color = color
			impact_effect.set_light(legacy_impact_light_range, legacy_impact_light_intensity, legacy_impact_light_color_override? legacy_impact_light_color_override : color)
			// add to list
			beam_components += impact_effect
	// path tracers
	if(legacy_tracer_type)
		var/tempref = "\ref[src]"
		for(var/i in 1 to length(phys_tracer_vertices) - 1)
			var/j = i + 1
			var/datum/point/first_point = phys_tracer_vertices[i]
			var/datum/point/second_point = phys_tracer_vertices[j]
			generate_tracer_between_points(first_point, second_point, beam_components, legacy_tracer_type, color, duration, legacy_hitscan_light_range, legacy_hitscan_light_color_override, legacy_hitscan_light_intensity, tempref)

/obj/projectile/proc/cleanup_hitscan_tracers()
	phys_tracer_vertices = null

/obj/projectile/proc/finalize_hitscan_tracers(datum/point/end_point, impact_effect, kick_forwards)
	// if end wasn't recorded yet and we're still on a turf, record end
	if(isnull(phys_tracer_do_impact) && loc)
		record_hitscan_end(end_point, impact_marker = impact_effect, kick_forwards = kick_forwards)
	// render & cleanup
	render_hitscan_tracers()
	cleanup_hitscan_tracers()

//* Tracer Objects *//

/image/projectile/projectile_tracer_emissive
	appearance_flags = KEEP_APART | RESET_COLOR
	plane = EMISSIVE_PLANE
	layer = MANGLE_PLANE_AND_LAYER(/atom/movable/render/projectile_tracer::plane, /atom/movable/render/projectile_tracer::layer)
	color = EMISSIVE_COLOR
	color = EMISSIVE_COLOR

/image/projectile/projectile_tracer_add
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_APART | RESET_COLOR

/**
 * Tracer object
 *
 * * angle is clockwise from north
 */
/atom/movable/render/projectile_tracer
	SET_APPEARANCE_FLAGS(KEEP_TOGETHER)
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

// todo: maybe don't have arg hell?
/atom/movable/render/projectile_tracer/Initialize(mapload, icon/use_icon, use_icon_state, use_icon_add_state, use_add_state_alpha, angle, px, py, color, emissive)
	src.icon = use_icon
	src.icon_state = use_icon_state
	var/matrix/turn_to = transform
	turn_to.Turn(angle)
	src.transform = turn_to
	src.pixel_x = px
	src.pixel_y = py
	src.color = color
	if(emissive)
		var/image/emissive_image = new /image/projectile/projectile_tracer_emissive(icon, icon_state)
		emissive_image.layer = MANGLE_PLANE_AND_LAYER(plane, layer)
		emissive_image.alpha = emissive
		emissive_image.color = GLOB.emissive_color
		overlays += emissive_image
	if(use_icon_add_state)
		var/image/image = new /image/projectile/projectile_tracer_add(icon, "[icon_state]-add")
		image.alpha = use_add_state_alpha
		overlays += image
	return ..()

/atom/movable/render/projectile_tracer/impact

/atom/movable/render/projectile_tracer/muzzle

/atom/movable/render/projectile_tracer/beam

/atom/movable/render/projectile_tracer/beam/Initialize(mapload, icon/use_icon, use_icon_state, use_icon_add_state, use_add_state_alpha, angle, px, py, color, emissive, pixel_length)
	var/matrix/extending = transform
	extending.Scale(1, pixel_length / WORLD_ICON_SIZE)
	src.transform = extending
	return ..()

/atom/movable/render/projectile_tracer/segment
