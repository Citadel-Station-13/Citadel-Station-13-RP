//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Airlock controllers
 *
 * * Uses a state-reconcile pattern where we attempt to change the chamber to match the wanted state.
 */
/obj/machinery/airlock_controller
	name = "airlock controller"
	desc = "A self-contained controller for an airlock."
	#warn sprite

	//* Access
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Configuration
	/// mode
	/// see defines for AIRLOCK_CONFIG_MODE_*.
	var/config_cycle_mode = AIRLOCK_CONFIG_MODE_FULL_REPLACE
	/// minimum allowable pressure during cycling
	/// this overrides requested pressure by the environment!
	/// if you set it to a high value, people will go flying.
	/// * only taken into account in dynamic cycle mode
	var/config_dynamic_minimum_tolerable_pressure
	/// interior toggles
	/// * by default we want to regulate temperature/pressure/gas
	/// * only taken into account in dynamic cycle mode
	var/config_dynamic_interior_toggles = AIRLOCK_CONFIG_EXPEL_UNWANTED_GAS | AIRLOCK_CONFIG_REGULATE_PRESSURE | AIRLOCK_CONFIG_REGULATE_TEMPERATURE
	/// exterior toggles
	/// * by default we just want to not have people go flying
	/// * only taken into account in dynamic cycle mode
	var/config_dynamic_exterior_toggles = AIRLOCK_CONFIG_REGULATE_PRESSURE

	//* Environments
	/// interior environment settings
	var/datum/airlock_environment/interior_environment
	/// exterior environment settings
	var/datum/airlock_environment/exterior_environment
	/// interior environment mode
	var/interior_environment_mode = AIRLOCK_ENVIRONMENT_AUTODETECT
	/// exterior environment mode
	var/exterior_environment_mode = AIRLOCK_ENVIRONMENT_ADAPTIVE

	//* Peripherals
	/// panels
	var/list/obj/machinery/airlock_peripheral/panel/panels
	/// handlers
	var/list/obj/machinery/airlock_peripheral/gasnet/handler/handlers
	/// cyclers
	var/list/obj/machinery/airlock_peripheral/gasnet/cycler/cyclers
	/// sensors
	var/list/obj/machinery/airlock_peripheral/sensor/sensors

	//* Doors
	/// interior doors
	var/list/obj/machinery/door/interior
	/// exterior doors
	var/list/obj/machinery/door/exterior

	//* Shuttles
	/// linked dock, if any
	var/obj/shuttle_dock/dock

	//* State
	/// interior door state
	var/interior_state = AIRLOCK_STATE_UNLOCKED
	/// exterior door state
	var/exterior_state = AIRLOCK_STATE_UNLOCKED

	/// cycle state
	var/cycle_state = AIRLOCK_CYCLE_INACTIVE
	/// last state we were cycling towards; this allows for resumes
	/// null for none
	var/cycle_side
	/// pressure on last cycle process
	var/last_cycle_pressure
	/// temperature on last cycle process
	var/last_cycle_temperature
	/// gas contents on last cycle pressure
	var/list/last_cycle_gases

	#warn below
	/// dock state
	var/dock_state = AIRLOCK_DOCK_NONE
	/// docking overridden
	var/dock_override = FALSE

	/// security lockdown mode - all buttons and docking requests are ignored
	/// panels can still be used to control it.
	var/security_lockdown = FALSE
	#warn above

	/// operation cycle; used for things like asyncs to be able to verify behavior.
	var/op_cycle
	/// next operation cycle
	var/static/op_cycle_next = 0
	/// what to call on success
	var/datum/callback/op_on_success
	/// what to call on failure or abort
	var/datum/callback/op_on_failure

/obj/machinery/airlock_controller/Initialize(mapload)
	..()
	#warn stuff
	// todo: we need proper tick bracket machine support & fastmos
	STOP_MACHINE_PROCESSING(src)
	START_PROCESSING(SSfastprocess, src)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_controller/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/machinery/airlock_controller/LateInitialize()
	. = ..()
	switch(interior_environment_mode)
		if(AIRLOCK_ENVIRONMENT_MANUAL)
		if(AIRLOCK_ENVIRONMENT_ADAPTIVE)
		if(AIRLOCK_ENVIRONMENT_IGNORE)
		if(AIRLOCK_ENVIRONMENT_AUTODETECT)
	switch(exterior_environment_mode)
		if(AIRLOCK_ENVIRONMENT_MANUAL)
		if(AIRLOCK_ENVIRONMENT_ADAPTIVE)
		if(AIRLOCK_ENVIRONMENT_IGNORE)
		if(AIRLOCK_ENVIRONMENT_AUTODETECT)
	#warn stuff

#warn impl

/obj/machinery/airlock_controller/proc/set_interior_state(state)
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

/obj/machinery/airlock_controller/proc/set_exterior_state(state)
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

/obj/machinery/airlock_controller/proc/handle_cycle()
	var/datum/gas_mixture/effective_indoors = probe_indoors_gas()
	var/datum/gas_mixture/effective_outdoors = probe_outdoors_gas()

	switch(config_cycle_mode)
		if(AIRLOCK_CONFIG_MODE_CLASSIC)
			switch(cycle_state)
				if(AIRLOCK_CYCLE_CLASSIC_DRAIN)
				if(AIRLOCK_CYCLE_CLASSIC_REPLACE)
		if(AIRLOCK_CONFIG_MODE_DYNAMIC_EQUALIZATION)
			switch(cycle_state)
				if(AIRLOCK_CYCLE_DYNAMIC_EQUALIZATION)
	if(!.)
		fail_cycle("unknown failure detected; resetting")
	else
		last_cycle_pressure = effective_indoors.return_pressure()
		last_cycle_temperature = effective_indoors.temperature
		last_cycle_gases = effective_indoors.gas.Copy()

/**
 * @params
 * * why - string reason
 */
/obj/machinery/airlock_controller/proc/fail_cycle(why)

/obj/machinery/airlock_controller/proc/finish_cycle(success)
	last_cycle_pressure = last_cycle_temperature = last_cycle_gases = null

#warn impl all

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Defaults to being indestructible, as there's no in-game way to build new airlocks right now.
 */
/obj/machinery/airlock_controller/autodetect

#warn impl - set indestructible on everything

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Links to an /obj/shuttle_dock if one is detected on sitting next to its border.
 * * Defaults to being indestructible, as there's no in-game way to interact with a dock right now.
 */
/obj/machinery/airlock_controller/autodetect/docking
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

#warn impl
