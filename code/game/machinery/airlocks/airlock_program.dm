//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A configurable airlock program.
 *
 * * For now, airlock programs don't have custom tick hooks. Please
 *   use airlock cycle / phase / tasks to build behavior in a composition-based
 *   manner. A tick hook system will be added if / when absolutely needed.
 */
/datum/airlock_program
	/// tgui routing string used to get the right component
	/// * the config interface is `[component]Config`.
	var/tgui_airlock_component

/datum/airlock_program/proc/ui_program_data(datum/airlock_system/system)
	return list()

/datum/airlock_program/proc/ui_program_push(datum/airlock_system/system, list/data)
	return // do nothing for now, we're currently polled by controller

/datum/airlock_program/proc/ui_program_act(datum/airlock_system/system, datum/event_args/actor/actor, action, list/params)
	return FALSE

/datum/airlock_program/proc/on_sensor_button_press(datum/airlock_system/system, datum/event_args/actor/actor, obj/machinery/airlock_peripheral/sensor/sensor)

#warn base tgui
