//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * holds data on shuttle docking or undocking operation
 * this is post / pre land / takeoff.
 */
/datum/event_args/shuttle_dock
	/// shuttle ref
	var/datum/shuttle/shuttle
	/// the dock in question
	var/obj/shuttle_dock/dock

/datum/event_args/shuttle_dock/docking

/datum/event_args/shuttle_dock/undocking

/**
 * holds data on shuttle takeoff
 */
/datum/event_args/shuttle_movement

/datum/event_args/shuttle_movement/takeoff

/datum/event_args/shuttle_movement/landing



/**
 * holds data on a shuttle docking operation
 *
 * remember: all shuttle movements are a dock/undock
 *
 * * roundstart shuttle docks are movements from null dock to a dock
 * *
 */
/datum/event_args/shuttle_docking
    /// shuttle reference
    var/datum/shuttle/shuttle
    /// source dock, if any
    var/obj/shuttle_dock/source
    /// destination dock, if any
    var/obj/shuttle_dock/destination
