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

	//* Docking
	/// stored docking codes
	var/list/docking_codes

	//* UI
	/// shuttle ui route
	var/tgui_route

/datum/shuttle_controller/proc/initialize(datum/shuttle/shuttle)
	src.shuttle = shuttle
	return TRUE

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
	// this is just a wrapper so we can change it later if need be
	return push_ui_data(data = data)

//* Docking API - use this API always, do not manually control the shuttle.

/**
 * @params
 * * dock - dock to move to
 * * force - hard force, ram everything out of the way on the destination side if needed
 * * immediate - blow past all docking procedures, do not block on anything IC fluff or otherwise
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle_controller/proc/move_to_dock(obj/shuttle_dock/dock, force = FALSE, immediate = FALSE)
	#warn impl

/datum/shuttle_controller/proc/has_codes_for(obj/shuttle_dock/dock)
	#warn impl
