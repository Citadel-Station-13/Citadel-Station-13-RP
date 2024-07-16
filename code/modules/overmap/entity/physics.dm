/**
 * (re)initialize physics
 *
 * always sets us back to a non-ticking state
 */
/obj/overmap/entity/proc/initialize_physics()
	deactivate_physics()
	vel_x = 0
	vel_y = 0
	step_x = step_y = 0
	pos_x = OVERMAP_PIXEL_TO_DIST(1 + (x - 1) * WORLD_ICON_SIZE + (bound_x + step_x))
	pos_y = OVERMAP_PIXEL_TO_DIST(1 + (y - 1) * WORLD_ICON_SIZE + (bound_y + step_y))

// legacy ticking hook
/obj/overmap/entity/process(delta_time)
	physics_tick(delta_time)

/obj/overmap/entity/proc/physics_tick(dt)
	if(!overmap)
		return // what are we doing
	// amount should move
	var/ddx = vel_x * dt
	var/ddy = vel_y * dt
	// new phys step loc
	pos_x += ddx
	pos_y += ddy
	// where to move to
	var/nsx = floor(OVERMAP_DIST_TO_PIXEL(pos_x))
	var/nsy = floor(OVERMAP_DIST_TO_PIXEL(pos_y))
	// move
	var/old_loc = loc
	if(!Move(locate(1, 1, z), dir, nsx - (WORLD_ICON_SIZE * 0.5), nsy - (WORLD_ICON_SIZE * 0.5)))
		initialize_physics()
		stack_trace("failed to move")
	else if(old_loc != loc)
		Moved(old_loc, NONE)

/obj/overmap/entity/proc/adjust_velocity(vx, vy)
	if(!isnull(vx))
		vel_x += vx
	if(isnull(vy))
		vel_y += vy

	if(!is_moving && (QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)))
		activate_physics()

/obj/overmap/entity/proc/set_velocity(vx, vy)
	if(!isnull(vx))
		vel_x = vx
	if(!isnull(vy))
		vel_y = vy

	if(!is_moving && (QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)))
		activate_physics()

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
 * gets our movement (non-angular) speed in overmaps units per second
 */
/obj/overmap/entity/proc/get_speed()
	return sqrt(vel_x ** 2 + vel_y ** 2)

/**
 * get clockwise of N degrees heading of our cardinal velocity
 */
/obj/overmap/entity/proc/get_heading()
	return (arctan(vel_y, vel_x) + 360) % 360
