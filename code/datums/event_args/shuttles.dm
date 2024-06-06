//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle events
 *
 * * Events can either be blockable or unblockable
 * * Blockable events can be interrupted
 * * Unblockable events cannot
 * * Failing an event is to entirely forbid the movement. Permanently block it instead if you want to make them have to force it.
 */
#warn update above
/datum/event_args/shuttle
	/// shuttle ref
	var/datum/shuttle/shuttle
	/// controller ref
	var/datum/shuttle_controller/controller

	/// this is a blockable event
	var/blockable = FALSE
	/// things we're still waiting on, associated to list of UI data for why
	var/list/datum/shuttle_hook/waiting_on_hooks
	/// is there a hook that's considered dangerous to force?
	var/forcing_could_be_dangerous = FALSE

	/// Are we forcefully attempting to proceed?
	var/forcing = FALSE
	/// Are we recovering from a bad dock operation?
	var/recovering = FALSE
	/// did we succeed?
	var/succeeded = FALSE
	/// are we done?
	var/finished = FALSE

/datum/event_args/shuttle/Destroy()
	if(!finished)
		finish(FALSE)
	shuttle = null
	controller = null
	return ..()

/datum/event_args/shuttle/proc/finish(success)
	succeeded = success
	finished = TRUE
	#warn make hooks gtfo

/datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
	. = FALSE
	if(!blockable)
		CRASH("attempted to block an unblockable event")
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
 * Shuttle docking event
 *
 * ## Order of Operations
 *
 * Docking
 * * Docking fired
 * * On success, post-docking is fired
 * * On failure, post-undocking is fired with recovery
 *
 * Undocking
 * * Undocking fired
 * * On success, post-undocking is fired
 * * On failure, post-docking is fired with recovery
 *
 * Takeoff
 * * Takeoff fired
 * * On success, post-takeoff is fired
 * * On failure, post-landing is fired on the dock the shuttle was taking off from with recovery.
 * * On failure, post-takeoff is fired on the dock the shuttle was landing on with recovery.
 *
 * Landing
 * * Landing fired
 * * On success, post-landing is fired
 * * On failure, post-takeoff is fired on the dock the shuttle was landing onwith recovery.
 * * On failure, post-landing is fired on the dock the shuttle was taking off from with recovery.
 */
#warn how to deal with takeoff/landing?
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
 * Shuttle translation
 *
 * ## Order of Operations
 *
 * * pre_move called before aligned_translation()
 * * post_move called after aligned_translation()
 *
 * ## Notes
 *
 * * only called on shuttle side hooks
 * * cannot be blocked
 */
/datum/event_args/shuttle/translation
	blockable = FALSE
	/// shuttle port being used, if any
	var/obj/shuttle_port/from_shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/from_dock
	/// shuttle port being used, if any
	var/obj/shuttle_port/to_shuttle_port
	/// the dock in question, if any
	var/obj/shuttle_dock/to_dock

/datum/event_args/shuttle/translation/pre_move

/datum/event_args/shuttle/translation/post_move
