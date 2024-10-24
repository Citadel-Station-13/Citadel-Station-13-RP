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

	//* Environments *//
	/// interior environment settings
	///
	/// * Mappers: Set mode to MANUAL and set this to an atmosphere path to force it to something.
	/// * You cannot have this be a gas string! That support hasn't been coded yet.
	/// * This is used by airlock programs that care about it to determine nominal environment.
	var/datum/airlock_environment/interior_environment
	/// exterior environment settings
	///
	/// * Mappers: Set mode to MANUAL and set this to an atmosphere path to force it to something.
	/// * You cannot have this be a gas string! That support hasn't been coded yet.
	/// * This is used by airlock programs that care about it to determine nominal environment.
	var/datum/airlock_environment/exterior_environment
	/// interior environment mode
	var/interior_environment_mode = AIRLOCK_ENVIRONMENT_AUTODETECT
	/// exterior environment mode
	var/exterior_environment_mode = AIRLOCK_ENVIRONMENT_ADAPTIVE

	//* Network *//
	/// our connected gasnet
	var/datum/airlock_gasnet/network

	//* State *//
	/// interior door state
	var/interior_state = AIRLOCK_STATE_UNLOCKED
	/// exterior door state
	var/exterior_state = AIRLOCK_STATE_UNLOCKED

	//* Cycling *//
	/// which side are we cycled to?
	///
	/// * NEUTRAL if neither, or a cycle got aborted
	var/cycled_to_side = AIRLOCK_SIDE_NEUTRAL
	/// last side we were cycling towards; this allows for resumes
	var/cycling_last_side = AIRLOCK_SIDE_NEUTRAL
	/// current airlock cycle struct
	///
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
	return ..()

/obj/machinery/airlock_component/controller/LateInitialize()
	. = ..()
	switch(interior_environment_mode)
		if(AIRLOCK_ENVIRONMENT_MANUAL)
			interior_environment = new /datum/airlock_environment(interior_environment)
		if(AIRLOCK_ENVIRONMENT_ADAPTIVE)
			interior_environment = null
		if(AIRLOCK_ENVIRONMENT_IGNORE)
			interior_environment = null
		if(AIRLOCK_ENVIRONMENT_AUTODETECT)
			interior_environment = new /datum/airlock_environment(probe_indoors_gas())
	switch(exterior_environment_mode)
		if(AIRLOCK_ENVIRONMENT_MANUAL)
			exterior_environment = new /datum/airlock_environment(exterior_environment)
		if(AIRLOCK_ENVIRONMENT_ADAPTIVE)
			exterior_environment = null
		if(AIRLOCK_ENVIRONMENT_IGNORE)
			exterior_environment = null
		if(AIRLOCK_ENVIRONMENT_AUTODETECT)
			exterior_environment = new /datum/airlock_environment(probe_outdoors_gas())

/obj/machinery/airlock_component/controller/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/machinery/airlock_component/controller/proc/set_interior_state(state)
	src.interior_state = state

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

/obj/machinery/airlock_component/controller/proc/finish_cycle(success)
	last_cycle_pressure = last_cycle_temperature = last_cycle_gases = null

/obj/machinery/airlock_component/controller/proc/probe_indoors_gas()
	return interior_sensor?.probe_gas()

/obj/machinery/airlock_component/controller/proc/probe_outdoors_gas()
	return exterior_sensor?.probe_gas()

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Defaults to being indestructible, as there's no in-game way to build new airlocks right now.
 */
/obj/machinery/airlock_component/controller/autodetect

#warn impl - set indestructible on everything

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Links to an /obj/shuttle_dock if one is detected on sitting next to its border.
 * * Defaults to being indestructible, as there's no in-game way to interact with a dock right now.
 */
/obj/machinery/airlock_component/controller/autodetect/docking
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

#warn impl
