//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to reassert doors on an airlock system.
 * * This will close / open doors as necessary to restore state
 *   if an airlock is idle.
 */
/datum/airlock_cycle/reassert_doors
	initial_desc = "Reasserting Doors"

/datum/airlock_cycle/reassert_doors/create_cycling(interior_lock_state, exterior_lock_state)
	return ..()

/datum/airlock_cycle/reassert_doors/gather_phases(interior_lock_state, exterior_lock_state)
	. = list()
	var/lock_interior
	var/open_interior
	var/lock_exterior
	var/open_exterior

	var/interior_state = interior_lock_state
	switch(interior_state)
		if(TRUE)
			lock_interior = open_interior = TRUE
		if(FALSE)
			lock_interior = TRUE
			open_interior = FALSE
		if(null)
			lock_interior = FALSE

	var/exterior_state = exterior_lock_state
	switch(exterior_state)
		if(TRUE)
			lock_exterior = open_exterior = TRUE
		if(FALSE)
			lock_exterior = TRUE
			open_exterior = FALSE
		if(null)
			lock_exterior = FALSE

	. += new /datum/airlock_phase/doors/assert_state(open_interior, lock_interior, open_exterior, lock_exterior)
