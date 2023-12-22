//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle controller
 *
 * Acts like a TGUI module.
 */
/datum/shuttle_controller
	//* Intrinsics
	/// our host shuttle
	var/datum/shuttle/shuttle

	//* Transit
	/// Shuttle is in transit
	var/in_transit = FALSE
	/// Current transit reservation
	var/datum/turf_reservation/in_transit_reservation
	/// Current transit dock
	var/obj/shuttle_dock/ephemeral/transit/in_transit_dock

	//* UI
	/// tgui module name
	var/tgui_module


/datum/shuttle_controller/proc/tgui_data()
	return list()

/datum/shuttle_controller/proc/tgui_static_data()
	return list(
		"$src" = REF(src),
		"$tgui" = tgui_module,
	)

/datum/shuttle_controller/proc/tgui_act(action, list/params, authorization)
	#warn impl

/datum/shuttle_controller/proc/tgui_push(list/data)
	#warn impl

//* Docking API - use this API always, do not manually control the shuttle.

/**
 * @params
 * * dock - dock to move to
 * * force - hard force, ram everything out of the way on the destination side if needed
 * * immediate - blow past all docking procedures, do not block on anything IC fluff or otherwise
 */
/datum/shuttle_controller/proc/move_to_dock(obj/shuttle_dock/dock, force = FALSE, immediate = FALSE)
	#warn impl

//* Transit

/**
 * @params
 * * force - hard force, ram everything out of the way on the destination side if needed
 * * immediate - blow past all docking procedures, do not block on anything IC fluff or otherwise
 */
/datum/shuttle_controller/proc/move_to_transit(force = FALSE, immediate = FALSE)
	#warn impl
