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
	/// minimum allowable pressure during cycling
	/// this overrides requested pressure by the environment!
	/// if you set it to a high value, people will go flying.
	var/config_minimum_tolerable_pressure = 0
	/// interior toggles
	///
	/// by default we want to regulate temperature/pressure/gas
	var/config_interior_toggles = AIRLOCK_CONFIG_EXPEL_UNWANTED_GAS | AIRLOCK_CONFIG_REGULATE_PRESSURE | AIRLOCK_CONFIG_REGULATE_TEMPERATURE
	/// exterior toggles
	///
	/// by default we just want to not have people go flying
	var/config_exterior_toggles = AIRLOCK_CONFIG_REGULATE_PRESSURE

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
	var/list/obj/machinery/airlock_peripheral/handler/handlers
	/// cyclers
	var/list/obj/machinery/airlock_peripheral/cycler/cyclers
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
	/// dock state
	var/dock_state = AIRLOCK_DOCK_NONE
	/// mode state
	var/mode_state
	/// operation state
	var/op_state
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

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 */
/obj/machinery/airlock_controller/autodetect

#warn impl

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Links to an /obj/shuttle_dock if one is detected.
 * * Defaults to being indestructible, as there's no in-game way to interact with a dock right now.
 */
/obj/machinery/airlock_controller/autodetect/docking
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

#warn impl
