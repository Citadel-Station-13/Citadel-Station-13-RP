//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/airlock_cycle/vacuum_cycle

/datum/airlock_cycle/vacuum_cycle/create_cycling(cycle_from_side, cycle_to_side)
	return ..()

/datum/airlock_cycle/vacuum_cycle/gather_phases(cycle_from_side, cycle_to_side)
	. = list()
	. += new /datum/airlock_phase/doors/seal
	switch(cycle_from_side)
		if(AIRLOCK_SIDE_INTERIOR)
			. += new /datum/airlock_phase/depressurize/drain_to_handler
		if(AIRLOCK_SIDE_EXTERIOR)
			. += new /datum/airlock_phase/depressurize/vent_to_outside
		else
			// be conservative, assume we want to conserve air
			. += new /datum/airlock_phase/depressurize/drain_to_handler

	var/datum/airlock_phase/merge_blackboard/side_change_marker = new
	side_change_marker.merge_system_blackboard = list(
		AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE = cycle_to_side,
	)
	. += side_change_marker

	switch(cycle_to_side)
		if(AIRLOCK_SIDE_EXTERIOR)
			. += new /datum/airlock_phase/repressurize/allow_external_air
			. += new /datum/airlock_phase/doors/unseal/exterior
		if(AIRLOCK_SIDE_INTERIOR)
			. += new /datum/airlock_phase/repressurize/from_handler_supply
			. += new /datum/airlock_phase/doors/unseal/interior
		else
			// be conservative, assume we want to use known-safe air
			. += new /datum/airlock_phase/repressurize/from_handler_supply
