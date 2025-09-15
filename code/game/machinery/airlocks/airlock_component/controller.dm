//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/**
 * Airlock controllers
 *
 * * Uses a state-reconcile pattern where we attempt to change the chamber to match the wanted state.
 */
/obj/machinery/airlock_component/controller
	name = "airlock controller"
	desc = "A self-contained controller for an airlock."
	#warn sprite

	//* Access *//
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Configuration *//
	/// security lockdown mode - all buttons and docking requests are ignored
	/// panels can still be used to control it.
	var/config_security_lockdown = FALSE

	//* Network *//
	/// our connected gasnet
	var/datum/airlock_gasnet/network

	//* State *//
	/// currently cycled to side
	var/state_current_side = AIRLOCK_SIDE_NEUTRAL
	/// interior door state
	var/state_door_interior = AIRLOCK_STATE_UNLOCKED
	/// exterior door state
	var/state_door_exterior = AIRLOCK_STATE_UNLOCKED

	//* Cycling *//
	/// current airlock cycle struct
	/// * if this exists, we are cycling right now
	var/datum/airlock_cycle/cycle

	//* Cycling - Op *//
	/// operation cycle; airlock cycling is async, operation cycles allow us to ensure
	/// that an operation is still the same operation something started.
	var/op_cycle
	/// next operation cycle
	var/static/op_cycle_next = 0
	/// what to call on finish with (status: AIRLOCK_OP_STATUS_* define, why: short string reason or null)
	var/datum/callback/op_on_finish

/obj/machinery/airlock_component/controller/Initialize(mapload)
	..()
	#warn stuff
	// todo: we need proper tick bracket machine support & fastmos
	STOP_MACHINE_PROCESSING(src)
	START_PROCESSING(SSprocess_5fps, src)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_component/controller/Destroy()
	STOP_PROCESSING(SSprocess_5fps, src)
	finish_cycle(AIRLOCK_CYCLE_STATUS_ABORTED)
	return ..()

/obj/machinery/airlock_component/controller/LateInitialize()
	. = ..()

/obj/machinery/airlock_component/controller/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/machinery/airlock_component/controller/proc/set_interior_state(state)
	src.interior_state = state

	var/list/obj/machinery/door/interior = get_interior_doors()
	switch(state)
		if(AIRLOCK_STATE_LOCKED_OPEN)
			for(var/obj/machinery/door/door as anything in interior)
				door.airlock_set(TRUE, TRUE)
		if(AIRLOCK_STATE_LOCKED_CLOSED)
			for(var/obj/machinery/door/door as anything in interior)
				door.airlock_set(FALSE, TRUE)
		if(AIRLOCK_STATE_UNLOCKED)
			for(var/obj/machinery/door/door as anything in interior)
				door.airlock_set(null, FALSE)

/obj/machinery/airlock_component/controller/proc/set_exterior_state(state)
	src.exterior_state = state

	var/list/obj/machinery/door/exterior = get_exterior_doors()
	switch(state)
		if(AIRLOCK_STATE_LOCKED_OPEN)
			for(var/obj/machinery/door/door as anything in exterior)
				door.airlock_set(TRUE, TRUE)
		if(AIRLOCK_STATE_LOCKED_CLOSED)
			for(var/obj/machinery/door/door as anything in exterior)
				door.airlock_set(FALSE, TRUE)
		if(AIRLOCK_STATE_UNLOCKED)
			for(var/obj/machinery/door/door as anything in exterior)
				door.airlock_set(null, FALSE)

/obj/machinery/airlock_component/controller/proc/handle_cycle()
	var/datum/gas_mixture/effective_indoors = probe_indoors_gas()
	var/datum/gas_mixture/effective_outdoors = probe_outdoors_gas()

	#warn be sure to handle effective gases being null

	switch(config_cycle_mode)
		if(AIRLOCK_CONFIG_MODE_CLASSIC)
			switch(cycle_state)
				if(AIRLOCK_CYCLE_CLASSIC_DRAIN)
				if(AIRLOCK_CYCLE_CLASSIC_REPLACE)
		if(AIRLOCK_CONFIG_MODE_DYNAMIC)
			switch(cycle_state)
				if(AIRLOCK_CYCLE_DYNAMIC_EQUALIZATION)
	if(!.)
		fail_cycle("unknown failure detected; resetting")
	else
		last_cycle_pressure = effective_indoors.return_pressure()
		last_cycle_temperature = effective_indoors.temperature
		last_cycle_gases = effective_indoors.gas.Copy()

#warn impl all

/**
 * @params
 * * why - string reason
 */
/obj/machinery/airlock_component/controller/proc/fail_cycle(why)

/obj/machinery/airlock_component/controller/proc/finish_cycle(status)
	last_cycle_pressure = last_cycle_temperature = last_cycle_gases = null

/obj/machinery/airlock_component/controller/proc/probe_indoors_gas()
	return interior_sensor?.probe_gas()

/obj/machinery/airlock_component/controller/proc/probe_outdoors_gas()
	return exterior_sensor?.probe_gas()
