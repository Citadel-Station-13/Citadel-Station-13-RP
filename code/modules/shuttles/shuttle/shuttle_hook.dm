//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * hooks fired off when shuttles takeoff/landing
 *
 * Remember: **If you block an operation, you must unblock it later!**
 */
/datum/shuttle_hook
	/// Player-facing name for what we are (what they're waiting on)
	var/name = "Unknown Protocols (report this to a coder!)"
	/// are we obfuscated (they get told something's blocking them, but not what)
	var/obfuscated = FALSE

	/// we're currently blocking this operation
	/// this is safe to reference like this because shuttles / docks never are in more than one dock / hosting more than one shuttle
	/// at the same time.
	var/datum/event_args/shuttle/blocking

/datum/shuttle_hook/proc/landing(datum/event_args/shuttle/movement/landing)
	return

/datum/shuttle_hook/proc/takeoff(datum/event_args/shuttle/movement/takeoff)
	return

/datum/shuttle_hook/proc/docking(datum/event_args/shuttle/dock/docking)
	return

/datum/shuttle_hook/proc/undocking(datum/event_args/shuttle/dock/undocking)
	return
