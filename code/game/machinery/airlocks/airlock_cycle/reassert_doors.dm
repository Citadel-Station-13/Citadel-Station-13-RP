//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to reassert doors on an airlock system.
 * * This will close / open doors as necessary to restore state
 *   if an airlock is idle.
 */
/datum/airlock_cycle/reassert_doors

#warn impl

/datum/airlock_cycle/reassert_doors/create_cycling(datum/airlock_system/system)
	return ..()

/datum/airlock_cycle/reassert_doors/gather_phases(datum/airlock_system/system)
	. = list()
