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

	var/list/datum/shuttle/registered_shuttles
	var/list/obj/shuttle_aligner/port/registered_ports
	var/list/obj/shuttle_dock/registered_docks
	/// we're currently with these active blockers
	var/list/datum/shuttle_operation_blocker/blocking

/datum/shuttle_hook/Destroy()
	for(var/datum/shuttle/shuttle in registered_shuttles)
		shuttle.unregister_hook(src)
	release_all()
	return ..()

/**
 * Called on all event propagations.
 * * This may receive the same event multiple times if it propagates through multiple registrations.
 */
/datum/shuttle_hook/proc/on_event(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Called on an event that propagates through a dock.
 */
/datum/shuttle_hook/proc/on_dock_event(datum/event_args/shuttle/event, obj/shuttle_dock/dock)
	SHOULD_NOT_SLEEP(TRUE)
	on_event(event)

/**
 * Called on an event that propagates through a port.
 */
/datum/shuttle_hook/proc/on_port_event(datum/event_args/shuttle/event, obj/shuttle_aligner/port/port)
	SHOULD_NOT_SLEEP(TRUE)
	on_event(event)

/**
 * Called on an event that propagates through a shuttle datum itself.
 */
/datum/shuttle_hook/proc/on_shuttle_event(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)
	on_event(event)

/datum/shuttle_hook/proc/release_all()
	QDEL_LIST(blocking)
	return TRUE

/datum/shuttle_hook/proc/is_blocking_anything()
	return !isnull(blocking)
