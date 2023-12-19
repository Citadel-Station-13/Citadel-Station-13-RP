//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle event
 */
/datum/event_args/shuttle
	/// shuttle ref
	var/datum/shuttle/shuttle
	/// shuttle port being used, if any
	var/obj/shuttle_anchor/port/shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/dock

	/// things we're still waiting on, associated to list of UI data for why
	var/list/datum/shuttle_hook/waiting_on_hooks
	/// is there a hook that's considered dangerous to hook?
	var/forcing_could_be_dangerous = FALSE

	/// Are we forcefully attempting to proceed?
	var/forcing = FALSE
	/// Are we forcefully attempting to proceed? Level 2, for dangerous operations (like ramming hanger doors)
	var/dangerously_forcing = FALSE
	/// Are we recovering from a bad dock operation?
	var/recovering = FALSE

/datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)
	
	if(dangerous)
		forcing_could_be_dangerous = TRUE

/datum/event_args/shuttle/proc/release(datum/shuttle_hook/hook)
	waiting_on_hooks -= hook

/datum/event_args/shuttle/proc/update(datum/shuttle_hook/hook, list/reason_or_reasons)
	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)

/**
 * holds data on shuttle docking or undocking operation
 * this is post / pre land / takeoff.
 *
 *
 * ## State Mitigation
 *
 * * To be considered docked, everything has to succeed, or a 'force' command has to go through successfully
 * * To be considered undocked, either everything has to succeed (without force), or a force command has to be sent through
 * * If a dock operation fails, an undock operation will be started under recovery mode.
 *
 * You should never block a forced undock operation.
 * You should never block a recovery operation.
 */
/datum/event_args/shuttle/dock

/datum/event_args/shuttle/dock/docking

/datum/event_args/shuttle/dock/undocking

/**
 * holds data on shuttle takeoff
 *
 * ## State Mitigation
 *
 * * To proceed with movement, everything has to succeed, or a 'force' command has to go through successfully, for both sides.
 * * If either side fails, a landing event will be emitted for the port that we just tried to depart from under recovery mode.
 *
 * You should never block a recovery operation.
 */
/datum/event_args/shuttle/movement

/datum/event_args/shuttle/movement/takeoff

/datum/event_args/shuttle/movement/landing
