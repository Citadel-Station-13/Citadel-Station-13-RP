/**
 * physics update
 */
/atom/movable/overmap_object/entity/proc/physics_tick(seconds)
	if(physics_paused || !overmap)	// paused or no overmap
		return

	OVERMAP_AGGRESSIVE_ASSERT(isturf(loc) && overmap.physically_in_bounds(src))

	var/dx = velocity_x * seconds
	var/dy = velocity_y * seconds
	var/da = angular_velocity * seconds

	position_x += dx
	position_y += dy
	angle += da
	angle = SIMPLIFY_DEGREES(angle)

	if(dx > OVERMAP_WORLD_ICON_SIZE || dy > OVERMAP_WORLD_ICON_SIZE)	// not sure how this is possible but we're jumping so..
		move_to_location()
		return

	var/turf/T = locate((position_x / OVERMAP_DISTANCE_TILE) + overmap.cached_x_start, (position_y / OVERMAP_DISTANCE_TILE) + overmap.cached_y_start, overmap.cached_z)
	OVERMAP_AGGRESSIVE_ASSERT(T.x == (FLOOR(position_x / OVERMAP_DISTANCE_TILE, 1) + overmap.cached_x_start))
	OVERMAP_AGGRESSIVE_ASSERT(T.y == (FLOOR(position_y / OVERMAP_DISTANCE_TILE, 1) + overmap.cached_y_start))
	if(get_dist(T, loc) > 1)
		// jumping
		move_to_location()
		return

	// animate movement
	if(T != loc)
		// shift into new turf
		step_towards(src, T)
		pixel_x = position_x % OVERMAP_DISTANCE_TILE
		pixel_y = pixel_y % OVERMAP_DISTANCE_TILE
	else
		// shift in place
		animate(src, pixel_x = position_x % OVERMAP_DISTANCE_TILE, pixel_y = pixel_y % OVERMAP_DISTANCE_TILE, time = seconds)
	// animate rotation
	var/matrix/M = matrix()
	M.Turn(angle)
	animate(src, transform = M, time = seconds)
	ensure_hash_correctness()
/**
 * move to where we should be immediately without visuals
 */
/atom/movable/overmap_object/entity/proc/move_to_location()
	OVERMAP_AGGRESSIVE_ASSERT(isturf(loc))
	jumping = TRUE
	forceMove(
		locate((position_x / OVERMAP_DISTANCE_TILE) + overmap.cached_x_start),
		locate((position_y / OVERMAP_DISTANCE_TILE) + overmap.cached_y_start),
		overmap.cached_z
	)
	jumping = FALSE
	OVERMAP_AGGRESSIVE_ASSERT(loc.x == (FLOOR(position_x / OVERMAP_DISTANCE_TILE, 1) + overmap.cached_x_start))
	OVERMAP_AGGRESSIVE_ASSERT(loc.y == (FLOOR(position_y / OVERMAP_DISTANCE_TILE, 1) + overmap.cached_y_start))
	pixel_x = position_x % OVERMAP_DISTANCE_TILE
	pixel_y = position_y % OVERMAP_DISTANCE_TILE
	var/matrix/M = matrix()
	M.Turn(angle)
	transform = M
	ensure_hash_correctness()

/**
 * ensure we're in the right spatial hash
 */
/atom/movable/overmap_object/entity/proc/ensure_hash_correctness()
	// 1 arg round is floor
	if(round(position_x / OVERMAP_SPATIAL_HASH_COORDSIZE) != last_spatial_x || round(position_y / OVERMAP_SPATIAL_HASH_COORDSIZE) != last_spatial_y)
		overmap._spatial_update_entity(src)

/**
 * forcefully point our nose towards our motion, resetting angular velocity
 */
/atom/movable/overmap_object/entity/proc/orient_to_velocity()
	set_angular_velocity(0)
	// arctan is degrees clockwise from east
	// the reason we don't do this with our angle is because
	// the rest of byond/ss13 doesn't
	// i hate all coders
	set_angle(90 - arctan(velocity_x, velocity_y))

/**
 * set velocity to x, y
 */
/atom/movable/overmap_object/entity/proc/set_velocity(x, y)
	velocity_x = clamp(x, -SSovermaps.max_entity_speed, SSovermaps.max_entity_speed)
	velocity_y = clamp(y, -SSovermaps.max_entity_speed, SSovermaps.max_entity_speed)
	wake_physics()

/**
 * set rotational velocity to [angle per second clockwise]
 */
/atom/movable/overmap_object/entity/proc/set_angular_velocity(a)
	angular_velocity = a
	wake_physics()

/**
 * set angle
 */
/atom/movable/overmap_object/entity/proc/set_angle(a)
	angle = SIMPLIFY_DEGREES(a)
	move_to_location()
	wake_physics()

/**
 * add velocity
 */
/atom/movable/overmap_object/entity/proc/adjust_velocity(x, y)
	velocity_x = clamp(velocity_x + x, -SSovermaps.max_entity_speed, SSovermaps.max_entity_speed)
	velocity_y = clamp(velocity_y + y, -SSovermaps.max_entity_speed, SSovermaps.max_entity_speed)
	wake_physics()

/**
 * adjust angular velocity
 */
/atom/movable/overmap_object/entity/proc/adjust_angular_veloctiy(a)
	angular_velocity +=a
	wake_physics()

/**
 * immediate move to
 */
/atom/movable/overmap_object/entity/proc/set_position(x, y, rotation)
	position_x = x
	position_y = y
	angle = rotation
	move_to_location()
	wake_physics()

/**
 * immediate move to overmap
 */
/atom/movable/overmap_object/entity/proc/set_overmap(datum/overmap/O, x, y, rotation, vel_x, vel_y, vel_angle)
	#warn impl

/**
 * remove from overmap - this will NOT move us off the overmap to nullspace
 * only call this if you know what you're doing!
 */
/atom/movable/overmap_object/entity/proc/remove_from_overmap()


	_overmap_spatial_hash_index = last_spatial_x = last_spatial_y = null
	#warn impl

/**
 * add to the overmap we're currently in
 * make sure we're, y'know, in an overmap, or we'll just be in limbo!
 */
/atom/movable/overmap_object/entity/proc/add_to_overmap()
	#warn impl

/**
 * check if we're moving, used to determine if we need to start ticking
 */
/atom/movable/overmap_object/entity/proc/is_moving()
	return QUANTIZE_OVERMAP_SPEED(velocity_x) && QUANTIZE_OVERMAP_SPEED(velocity_y)

/**
 * start ticking physics
 */
/atom/movable/overmap_object/entity/proc/wake_physics()
	if(moving)
		return
	moving = TRUE
	if(overmap)
		overmap.moving += src

/**
 * stop ticking physics
 */
/atom/movable/overmap_object/entity/proc/kill_physics()
	if(!moving)
		return
	moving = FALSE
	if(overmap)
		overmap.moving -= src

/**
 * reset physics
 */
/atom/movable/overmap_object/entity/proc/reset_physics()
	set_angular_velocity(0)
	set_velocity(0, 0)
	if(moving)
		kill_physics()

/**
 * forcemove hook -  moves us to the correct position on an overmap and reset physics!
 */
/atom/movable/overmap_object/entity/forceMove(atom/destination)
	if(jumping)
		return ..()
	. = ..()
	if(!overmap.physically_in_bounds(get_turf(destination)))
		remove_from_overmap()
		add_to_overmap()		// adds us if we're in another overmap
		return
	x = (x - overmap.cached_x_start) + 16
	y = (y - overmap.cached_y_start) + 16
	// above jumps us to center of tile
	// move
	move_to_location()

/**
 * if we jump to nullspace, GTFO our overmap
 */
/atom/movable/overmap_object/entity/moveToNullspace()
	remove_from_overmap()
	return ..()

/**
 * check if physics paused
 */
/atom/movable/overmap_object/entity/proc/physics_paused(source)
	return source? (source in physics_paused) : !!physics_paused

/**
 * add a source for physics pausing
 */
/atom/movable/overmap_object/entity/proc/pause_physics(source)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!source)
		CRASH("No source")
	var/old = length(physics_paused)
	LAZYDISTINCTADD(physics_paused, source)
	if(physics_mode == ENTITY_PHYSICS_SIMULATED)
		physics_mode = ENTITY_PHYSICS_PAUSED
	if(!old)
		SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_PAUSED)

/**
 * remove a source for physics pausing
 */
/atom/movable/overmap_object/entity/proc/unpause_physics(source)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!source)
		CRASH("No source")
	LAZYREMOVE(physics_paused, source)
	if(length(physics_paused))
		return
	if(physics_mode == ENTITY_PHYSICS_PAUSED)
		physics_mode = ENTITY_PHYSICS_SIMULATED
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_UNPAUSED)

/**
 * move inside another overmap object.
 * this does not handle stuff like shuttle docking, this is the raw physics action
 */
/atom/movable/overmap_object/entity/proc/move_inside_entity(atom/movable/overmap_object/entity/E)
	jumping = TRUE
	forceMove(E)
	jumping = FALSE

/**
 * move out of our current overmap object
 * this does not handle stuff like shuttle docking, this is the raw physics action
 * this will spit us out into their tile, whereever that is
 */
/atom/movable/overmap_object/entity/proc/move_outside_entity()
	ASSERT(loc)
	jumping = TRUE
	forceMove(loc.loc)
	jumping = FALSE

/**
 * called when we physically move into another overmap object from the overmap
 */
/atom/movable/overmap_object/entity/proc/physics_docked(atom/movable/overmap_object/entity/E)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!is_on_map)
		stack_trace("physics_docked while is not on map!")
	pause_physics(ENTITY_PHYSICS_PAUSE_FOR_DOCKED)
	is_on_map = FALSE
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_DOCK, E)
	// null velocity while docked
	set_velocity(0, 0)
	set_angular_velocity(0)

/**
 * called when we physically move out of another overmap object into the overmap
 */
/atom/movable/overmap_object/entity/proc/physics_undocked(atom/movable/overmap_object/entity/E)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(is_on_map)
		stack_trace("physics_undocked while is on map!")
	unpause_physics(ENTITY_PHYSICS_PAUSE_FOR_DOCKED)
	is_on_map = TRUE
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_UNDOCK, E)
	// inertia; inherit velocity
	// check if we're the top
	var/atom/movable/overmap_object/entity/top = E
	// if not, keep searching for top atom.
	if(!top.loc)
		// don't bother
		return
	while(!isturf(top.loc))
		top = top.loc
	if(!istype(top, /atom/movable/overmap_object/entity))
		CRASH("overmap entity could not find top due to top object not being an entity during chained undock")
	set_velocity(top.velocity_x, top.velocity_y)
	set_angular_velocity(top.angular_velocity)

/**
 * called when we enter entities for any reason
 */
/atom/movable/overmap_object/entity/proc/physics_enter_entity(atom/movable/overmap_object/entity/E)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_ENTER, E)

/**
 * called when we exit entities for any reason
 */
/atom/movable/overmap_object/entity/proc/physics_exit_entity(atom/movable/overmap_object/entity/E)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_EXIT, E)

/**
 * enter hook to ensure physics docked/undocked is called.
 */
/atom/movable/overmap_object/entity/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return
	var/atom/movable/overmap_object/entity/E = AM
	E.physics_enter_entity(src)
	if(isturf(oldLoc))		// only pause if they're moving from overmaps
		if(!E.physics_docking)
			E.physics_docked(src)

/**
 * exit hook to ensure physics docked/undocked is called
 */
/atom/movable/overmap_object/entity/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return
	var/atom/movable/overmap_object/entity/E = AM
	E.physics_exit_entity(src)
	if(isturf(newLoc))		// only unpause if they're moving into overmaps
		if(!E.physics_docking)
			E.physics_undocked(src)
