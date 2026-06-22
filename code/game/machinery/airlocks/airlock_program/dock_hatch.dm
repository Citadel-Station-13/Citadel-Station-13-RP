//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Docking hatch.
 * * Reacts to dock by opening, undocking by closing.
 */
/datum/airlock_program/dock_hatch
	#warn UI
	tgui_airlock_component = "DockHatch"

	/**
	 * Every this-much time, we will check if our doors are 'correct'.
	 * If not, the airlock is activated to shut the doors, if possible.
	 * This allows airlocks to be self-repairing to an extent.
	 */
	var/reassert_doors_every = 90 SECONDS
	/**
	 * Last time we reasserted doors.
	 */
	var/reassert_doors_last

	var/dock_should_modify_interior_doors = TRUE
	var/dock_should_modify_exterior_doors = TRUE

#warn impl all; add config for interior / exterior door auto modification on dock/undock

/datum/airlock_program/dock_hatch/New()
	..()
	// Immediately reassert.
	reassert_doors_last = world.time - reassert_doors_every

/datum/airlock_program/dock_hatch/on_system_rebuild()
	..()
	// start inside
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = AIRLOCK_SIDE_INTERIOR
	// lock both sides closed
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE] = FALSE
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] = FALSE
	// just reassert door now
	reassert_doors()

/datum/airlock_program/dock_hatch/ui_program_data()
	. = ..()
	.["interiorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE]
	.["exteriorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE]
	.["side"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]
	if(system.cycling)
		var/datum/airlock_cycling/cycling = system.cycling
		.["cycling"] = list(
			"fromSide" = cycling.blackboard[AIRLOCK_CYCLING_BLACKBOARD_FROM_SIDE],
			"toSide" = cycling.blackboard[AIRLOCK_CYCLING_BLACKBOARD_TO_SIDE],
		)
	else
		.["cycling"] = null
	.["canceling"] = system.cycling?.blackboard[AIRLOCK_CYCLING_BLACKBOARD_IS_CANCEL_OP]
	var/datum/gas_mixture/interior_air = system.controller?.network?.cycler?.get_immutable_gas_mixture_ref()
	.["pressure"] = interior_air ? XGM_PRESSURE(interior_air) : null

/datum/airlock_program/dock_hatch/ui_program_act(datum/event_args/actor/actor, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("cycleToExterior")
			if(system.cycling)
				return TRUE
			start_cycling_towards(AIRLOCK_SIDE_EXTERIOR)
			return TRUE
		if("cycleToInterior")
			if(system.cycling)
				return TRUE
			start_cycling_towards(AIRLOCK_SIDE_INTERIOR)
			return TRUE
		if("forceExteriorDoors")
			force_exterior_doors(!system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE])
			return TRUE
		if("forceInteriorDoors")
			force_interior_doors(!system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE])
			return TRUE
		if("cancel")
			if(is_cancelling())
				return TRUE
			graceful_abort()
			return TRUE
		if("abort")
			hard_abort()
			return TRUE

/datum/airlock_program/dock_hatch/on_sensor_cycle_request(obj/machinery/airlock_peripheral/sensor/sensor, datum/event_args/actor/actor)
	// technically this still blocks on reassert doors but that shouldn't
	// take too long if the airlock is operational anyways...
	if(system.cycling)
		return
	if(sensor.sidedness == AIRLOCK_SIDE_INTERIOR)
		start_cycling_towards(AIRLOCK_SIDE_INTERIOR)
	else if(sensor.sidedness == AIRLOCK_SIDE_EXTERIOR)
		start_cycling_towards(AIRLOCK_SIDE_EXTERIOR)

/**
 * @return truthy, or falsy value
 */
/datum/airlock_program/dock_hatch/proc/is_cancelling()
	return system.cycling?.blackboard[AIRLOCK_CYCLING_BLACKBOARD_IS_CANCEL_OP]

/datum/airlock_program/dock_hatch/proc/get_currently_cycled_side()
	return system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]

/datum/airlock_program/dock_hatch/proc/set_currently_cycled_side(side)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = side

/datum/airlock_program/dock_hatch/process(delta_time)
	..()
	if(reassert_doors_last < world.time - reassert_doors_every)
		if(system.cycling)
			// don't interrupt cycle
			return
		reassert_doors()

/datum/airlock_program/dock_hatch/proc/reassert_doors()
	reassert_doors_last = world.time
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/reassert_doors
	system.start_cycle(cycle.create_cycling(
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE],
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE],
	), CALLBACK(src, PROC_REF(on_reasserted_doors)))

/datum/airlock_program/dock_hatch/proc/on_reasserted_doors()
	set_active_side_based_on_doors()

/datum/airlock_program/dock_hatch/proc/set_active_side_based_on_doors()
	var/result_side = AIRLOCK_SIDE_NEITHER
	var/interior_state = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE]
	var/exterior_state = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE]
	switch(interior_state)
		if(TRUE)
			// inside bolted open
			switch(exterior_state)
				if(TRUE)
					// exterior bolted open
					result_side = AIRLOCK_SIDE_BOTH
				if(FALSE)
					// exterior bolted closed
					result_side = AIRLOCK_SIDE_INTERIOR
				if(null)
					// exterior not bolted
					result_side = AIRLOCK_SIDE_BOTH
		if(FALSE)
			// inside bolted closed
			switch(exterior_state)
				if(TRUE)
					// exterior bolted open
					result_side = AIRLOCK_SIDE_EXTERIOR
				if(FALSE)
					// exterior bolted closed - keep current side
					result_side = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]
				if(null)
					// exterior not bolted
					result_side = AIRLOCK_SIDE_EXTERIOR
		if(null)
			// inside not bolted
			switch(exterior_state)
				if(TRUE)
					// exterior bolted open
					result_side = AIRLOCK_SIDE_BOTH
				if(FALSE)
					// exterior bolted closed
					result_side = AIRLOCK_SIDE_INTERIOR
				if(null)
					// exterior not bolted
					result_side = AIRLOCK_SIDE_BOTH
	set_currently_cycled_side(result_side)

/datum/airlock_program/dock_hatch/proc/force_interior_doors(to_opened)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE] = to_opened
	reassert_doors()
	return TRUE

/datum/airlock_program/dock_hatch/proc/force_exterior_doors(to_opened)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] = to_opened
	reassert_doors()
	return TRUE

/datum/airlock_program/dock_hatch/proc/start_cycling_towards(side)
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/dock_hatch
	system.start_cycle(cycle.create_cycling(
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE],
		side,
		0,
	))
	return TRUE

/datum/airlock_program/dock_hatch/proc/graceful_abort()
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/cancel_and_restore
	system.start_cycle(cycle.create_cycling(
		get_currently_cycled_side(),
		0,
	))
	return TRUE

/datum/airlock_program/dock_hatch/proc/hard_abort()
	system.stop_cycle()
	return TRUE
