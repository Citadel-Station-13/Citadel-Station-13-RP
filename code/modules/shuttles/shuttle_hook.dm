//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * hooks fired off when shuttles takeoff/landing
 *
 * Remember: **If you block an operation, you must unblock it later!**
 *
 * * this is used for both shuttle docks and the shuttles
 */
/datum/shuttle_hook
	/// Player-facing name for what we are (what they're waiting on)
	var/name = "Unknown Protocols (bug!)"
	/// are we obfuscated (they get told something's blocking them, but not what)
	var/obfuscated = FALSE

	/// we're currently blocking these operations
	///
	/// this is the only place where a shuttle event may be referenced outside of the shuttle itself!
	///
	/// this is safe to reference like this because shuttles never are in more than one dock
	/// at the same time.
	var/list/datum/event_args/shuttle/blocking

/datum/shuttle_hook/Destroy()
	release_all()
	return ..()

/**
 * called when a translation event comes in
 *
 * * only fired shuttle-side, not dock-side
 * * cannot be blocked.
 */
/datum/shuttle_hook/proc/on_translation_event(datum/event_args/shuttle/translation/event)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called when a docking event comes in
 *
 * * fired shuttle-side and dock-side
 * * some events ('post-xyz') cannot be blocked.
 */
/datum/shuttle_hook/proc/on_dock_event(datum/event_args/shuttle/dock/event)
	SHOULD_NOT_SLEEP(TRUE)

/datum/shuttle_hook/proc/release_all()
	for(var/datum/event_args/shuttle/event as anything in blocking)
		release(event)
	ASSERT(!length(blocking))
	return TRUE

/datum/shuttle_hook/proc/release(datum/event_args/shuttle/event)
	event.release(src)
	return TRUE

/datum/shuttle_hook/proc/update_all(list/reason_or_reasons)
	for(var/datum/event_args/shuttle/event as anything in blocking)
		update(event, reason_or_reasons)
	return TRUE

/datum/shuttle_hook/proc/update(datum/event_args/shuttle/event, list/reason_or_reasons)
	event.update(src, reason_or_reasons)
	return TRUE

/datum/shuttle_hook/proc/block(datum/event_args/shuttle/event, list/reason_or_reasons, dangerous)
	return event.block(src, reason_or_reasons, dangerous)

/datum/shuttle_hook/proc/is_blocking_anything()
	return !isnull(blocking)

#warn forcing
