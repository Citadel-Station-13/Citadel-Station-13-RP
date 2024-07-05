//Designed for things that need precision trajectories like projectiles.
//Don't use this for anything that you don't absolutely have to use this with (like projectiles!) because it isn't worth using a datum unless you need accuracy down to decimal places in pixels.

#warn oh my god i hate all of this

// todo: rewrite positions they're bad

/**
 * Stores x/y/z and pixel_x/pixel_y
 */
/datum/position
	var/x = 0
	var/y = 0
	var/z = 0
	var/pixel_x = 0
	var/pixel_y = 0

/datum/position/proc/valid()
	return x && y && z && !isnull(pixel_x) && !isnull(pixel_y)

/datum/position/New(_x = 0, _y = 0, _z = 0, _pixel_x = 0, _pixel_y = 0)	//first argument can also be a /datum/point.
	if(istype(_x, /datum/point))
		var/datum/point/P = _x
		var/turf/T = P.turf()
		_x = T.x
		_y = T.y
		_z = T.z
		_pixel_x = P.pixel_x()
		_pixel_y = P.pixel_y()
	else if(istype(_x, /atom))
		var/atom/A = _x
		_x = A.x
		_y = A.y
		_z = A.z
		_pixel_x = A.pixel_x
		_pixel_y = A.pixel_y
	x = _x
	y = _y
	z = _z
	pixel_x = _pixel_x
	pixel_y = _pixel_y

/datum/position/proc/return_turf()
	return locate(x, y, z)

/datum/position/proc/return_px()
	return pixel_x

/datum/position/proc/return_py()
	return pixel_y

/datum/position/proc/return_point()
	return new /datum/point(src)

//* Points *//

/**
 * returns midpoint between two points as a /datum/point
 */
/proc/midpoint_between_points(datum/point/a, datum/point/b)	//Obviously will not support multiZ calculations! Same for the two below.
	return new point(a.x + (b.x - a.x) / 2, a.y + (b.y - a.y) / 2, a.z)

/**
 * returns pixel distance between two points
 */
/proc/distance_between_points(datum/point/a, datum/point/b)
	return sqrt(((b.x - a.x) ** 2) + ((b.y - a.y) ** 2))

/**
 * returns north-0 clockwise angle between two points
 */
/proc/angle_between_points(datum/point/a, datum/point/b)
	return arctan((b.y - a.y), (b.x - a.x))

/**
 * A precise point on the map.
 *
 * x/y are absolute pixels from map edge, so 1, 1 = the lower-left most pixel on the zlevel, not the center of turf (1,1)!
 */
/datum/point
	var/x = 0
	var/y = 0
	var/z = 0

/datum/point/New(x, y, z)
	if(!isnum(x))
		switch(x:type)
			if(/datum/position)
				var/datum/position/casted = x
				src.x = casted.x * WORLD_ICON_SIZE - ((WORLD_ICON_SIZE / 2) - 1) + casted.pixel_x
				src.y = casted.y * WORLD_ICON_SIZE - ((WORLD_ICON_SIZE / 2) - 1) + casted.pixel_y
				src.z = casted.z
			if(/datum/point)
				var/datum/point/casted = x
				src.x = casted.x
				src.y = casted.y
				src.z = casted.z
		if(isatom(x))
			var/atom/casted = x
			src.x = casted.x * WORLD_ICON_SIZE - (WORLD_ICON_SIZE / 2) + casted.pixel_x
			src.y = casted.y * WORLD_ICON_SIZE - (WORLD_ICON_SIZE / 2) + casted.pixel_y
			src.z = casted.z
		if(isnull(x))
			return
		CRASH("unknown x value on point init")
	src.x = x
	src.y = y
	src.z = z

/datum/point/clone()
	return new /datum/point(src)

/datum/point/proc/turf()
	return locate(round(x / WORLD_ICON_SIZE) + 1, round(y / WORLD_ICON_SIZE) + 1, z)

/datum/point/proc/initialize_location(tile_x, tile_y, tile_z, p_x = 0, p_y = 0)
	if(!isnull(tile_x))
		x = ((tile_x - 1) * WORLD_ICON_SIZE) + WORLD_ICON_SIZE / 2 + p_x + 1
	if(!isnull(tile_y))
		y = ((tile_y - 1) * WORLD_ICON_SIZE) + WORLD_ICON_SIZE / 2 + p_y + 1
	if(!isnull(tile_z))
		z = tile_z

/datum/point/proc/coords()
	return list(round(x / WORLD_ICON_SIZE) + 1, round(y / WORLD_ICON_SIZE) + 1, z)

/**
 * angle is clockwise from north
 */
/datum/point/proc/shift_in_projectile_angle(angle, distance)
	x += sin(angle) * distance
	y += cos(angle) * distance

/**
 * doesn't use set base pixel x/y
 *
 * if not on a turf, we return null
 */
/datum/point/proc/instantiate_movable_with_unmanaged_offsets(typepath, ...)
	ASSERT(ispath(typepath, /atom/movable))
	// todo: inline everything
	var/turf/where = return_turf()
	if(!where)
		return
	var/atom/movable/created = new typepath(arglist(list(where) + args.Copy(2)))
	created.pixel_x = return_px()
	created.pixel_y = return_py()
	return created

/**
 * return rounded pixel x
 */
/datum/point/proc/return_px()
	// 1 = -15,
	// 32 = +16
	// we start at 16, 16
	. = x % WORLD_ICON_SIZE
	if(!.)
		return 16
	. -= 16

/**
 * return rounded pixel y
 */
/datum/point/proc/return_py()
	// 1 = -15,
	// 32 = +16
	// we start at 16, 16
	. = y % WORLD_ICON_SIZE
	if(!.)
		return 16
	. -= 16

/**
 * return  turf
 */
/datum/point/proc/return_turf()
	return locate(
		ceil(floor(x) / WORLD_ICON_SIZE),
		ceil(floor(y) / WORLD_ICON_SIZE),
		z,
	)

/**
 * extract closest in-bounds turf
 *
 * does not check for map transitions
 */
/datum/point/proc/clamped_return_turf()
	return locate(
		clamp(ceil(floor(x) / WORLD_ICON_SIZE), 1, world.maxx),
		clamp(ceil(floor(y) / WORLD_ICON_SIZE), 1, world.maxy),
		z,
	)

/**
 * return list(x, y, z)
 */
/datum/point/proc/return_coordinates()		//[turf_x, turf_y, z]
	return list(
		ceil(floor(x) / WORLD_ICON_SIZE),
		ceil(floor(y) / WORLD_ICON_SIZE),
		z,
	)

/datum/point/vector
	/// Pixels per iteration
	var/speed = 32
	var/iteration = 0
	var/angle = 0
	/// Calculated x movement amounts to prevent having to do trig every step.
	var/mpx = 0
	/// Calculated y movement amounts to prevent having to do trig every step.
	var/mpy = 0
	var/starting_x = 0 //just like before, pixels from EDGE of map! This is set in initialize_location().
	var/starting_y = 0
	var/starting_z = 0

/datum/point/vector/New(_x, _y, _z, _pixel_x = 0, _pixel_y = 0, _angle, _speed, initial_increment = 0)
	..()
	initialize_trajectory(_speed, _angle)
	if(initial_increment)
		increment(initial_increment)

/datum/point/vector/initialize_location(tile_x, tile_y, tile_z, p_x = 0, p_y = 0)
	. = ..()
	starting_x = x
	starting_y = y
	starting_z = z

/datum/point/vector/copy_to(datum/point/vector/v = new)
	..(v)
	v.speed = speed
	v.iteration = iteration
	v.angle = angle
	v.mpx = mpx
	v.mpy = mpy
	v.starting_x = starting_x
	v.starting_y = starting_y
	v.starting_z = starting_z
	return v

/datum/point/vector/proc/initialize_trajectory(pixel_speed, new_angle)
	if(!isnull(pixel_speed))
		speed = pixel_speed
	set_angle(new_angle)

/// Calculations use "byond angle" where north is 0 instead of 90, and south is 180 instead of 270.
/datum/point/vector/proc/set_angle(new_angle)
	if(isnull(angle))
		return
	angle = new_angle
	update_offsets()

/datum/point/vector/proc/update_offsets()
	mpx = sin(angle) * speed
	mpy = cos(angle) * speed

/datum/point/vector/proc/set_speed(new_speed)
	if(isnull(new_speed) || speed == new_speed)
		return
	speed = new_speed
	update_offsets()

/datum/point/vector/proc/increment(multiplier = 1)
	iteration++
	x += mpx * (multiplier)
	y += mpy * (multiplier)

/datum/point/vector/proc/return_vector_after_increments(amount = 7, multiplier = 1, force_simulate = FALSE)
	var/datum/point/vector/v = copy_to()
	if(force_simulate)
		for(var/i in 1 to amount)
			v.increment(multiplier)
	else
		v.increment(multiplier * amount)
	return v

/datum/point/vector/proc/on_z_change()
	return

/datum/point/vector/processed // pixel_speed is per decisecond.
	var/last_process = 0
	var/last_move = 0
	var/paused = FALSE

/datum/point/vector/processed/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	return ..()

/datum/point/vector/processed/proc/start()
	last_process = world.time
	last_move = world.time
	START_PROCESSING(SSprojectiles, src)

/datum/point/vector/processed/process(delta_time)
	if(paused)
		last_move += world.time - last_process
		last_process = world.time
		return
	var/needed_time = world.time - last_move
	last_process = world.time
	last_move = world.time
	increment(needed_time / SSprojectiles.wait)
