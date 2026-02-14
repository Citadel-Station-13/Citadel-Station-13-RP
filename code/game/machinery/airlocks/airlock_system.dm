//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds the UI & handling, despite the controller physically holding state.
 * * Borrowed by panels to allow UI access
 */
/datum/airlock_system
	//* Composition *//
	/// our airlock controller
	var/obj/machinery/airlock_component/controller/controller

	//* Cycling *//
	/// current airlock cycle struct
	/// * if this exists, we are cycling right now
	var/datum/airlock_cycling/cycling
	/// what to call on finish with (src, datum/airlock_cycling/cycling)
	var/datum/callback/cycling_on_finish

	//* State *//
	/// arbitrary blackboard
	/// * unlike cycle blackboard, this always persists, except across deconstruction/reconstruction of the controller.
	var/list/blackboard = list()

/datum/airlock_system/New(obj/machinery/airlock_component/controller)
	src.controller = controller

/datum/airlock_system/Destroy()
	abort_cycle()
	if(controller)
		if(controller.system == src)
			controller.system = null
		controller = null
	blackboard = list()
	return ..()

/datum/airlock_system/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("programAct")
			var/p_action = params["action"]
			var/p_params = params["params"]
			controller.program?.ui_program_act(src, actor, p_action, p_params)
			return TRUE

/datum/airlock_system/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["cycling"] = cycling ? cycling.ui_cycle_data() : null
	.["programTgui"] = controller.program?.tgui_airlock_component
	.["programData"] = controller.program?.ui_program_data(src)

/datum/airlock_system/process(delta_time)
	if(!cycling)
		STOP_PROCESSING(SSprocess_5fps, controller)
		STACK_TRACE("system was processing despite no cycling; killing")
		return PROCESS_KILL
	cycling.poll(delta_time)

/**
 * Begins an airlock cycle.
 * * `cycling`'s reference should belong to the system after being passed in.
 * @return null if failed, cycle id otherwise
 */
/datum/airlock_system/proc/start_cycle(datum/airlock_cycling/cycling, datum/callback/on_finished)
	if(src.cycling)
		return null
	src.cycling_on_finish = on_finished
	src.cycling = cycling

	cycling.setup(src)
	// immediately poll once
	cycling.poll(0)
	return cycling.op_id

#warn inform controller of start/stop so it can start/stop processing and update icon

/**
 * @return TRUE if cycling with given ID is stopped, FALSE otherwise
 */
/datum/airlock_system/proc/stop_cycle(cycling_id, status, why_str)
	controller.network?.reset_pumping_graphics()

	if(!cycling)
		return FALSE
	if(cycling_id && cycling_id != cycling.op_id)
		return FALSE
	cycling.finished_status = status
	cycling.finished_reason = why_str
	cycling_on_finish?.InvokeAsync(src, cycling)
	QDEL_NULL(cycling)
	return TRUE

/datum/airlock_system/proc/abort_cycle(cycling_id, why_str)
	return stop_cycle(cycling_id, AIRLOCK_CYCLE_FIN_ABORTED, why_str)

/datum/airlock_system/proc/fail_cycle(cycling_id, why_str)
	return stop_cycle(cycling_id, AIRLOCK_CYCLE_FIN_FAILED, why_str)

/datum/airlock_system/proc/finish_cycle(cycling_id, why_str)
	return stop_cycle(cycling_id, AIRLOCK_CYCLE_FIN_SUCCESS, why_str)
