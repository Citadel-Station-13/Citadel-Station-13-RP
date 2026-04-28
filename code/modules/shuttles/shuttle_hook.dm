//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * hooks fired off when shuttles takeoff/landing
 *
 * Remember: **If you block an operation, you must unblock it later!**
 *
 * * this is used for both shuttle docks and shuttles themselves.
 */
/datum/shuttle_hook
	/// Player-facing name for what we are (what they're waiting on)
	var/name = "Unknown Protocols (bug!)"
	/// are we obfuscated (they get told something's blocking them, but not what)
	var/obfuscated = FALSE

	/// we're currently with these active blockers
	var/list/datum/shuttle_operation_blocker/blocking

/datum/shuttle_hook/Destroy()
	release_all()
	return ..()

/datum/shuttle_hook/proc/on_event(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)

/datum/shuttle_hook/proc/release_all()
	QDEL_LIST(blocking)
	return TRUE

/datum/shuttle_hook/proc/is_blocking_anything()
	return !isnull(blocking)
