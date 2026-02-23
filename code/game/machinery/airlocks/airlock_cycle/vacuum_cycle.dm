//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// TODO: need a better way of specifying what interior / exterior / neutral environment is.
/datum/airlock_cycle/vacuum_cycle
	initial_desc = "Cycling"

/datum/airlock_cycle/vacuum_cycle/create_cycling(cycle_from_side, cycle_to_side, assumed_external_pressure)
	var/datum/airlock_cycling/cycling = ..()
	switch(cycle_to_side)
		if(AIRLOCK_SIDE_EXTERIOR)
			cycling.desc = "Cycling to Exterior"
		if(AIRLOCK_SIDE_INTERIOR)
			cycling.desc = "Cycling to Interior"
		else
			cycling.desc = "Cycling to Interior (Locked)"
	return cycling

/datum/airlock_cycle/vacuum_cycle/gather_phases(cycle_from_side, cycle_to_side, assumed_external_pressure)
	. = list()
	. += new /datum/airlock_phase/doors/seal

	var/effective_result_side
	if(cycle_to_side != AIRLOCK_SIDE_INTERIOR || cycle_to_side != AIRLOCK_SIDE_EXTERIOR)
		// non-interior/exterior semantically means 'interior-locked'.
		effective_result_side = AIRLOCK_SIDE_INTERIOR
	else
		effective_result_side = cycle_to_side

	// only depressurize fully if we are changing sides
	if(cycle_from_side != cycle_to_side)
		var/depressurize_to_kpa = 0
		switch(cycle_from_side)
			if(AIRLOCK_SIDE_INTERIOR)
				. += new /datum/airlock_phase/depressurize/drain_to_handler(depressurize_to_kpa)
			if(AIRLOCK_SIDE_EXTERIOR)
				. += new /datum/airlock_phase/depressurize/vent_to_outside(depressurize_to_kpa)
			else
				// be conservative, assume we want to conserve air
				. += new /datum/airlock_phase/depressurize/drain_to_handler(depressurize_to_kpa)

	var/datum/airlock_phase/merge_blackboard/side_change_marker = new
	side_change_marker.merge_system_blackboard = list(
		AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE = effective_result_side,
	)
	. += side_change_marker

	switch(cycle_to_side)
		if(AIRLOCK_SIDE_EXTERIOR)
			. += new /datum/airlock_phase/repressurize/require_external_air(assumed_external_pressure)
			. += new /datum/airlock_phase/doors/lock_open/exterior
		if(AIRLOCK_SIDE_INTERIOR)
			. += new /datum/airlock_phase/repressurize/from_handler_supply
			. += new /datum/airlock_phase/doors/lock_open/interior
		else
			// be conservative, assume we want to use known-safe air
			. += new /datum/airlock_phase/repressurize/from_handler_supply
