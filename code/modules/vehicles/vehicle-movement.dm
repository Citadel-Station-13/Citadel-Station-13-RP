//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/// Just an analogue of the mob proc for when we refactor vehicles to mobs.
/obj/vehicle/proc/movement_delay()
	return movespeed_hyperbolic

/**
 * Called when a user wants to turn the vehicle.
 */
/obj/vehicle/proc/user_vehicle_turn(direction)
	return vehicle_turn(direction)

/**
 * Called when a user wants to move the vehicle.
 */
/obj/vehicle/proc/user_vehicle_move(direction, face_direction)
	return vehicle_move(direction, face_direction)

/**
 * Vehicle-initiated turns go through this.
 */
/obj/vehicle/proc/vehicle_turn(direction)
	SHOULD_NOT_SLEEP(TRUE)
	if(dir == direction)
		return TRUE
	setDir(direction)
	return TRUE

/**
 * Vehicle-initiated moves go through this.
 */
/obj/vehicle/proc/vehicle_move(direction, face_direction)
	SHOULD_NOT_SLEEP(TRUE)
	if(world.time < move_delay)
		return FALSE
	if(direction & (UP|DOWN))
		#warn hook move upwards/downwards to go here
		#warn z-move
	else
		var/turf/new_loc = get_step(src, direction)
		if(!Move(new_loc, face_direction))
			return FALSE
	var/add_delay = max(world.tick_lag, movement_delay())
	// enforce euclidean dist on diagonal moves
	if(ISDIAGONALDIR(direction) && loc == new_loc)
		add_delay *= SQRT_2
	move_delay = world.time + add_delay
	return TRUE

/obj/vehicle/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	update_gravity()
	if(forced)
		if(trailer)
			// detach trailer
			#warn how?
	else
		if(trailer)
			// move trailer
			var/trailer_pull_dir = get_dir(trailer, old_loc)
			step(trailer, trailer_pull_dir)

/obj/vehicle/proc/update_gravity()
	var/has_gravity = has_gravity()
	if(has_gravity == in_gravity)
		return
	var/old_gravity = in_gravity
	in_gravity = has_gravity
	on_gravity_change(has_gravity, old_gravity)

/obj/vehicle/proc/on_gravity_change(old_gravity, new_gravity)
	update_movespeed()
