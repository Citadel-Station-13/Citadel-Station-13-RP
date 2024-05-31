//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle event
 *
 * ## Order of Operations
 *
 * Docking
 * * Docking fired
 * * On success, post-docking is fired (non-blocking)
 *
 * If docking fails
 * * Undocking fired (should always succeed)
 * * Post-undocking fired (non-blocking)
 *
 * Undocking
 * * Undocking fired (should always succeed)
 * * Post-undocking fired (non-blocking)
 *
 * Movement
 * * Takeoff fired
 * * On success, post-takeoff is fired (non-blocking)
 * * Landing is fired
 * * On success, post-landing is fired (non-blocking)
 *
 * If takeoff or landing fails
 * * Landing fired on the dock the shuttle just attempted to leave (should always succeed)
 * * Post-landing fired on the dock the shuttle just attempted to leave (non-blocking)
 */
#warn update above
/datum/event_args/shuttle
	/// shuttle ref
	var/datum/shuttle/shuttle

	/// this is a blockable event
	var/blockable = FALSE
	/// things we're still waiting on, associated to list of UI data for why
	var/list/datum/shuttle_hook/waiting_on_hooks
	/// is there a hook that's considered dangerous to force?
	var/forcing_could_be_dangerous = FALSE

	/// Are we forcefully attempting to proceed?
	var/forcing = FALSE
	/// Are we forcefully attempting to proceed? Level 2, for dangerous operations (like ramming hanger doors)
	var/dangerously_forcing = FALSE
	/// Are we recovering from a bad dock operation?
	var/recovering = FALSE
	/// did we succeed?
	var/succeeded = FALSE
	/// are we done?
	var/finished = FALSE

/datum/event_args/shuttle/Destroy()
	if(!finished)
		finish(FALSE)
	return ..()

/datum/event_args/shuttle/proc/finish(success)
	succeeded = success
	finished = TRUE
	#warn make hooks gtfo

/datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
	if(!blockable)
		return FALSE
	ASSERT(isnull(hook.blocking))
	hook.blocking = src
	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)

	if(dangerous)
		forcing_could_be_dangerous = TRUE
	return TRUE

/datum/event_args/shuttle/proc/release(datum/shuttle_hook/hook)
	waiting_on_hooks -= hook
	hook.blocking = null

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
	/// shuttle port being used, if any
	var/obj/shuttle_port/shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/dock

/**
 * * only fired on aligned docks/undocks
 */
/datum/event_args/shuttle/dock/docking
	blockable = TRUE

/**
 * * only fired on aligned docks/undocks
 */
/datum/event_args/shuttle/dock/undocking
	blockable = TRUE

/**
 * * only fired on aligned docks/undocks
 */
/datum/event_args/shuttle/dock/docked

/**
 * * only fired on aligned docks/undocks
 */
/datum/event_args/shuttle/dock/undocked

/datum/event_args/shuttle/dock/departing
	blockable = TRUE

/datum/event_args/shuttle/dock/departed

/datum/event_args/shuttle/dock/arriving
	blockable = TRUE

/datum/event_args/shuttle/dock/arrived

/**
 * holds data on shuttle grid moves
 *
 * ## State Mitigation
 *
 * * To proceed with movement, everything has to succeed, or a 'force' command has to go through successfully, for both sides.
 * * If either side fails, a landing event will be emitted for the port that we just tried to depart from under recovery mode.
 *
 * You should never block a recovery operation.
 */
#warn udpate above
/datum/event_args/shuttle/translation
	/// shuttle port being used, if any
	var/obj/shuttle_port/from_shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/from_dock
	/// shuttle port being used, if any
	var/obj/shuttle_port/to_shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/to_dock

/datum/event_args/shuttle/translation/translating
	blockable = TRUE

/datum/event_args/shuttle/translation/translated

/**
 * uhh
 */
#warn udpate above
/datum/event_args/shuttle/
