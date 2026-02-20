//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Default airlock program. Can handle quite a lot, but not everything.
 */
/datum/airlock_program/vacuum_cycle
	tgui_airlock_component = "VacuumCycle"

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

/datum/airlock_program/vacuum_cycle/New()
	..()
	// Immediately reassert.
	reassert_doors_last = world.time - reassert_doors_every

/datum/airlock_program/vacuum_cycle/on_system_rebuild()
	..()
	// start inside
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = AIRLOCK_SIDE_INTERIOR
	// lock both sides closed
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE] = FALSE
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] = FALSE
	// just reassert door now
	reassert_doors()
	// pray it works instantly, which it should if the
	// doors spawn in with the right configurations
	system.cycling?.poll(1 SECONDS)

/datum/airlock_program/vacuum_cycle/ui_program_data()
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

/datum/airlock_program/vacuum_cycle/ui_program_act(datum/event_args/actor/actor, action, list/params)
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

/datum/airlock_program/vacuum_cycle/on_sensor_cycle_request(obj/machinery/airlock_peripheral/sensor/sensor, datum/event_args/actor/actor)
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
/datum/airlock_program/vacuum_cycle/proc/is_cancelling()
	return system.cycling?.blackboard[AIRLOCK_CYCLING_BLACKBOARD_IS_CANCEL_OP]

/datum/airlock_program/vacuum_cycle/proc/get_currently_cycled_side()
	return system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]

/datum/airlock_program/vacuum_cycle/proc/set_currently_cycled_side(side)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = side

/datum/airlock_program/vacuum_cycle/process(delta_time)
	..()
	if(reassert_doors_last < world.time - reassert_doors_every)
		if(system.cycling)
			// don't interrupt cycle
			return
		reassert_doors()

/datum/airlock_program/vacuum_cycle/proc/reassert_doors()
	reassert_doors_last = world.time
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/reassert_doors
	system.start_cycle(cycle.create_cycling(
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE],
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE],
	), CALLBACK(src, PROC_REF(on_reasserted_doors)))

/datum/airlock_program/vacuum_cycle/proc/on_reasserted_doors()
	set_active_side_based_on_doors()

/datum/airlock_program/vacuum_cycle/proc/set_active_side_based_on_doors()
	// note: these specifically check for 'bolted closed'.
	// open or unlocked counts as open.
	if(system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE] != FALSE)
		if(system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] != FALSE)
			// both open
			set_currently_cycled_side(AIRLOCK_SIDE_BOTH)
		else
			// interior open
			set_currently_cycled_side(AIRLOCK_SIDE_EXTERIOR)
	if(system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] != FALSE)
		// exterior open
		set_currently_cycled_side(AIRLOCK_SIDE_INTERIOR)
	else
		// neither is open
		set_currently_cycled_side(AIRLOCK_SIDE_NEITHER)

/datum/airlock_program/vacuum_cycle/proc/force_interior_doors(to_opened)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE] = to_opened
	reassert_doors()
	return TRUE

/datum/airlock_program/vacuum_cycle/proc/force_exterior_doors(to_opened)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE] = to_opened
	reassert_doors()
	return TRUE

/datum/airlock_program/vacuum_cycle/proc/start_cycling_towards(side)
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/vacuum_cycle
	system.start_cycle(cycle.create_cycling(
		system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE],
		side,
	))
	return TRUE

/datum/airlock_program/vacuum_cycle/proc/graceful_abort()
	system.stop_cycle()
	var/datum/airlock_cycle/cycle = new /datum/airlock_cycle/cancel_and_restore
	system.start_cycle(cycle.create_cycling(get_currently_cycled_side()))
	return TRUE

/datum/airlock_program/vacuum_cycle/proc/hard_abort()
	system.stop_cycle()
	return TRUE
