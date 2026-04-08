//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle/proc/prepare_transit(prefer_direction)
	ASSERT(!transit_reservation)

	prefer_direction = prefer_direction || descriptor.preferred_orientation || anchor.dir

	var/effective_width
	var/effective_height

	if(prefer_direction == anchor.dir || prefer_direction == turn(anchor.dir, 180))
		#warn impl
	else
		#warn impl

	#warn correct turf / border
	transit_reservation = SSmapping.request_block_reservation(
		effective_width,
		effective_height,
		/datum/map_reservation/transit,
	)
	transit_reservation.prepare_dock(src, prefer_direction)
	return TRUE

/**
 * tears down our transit reservation
 * you usually want to call this after we leave
 *
 * if handlers are not provided,
 *
 * * turfs are deleted
 * * movables that aren't marked with [MOVABLE_NO_LOST_IN_SPACE] are deleted
 * * movables that are marked with that are translated with the shuttle if possible, otherwise kicked to a spot near the shuttle
 *
 * @params
 * * movable_handler - called with (AM) for the movables outside the shuttle; called before turf_handler. ATOM_ABSTRACT atoms are ignored.
 * * turf_handler - called with (T) for turfs that aren't part of the shuttle or reservation's base turf
 * * skyfall - default movable handler (if not provided) should throw movables out of the sky in planets
 * * all_movables - call movable_handler on all movables, not just ones marked with NO_LOST_IN_SPACE
 */
/datum/shuttle/proc/teardown_transit(datum/callback/movable_handler, datum/callback/turf_handler, skyfall, all_movables)
	if(!transit_reservation)
		return
	if(transit_reservation.is_atom_inside(anchor))
		CRASH("tried to teardown transit while inside it!")

	movable_handler = movable_handler || CALLBACK(src, PROC_REF(default_transit_movable_cleaner))

	var/anything_found = TRUE
	var/safety = 5
	while(anything_found && safety > 0)
		safety--
		anything_found = FALSE
		for(var/turf/T as anything in transit_reservation.unordered_inner_turfs())
			for(var/atom/movable/AM as anything in T.contents)
				if(AM.atom_flags & ATOM_ABSTRACT)
					continue
				movable_handler.Invoke(AM)
				anything_found = TRUE
			if(T.type != transit_reservation.turf_type)
				turf_handler.Invoke(T)
			CHECK_TICK
	if(anything_found)
		STACK_TRACE("teardown_transit failed to clean up all atoms in reservation after multiple passes!")

	return TRUE

/**
 * Immediately jump to transit, skipping any sort of docking or takeoff process.
 */
/datum/shuttle/proc/immediately_jump_to_transit(prefer_direction)
	if(!transit_reservation)
		prepare_transit(prefer_direction)
	// use the dock dir, dock dir is allocated from our preferred dir when making transit
	dock(transit_reservation.transit_dock, centered = TRUE, direction = transit_reservation.transit_dock.dir)
