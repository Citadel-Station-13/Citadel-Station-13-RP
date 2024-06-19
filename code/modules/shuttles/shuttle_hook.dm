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
	var/name = "Unknown Protocols (report this to a coder!)"
	/// are we obfuscated (they get told something's blocking them, but not what)
	var/obfuscated = FALSE

	/// we're currently blocking this operation
	///
	/// this is the only place where a shuttle event may be referenced outside of the shuttle itself!
	///
	/// this is safe to reference like this because shuttles / docks never are in more than one dock / hosting more than one shuttle
	/// at the same time.
	///
	/// we also only need one reference for this because it's impossible for a shuttle to fire more than one event at the same time as another.
	var/datum/event_args/shuttle/blocking

#warn multi-blocks; for stuff like planetary hooks

/datum/shuttle_hook/Destroy()
	release()
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

/datum/shuttle_hook/proc/release()
	if(isnull(blocking))
		return FALSE
	blocking.release(src)
	return TRUE

/datum/shuttle_hook/proc/update(list/reason_or_reasons)
	if(isnull(blocking))
		return FALSE
	blocking.update(src, reason_or_reasons)
	return TRUE

/datum/shuttle_hook/proc/block(datum/event_args/shuttle/event, list/reason_or_reasons, dangerous)
	return event.block(src, reason_or_reasons, dangerous)

/datum/shuttle_hook/proc/is_blocking()
	return !isnull(blocking)
