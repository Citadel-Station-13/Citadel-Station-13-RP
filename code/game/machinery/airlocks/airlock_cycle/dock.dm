//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to dock.
 * * Will fill air fully before opening.
 */
/datum/airlock_cycle/dock

/datum/airlock_cycle/dock/create_cycling(datum/airlock_system/system)
	return ..()

/datum/airlock_cycle/dock/gather_phases(datum/airlock_system/system)
	. = list()
	. += new /datum/airlock_phase/doors/lock_closed/exterior
	. += new /datum/airlock_phase/repressurize/allow_external_air
	. += new /datum/airlock_phase/doors/lock_open/everything
