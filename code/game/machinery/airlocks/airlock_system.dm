//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds the UI & handling, despite the controller physically holding state.
 * * Borrowed by panels to allow UI access
 */
/datum/airlock_system
	//* Composition *//
	/// our airlock controller
	var/obj/machinery/airlock_component/controller
	/// our airlock program
	var/datum/airlock_program/program

	//* Configuration *//
	/// security lockdown mode - all buttons and docking requests are ignored
	/// panels can still be used to control it.
	var/config_security_lockdown = FALSE

	//* Cycling *//
	/// current airlock cycle struct
	/// * if this exists, we are cycling right now
	var/datum/airlock_cycling/cycling
	/// operation cycle; airlock cycling is async, operation cycles allow us to ensure
	/// that an operation is still the same operation something started.
	var/cycling_op_id
	/// next operation cycle
	var/static/cycling_op_id_next = 0
	/// what to call on finish with (src, cycling_id: id, status: AIRLOCK_CYCLE_FIN_* define, why: short string reason or null)
	var/datum/callback/cycling_op_on_finish

	//* State *//
	/// arbitrary blackboard
	/// * unlike cycle blackboard, this always persists
	var/list/blackboard = list()

/datum/airlock_system/New(obj/machinery/airlock_component/controller, datum/airlock_program/program)
	src.controller = controller
	src.program = program

/datum/airlock_system/Destroy()
	abort_cycle()
	QDEL_NULL(controller)
	QDEL_NULL(program)
	return ..()

/datum/airlock_system/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/airlock_system/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()

/datum/airlock_system/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/airlock_system/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/**
 * @return null if failed, cycle id otherwise
 */
/datum/airlock_system/proc/start_cycle(datum/airlock_cycle/cycle, datum/callback/on_finished)
	if(src.cycle)
		return FALSE

/datum/airlock_system/proc/abort_cycle(cycling_id, why_str)

/datum/airlock_system/proc/fail_cycle(cycling_id, why_str)


#warn impl
