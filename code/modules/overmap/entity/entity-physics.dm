//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * (re)initialize physics
 *
 * always sets us back to a non-ticking state
 */
/obj/overmap/entity/proc/initialize_physics()
	vel_x = vel_y = 0
	deactivate_physics()
	reset_cached_pos()

/obj/overmap/entity/proc/reset_cached_pos()
	if(!overmap)
		pos_x = pos_y = 0
		return
	pos_x = OVERMAP_PIXEL_TO_DIST((x - overmap.lower_left_x) * WORLD_ICON_SIZE + step_x + bound_x + bound_width * 0.5)
	pos_y = OVERMAP_PIXEL_TO_DIST((y - overmap.lower_left_y) * WORLD_ICON_SIZE + step_y + bound_y + bound_height * 0.5)

// legacy ticking hook
/obj/overmap/entity/process(delta_time)
	physics_tick(delta_time)

/**
 * @params
 * * dt - time passed in seconds
 */
/obj/overmap/entity/proc/physics_tick(dt)
	if(!overmap || !isturf(loc))
		initialize_physics()
		return // what are we doing
	// amount should move
	var/ddx = vel_x * dt
	var/ddy = vel_y * dt
	// how much to move
	var/msx = OVERMAP_DIST_TO_PIXEL(ddx)
	var/msy = OVERMAP_DIST_TO_PIXEL(ddy)
	// update pos x/y without calling reset as reset is expensive
	pos_x += ddx
	pos_y += ddy
	// move
	var/old_loc = loc
	if(!Move(loc, dir, step_x + msx, step_y + msy))
		if(!bump_handled)
			initialize_physics()
			stack_trace("failed to move")
	else if(old_loc != loc)
		Moved(old_loc, NONE)

/obj/overmap/entity/proc/adjust_velocity(vx, vy)
	if(!isnull(vx))
		vel_x += vx
	if(isnull(vy))
		vel_y += vy

	var/interpolate_limiter
	if((interpolate_limiter = OVERMAP_DIST_TO_PIXEL(sqrt(vel_x ** 2 + vel_y ** 2))) > SSovermap_physics.global_interpolate_limit_as_per_second)
		interpolate_limiter = SSovermap_physics.global_interpolate_limit_as_per_second / interpolate_limiter
		vel_x *= interpolate_limiter
		vel_y *= interpolate_limiter

	if(QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y))
		activate_physics()
	else
		deactivate_physics()

	update_icon() // legacy

/obj/overmap/entity/proc/set_velocity(vx, vy)
	if(!isnull(vx))
		vel_x = vx
	if(!isnull(vy))
		vel_y = vy

	var/interpolate_limiter
	if((interpolate_limiter = OVERMAP_DIST_TO_PIXEL(sqrt(vel_x ** 2 + vel_y ** 2))) > SSovermap_physics.global_interpolate_limit_as_per_second)
		interpolate_limiter = SSovermap_physics.global_interpolate_limit_as_per_second / interpolate_limiter
		vel_x *= interpolate_limiter
		vel_y *= interpolate_limiter

	if(QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y))
		activate_physics()
	else
		deactivate_physics()

	update_icon() // legacy

/**
 * * We will be physically moved to 'other', including if it is on another overmap.
 * * If we are different in size from 'other', we will be centered.
 */
/obj/overmap/entity/proc/copy_physics_pos(obj/overmap/entity/other)
	force_move_p(bound_pixloc(other, NONE))

/obj/overmap/entity/proc/copy_physics_vel(obj/overmap/entity/other)
	vel_x = other.vel_x
	vel_y = other.vel_y

	if(QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y))
		activate_physics()
	else
		deactivate_physics()

	update_icon() // legacy

/**
 * * We will be physically moved to 'other', including if it is on another overmap.
 * * If we are different in size from 'other', we will be centered.
 */
/obj/overmap/entity/proc/copy_physics_pos_vel(obj/overmap/entity/other)
	force_move_p(bound_pixloc(other, NONE))

	vel_x = other.vel_x
	vel_y = other.vel_y

	if(QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y))
		activate_physics()
	else
		deactivate_physics()

	update_icon() // legacy

/obj/overmap/entity/proc/update_velocity_ticking()
	var/should_be_moving = is_moving()
	if(is_moving && !should_be_moving)
		deactivate_physics()
	else if(!is_moving && should_be_moving)
		activate_physics()

/obj/overmap/entity/proc/activate_physics()
	if(is_moving)
		return
	is_moving = TRUE
	SSovermap_physics.moving += src

/obj/overmap/entity/proc/deactivate_physics()
	if(!is_moving)
		return
	is_moving = FALSE
	SSovermap_physics.moving -= src

/**
 * check if we're moving, used to determine if we need to start ticking
 */
/obj/overmap/entity/proc/is_moving()
	return QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)

//* Getters *//

/**
 * gets our tile X on overmap
 *
 * @return 0 if not on overmap
 */
/obj/overmap/entity/proc/get_tile_x()
	if(!overmap)
		return 0
	return x - overmap.lower_left_x + 1

/**
 * gets our tile Y on overmap
 *
 * @return 0 if not on overmap
 */
/obj/overmap/entity/proc/get_tile_y()
	if(!overmap)
		return 0
	return y - overmap.lower_left_y + 1

/**
 * Get tile X with floating point where being on a tile is considered being at the center of it.
 */
/obj/overmap/entity/proc/get_tile_x_f()
	if(!overmap)
		return 0
	var/center = bound_x + bound_width * 0.5
	return x - overmap.lower_left_x + 1 + (center - (WORLD_ICON_SIZE * 0.5)) / WORLD_ICON_SIZE

/**
 * Get tile Y with floating point where being on a tile is considered being at the center of it.
 */
/obj/overmap/entity/proc/get_tile_y_f()
	if(!overmap)
		return 0
	var/center = bound_y + bound_height * 0.5
	return y - overmap.lower_left_y + 1 + (center - (WORLD_ICON_SIZE * 0.5)) / WORLD_ICON_SIZE

/**
 * get clockwise of N degrees heading of our cardinal velocity
 */
/obj/overmap/entity/proc/get_heading()
	return (arctan(vel_y, vel_x) + 360) % 360

/**
 * gets our movement (non-angular) speed in overmaps units per second
 */
/obj/overmap/entity/proc/get_abstracted_speed()
	return sqrt(vel_x ** 2 + vel_y ** 2)

/**
 * Get our vectorized x/y velocity.
 * * Returned vectors are in overmap units.
 */
/obj/overmap/entity/proc/get_abstracted_velocity_v() as /vector
	return vector(vel_x, vel_y)

/**
 * Gets our vectorized x/y position.
 * * Returned vectors are in overmap units.
 */
/obj/overmap/entity/proc/get_abstracted_position_v() as /vector
	return vector(pos_x, pos_y)

//* Entity Ops *//

/**
 * gets distance in overmap distance to other entity
 */
/obj/overmap/entity/proc/entity_overmap_distance(obj/overmap/entity/other)
	. = sqrt((src.pos_x - other.pos_x) ** 2 + (src.pos_y - other.pos_y) ** 2)
