/**
 * (re)initialize physics
 */
/obj/overmap/entity/proc/initialize_physics()
	deactivate_physics()
	vel_x = 0
	vel_y = 0
	// todo: proper overmaps physics, take diff from overmap south/west
	pos_x = (((loc.x - 1) * WORLD_ICON_SIZE) * OVERMAP_DISTANCE_PIXEL) + ((WORLD_ICON_SIZE * 0.5) * OVERMAP_DISTANCE_PIXEL)
	pos_y = (((loc.y - 1) * WORLD_ICON_SIZE) * OVERMAP_DISTANCE_PIXEL) + ((WORLD_ICON_SIZE * 0.5) * OVERMAP_DISTANCE_PIXEL)
	pixel_x = 0
	pixel_y = 0

// legacy ticking hook
/obj/overmap/entity/process(delta_time)
	physics_tick(delta_time)

/obj/overmap/entity/proc/physics_tick(dt)
	// todo: proper overmaps physics, take diff from overmap south/west
	var/new_position_x = pos_x + vel_x * dt
	var/new_position_y = pos_y + vel_y * dt

	var/new_pos_pix_x = OVERMAP_DIST_TO_PIXEL(new_position_x)
	var/new_pos_pix_y = OVERMAP_DIST_TO_PIXEL(new_position_y)

	// For simplicity we assume that you can't travel more than one turf per tick.  That would be hella-fast.
	var/new_turf_x = CEILING(new_pos_pix_x / WORLD_ICON_SIZE, 1)
	var/new_turf_y = CEILING(new_pos_pix_y / WORLD_ICON_SIZE, 1)

	var/new_pixel_x = MODULUS(new_pos_pix_x, WORLD_ICON_SIZE) - (WORLD_ICON_SIZE / 2) - 1
	var/new_pixel_y = MODULUS(new_pos_pix_y, WORLD_ICON_SIZE) - (WORLD_ICON_SIZE / 2) - 1

	var/new_loc = locate(new_turf_x, new_turf_y, z)

	pos_x = new_position_x
	pos_y = new_position_y

	if(new_loc != loc)
		var/turf/old_loc = loc
		Move(new_loc, NORTH, dt * 10)
		if(get_dist(old_loc, loc) > 1)
			pixel_x = new_pixel_x
			pixel_y = new_pixel_y
			return
	// todo: actual animations
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = 8, flags = ANIMATION_END_NOW)

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
	if(isnull(vy))
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
	return (arctan(vel_y, vel_x) + 360) % 360
