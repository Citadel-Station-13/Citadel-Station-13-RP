/**
 * physics update
 */
/atom/movable/overmap_object/entity/proc/physics_tick(seconds)
#warn do all of these

/**
 * move to where we should be
 */
/atom/movable/overmap_object/entity/proc/move_to_location()

/**
 * set velocity to x, y
 */
/atom/movable/overmap_object/entity/proc/set_velocity(x, y)

/**
 * set rotational velocity to [angle per second clockwise]
 */
/atom/movable/overmap_object/entity/proc/set_angular_velocity(a)

/**
 * add velocity
 */
/atom/movable/overmap_object/entity/proc/adjust_velocity(x, y)

/**
 * adjust angular velocity
 */
/atom/movable/overmap_object/entity/proc/adjust_angular_veloctiy(a)

/**
 * immediate move to
 */
/atom/movable/overmap_object/entity/proc/set_position(x, y, rotation)

/**
 * immediate move to overmap
 */
/atom/movable/overmap_object/entity/proc/set_overmap(datum/overmap/O, x, y, rotation)

/**
 * remove from overmap - this will NOT move us off the overmap to nullspace
 * only call this if you know what you're doing!
 */
/atom/movable/overmap_object/entity/proc/remove_from_overmap()

/**
 * forcemove hook -  moves us to the correct position on an overmap!
 */
/atom/movable/overmap_object/entity/forceMove(atom/destination)
	// TODO: pixel_movement?

	. = ..()

/**
 * add a source for physics pausing
 */
/atom/movable/overmap_object/entity/proc/pause_physics(source)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!source)
		CRASH("No source")
	var/old = length(physics_paused)
	LAZYOR(physics_paused, source)
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
#warn do all of these

/**
 * move out of our current overmap object
 * this does not handle stuff like shuttle docking, this is the raw physics action
 * this will spit us out into their tile, whereever that is
 */
/atom/movable/overmap_object/entity/proc/move_outside_entity()

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

/**
 * called when we physically move out of another overmap object into the overmap
 */
/atom/movable/overmap_object/entity/proc/physics_undocked(atom/movable/overmap_object/entity/E)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(ison_mob)
		stack_trace("physics_undocked while is on map!")
	unpause_physics(ENTITY_PHYSICS_PAUSE_FOR_DOCKED)
	is_on_map = TRUE
	SEND_SIGNAL(src, COMSIG_OVERMAP_ENTITY_PHYSICS_UNDOCK, E)

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
