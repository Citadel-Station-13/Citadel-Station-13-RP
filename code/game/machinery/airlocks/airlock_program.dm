//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A configurable airlock program.
 * * This doubles as config; this cannot be dynamically changed on the airlock. You shouldn't
 *   have to change programs unless the airlock is so different it's another specialty.
 */
/datum/airlock_program
	/// tgui routing string used to get the right component
	/// * the config interface is `[component]Config`.
	var/tgui_airlock_component

/datum/airlock_program/proc/tick_cycle(datum/airlock_cycle/cycle, datum/airlock_gasnet/network)
	stack_trace("base tick_cycle hit.")
	cycle.complete()

/datum/airlock_program/proc/ui_program_data()
	return list()

/datum/airlock_program/proc/ui_program_push(list/data)
	return // do nothing for now, we're currently polled by controller

/datum/airlock_program/proc/ui_program_act(datum/airlock_gasnet/network, datum/event_args/actor/actor, action, list/params)
	return FALSE

#warn base tgui
