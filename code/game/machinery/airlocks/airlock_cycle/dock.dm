//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to dock.
 * * Will fill air fully before opening.
 */
/datum/airlock_cycle/dock

#warn impl

/datum/airlock_cycle/dock/create_cycling(datum/airlock_system/system)
	return ..()

/datum/airlock_cycle/dock/gather_phases(datum/airlock_system/system)
	. = list()
