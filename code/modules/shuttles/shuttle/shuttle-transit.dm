//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle/proc/prepare_transit()
	ASSERT(!transit_reservation)
	#warn uhh
	#warn make sure we have a border

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
 * * movable_handler - called with (AM) for the movables outside the shuttle
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
	#warn impl
	#warn how to handle turns and translations??

	if(turf_handler)
		for(var/turf/T as anything in transit_reservation.unordered_inner_turfs())
			if(T.type == transit_reservation.turf_type)
				continue
			turf_handler.Invoke(T)

/datum/shuttle/
