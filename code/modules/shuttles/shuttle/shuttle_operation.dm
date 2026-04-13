//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * stateful operations for shuttle controllers
 */
/datum/shuttle_operation
	/// the controller we're executing on
	var/datum/shuttle_controller/controller
	/// blockers currently active, if any
	var/list/datum/shuttle_operation_blocker/active_blockers = list()

	/// is forcing
	var/forcing = FALSE
	/// is dangerously forcing, if forcing
	var/dangerously_forcing = FALSE

	/// callbacks to be called with (src, status)
	/// * these will not be called if we are deleted.
	var/list/datum/callback/on_finish
	/// current status
	var/status = SHUTTLE_OPERATION_STATUS_RUNNING

/datum/shuttle_operation/New(datum/shuttle_controller/controller)
	src.controller = controller

/datum/shuttle_operation/Destroy()
	QDEL_LIST(active_blockers)
	on_finished = null
	controller = null
	return ..()

/**
 * Register an on-finish callback.
 * @return FALSE if already finished.
 */
/datum/shuttle_operation/proc/register_finish_callback(datum/callback/on_finish)
	if(src.status != SHUTTLE_OPERATION_STATUS_RUNNING)
		return FALSE
	LAZYADD(src.on_finish, on_finish)

/datum/shuttle_operation/proc/get_status()
	return src.status

/datum/shuttle_operation/proc/finish(status)
	if(src.status != SHUTTLE_OPERATION_STATUS_RUNNING)
		return FALSE
	src.status = status
	for(var/datum/callback/on_finish as anything in src.on_finish)
		on_finish.InvokeAsync(src, status)
	return TRUE

/**
 * * This may delete ourselvse as if we finish the controller usually deletes us.
 */
/datum/shuttle_operation/proc/poll()
	#warn impl

/datum/shuttle_operation/proc/force()
	#warn impl

/datum/shuttle_operation/proc/dangerously_force()
	#warn impl
