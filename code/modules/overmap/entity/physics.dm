/**
 * physics update
 */
/atom/movable/overmap_object/entity/proc/physics_tick(seconds)

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
	if(!source)
		return
	LAZYOR(physics_paused, source)
	if(physics_mode == ENTITY_PHYSICS_SIMULATED)
		physics_mode = ENTITY_PHYSICS_PAUSED

/**
 * remove a source for physics pausing
 */
/atom/movable/overmap_object/entity/proc/unpause_physics(source)
	if(!source)
		return
	LAZYREMOVE(physics_paused, source)
	if(length(physics_paused))
		return
	if(physics_mode == ENTITY_PHYSICS_PAUSED)
		physics_mode = ENTITY_PHYSICS_SIMULATED

/**
 * move inside another overmap object.
 */
/atom/movable/overmap_object/entity/proc/attempt_physics_dock(atom/movable/overmap_object/entity/E)

/**
 * move out of our current overmap object
 */
/atom/movable/overmap_object/entity/proc/attempt_physics_undock()

/**
 * called when we physically move into another overmap object from the overmap
 */
/atom/movable/overmap_object/entity/proc/physics_docked(atom/movable/overmap_object/entity/E)
	pause_physics(ENTITY_PHYSICS_PAUSE_FOR_DOCKED)

/**
 * called when we physically move out of another overmap object into the overmap
 */
/atom/movable/overmap_object/entity/proc/physics_undocked(atom/movable/overmap_object/entity/E)
	unpause_physics(ENTITY_PHYSICS_PAUSE_FOR_DOCKED)

/**
 * enter hook to ensure physics docked/undocked is called.
 */
/atom/movable/overmap_object/entity/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!isturf(oldLoc))		// only pause if they're moving from overmaps
		return
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return
	var/atom/movable/overmap_object/entity/E = AM
	if(!E.physics_docking)
		E.physics_docked(src)
		#warn overmaps logging

/**
 * exit hook to ensure physics docked/undocked is called
 */
/atom/movable/overmap_object/entity/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(!isturf(newLoc))		// only unpause if they're moving into overmaps
		return
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return
	var/atom/movable/overmap_object/entity/E = AM
	if(!E.physics_docking)
		E.physics_undocked(src)
		#warn overmaps logging
