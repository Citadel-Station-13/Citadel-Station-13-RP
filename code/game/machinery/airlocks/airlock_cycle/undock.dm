//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to undock.
 * * Will just lock doors and treat airlock as now-interior.
 */
/datum/airlock_cycle/undock

/datum/airlock_cycle/undock/create_cycling(datum/airlock_system/system)
	return ..()

/datum/airlock_cycle/undock/gather_phases(datum/airlock_system/system)
	. = list()
	. += new /datum/airlock_phase/doors/lock_closed/exterior
