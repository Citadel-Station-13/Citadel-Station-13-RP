//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A program to restore state when cancelling
 */
/datum/airlock_cycle/cancel_and_restore
	initial_desc = "Cancelling"

/datum/airlock_cycle/cancel_and_restore/create_cycling(was_on_side)
	var/datum/airlock_cycling/cycling = ..()
	cycling.blackboard[AIRLOCK_CYCLING_BLACKBOARD_IS_CANCEL_OP] = TRUE
	return cycling

/datum/airlock_cycle/cancel_and_restore/gather_phases(was_on_side)
	. = list()
	. += new /datum/airlock_phase/doors/seal
	if(was_on_side == AIRLOCK_SIDE_INTERIOR)
		. += new /datum/airlock_phase/repressurize/from_handler_supply
		. += new /datum/airlock_phase/doors/lock_open/interior
	else
		. += new /datum/airlock_phase/repressurize/require_external_air
		. += new /datum/airlock_phase/doors/lock_open/exterior
