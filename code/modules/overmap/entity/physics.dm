/obj/overmap/entity/proc/physics_tick(dt)
	#warn uh

/obj/overmap/entity/proc/adjust_velocity(vx, vy)
	set_velocity(vel_x + vx, vel_y + vy)

/obj/overmap/entity/proc/set_velocity(vx, vy)
	vel_x = vx
	vel_y = vy

	if(!should_be_moving && (QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)))
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
	// todo: proper overmaps ticking
	START_PROCESSING(SSprocessing, src)

/obj/overmap/entity/proc/deactivate_physics()
	if(!is_moving)
		return
	is_moving = FALSE
	// todo: proper overmaps ticking
	STOP_PROCESSING(SSprocessing, src)

/**
 * check if we're moving, used to determine if we need to start ticking
 */
/obj/overmap/entity/proc/is_moving()
	return QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)

/**
 * gets our movement (non-angular) speed
 */
/obj/overmap/entity/proc/get_speed()
	return sqrt(vel_x ** 2 + vel_y ** 2)

/**
 * get clockwise of N degrees heading of our cardinal velocity
 */
/obj/overmap/entity/proc/get_heading()
	return arctan(vel_y, vel_x)
