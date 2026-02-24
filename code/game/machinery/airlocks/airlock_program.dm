//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A configurable airlock program.
 *
 * * For now, airlock programs don't have custom tick hooks. Please
 *   use airlock cycle / phase / tasks to build behavior in a composition-based
 *   manner. A tick hook system will be added if / when absolutely needed.
 */
/datum/airlock_program
	/// owning system
	var/datum/airlock_system/system
	/// tgui routing string used to get the right component
	var/tgui_airlock_component

/datum/airlock_program/New(datum/airlock_system/system)
	src.system = system

/datum/airlock_program/Destroy()
	if(system)
		if(system.program == src)
			system.program = null
		system = null
	return ..()

/**
 * Called whenever the controller decides that the airlock should be rebuilt.
 */
/datum/airlock_program/proc/on_system_rebuild()
	return

/datum/airlock_program/proc/ui_program_data()
	return list()

/datum/airlock_program/proc/ui_program_push(list/data)
	return // no way to do this yet, needs to have program under nested-data

/datum/airlock_program/proc/ui_program_act(datum/event_args/actor/actor, action, list/params)
	return FALSE

/datum/airlock_program/proc/on_sensor_cycle_request(obj/machinery/airlock_peripheral/sensor/sensor, datum/event_args/actor/actor)
	return
