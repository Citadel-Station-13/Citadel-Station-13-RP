//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle controller
 *
 * Acts like a TGUI module.
 */
/datum/shuttle_controller
	/// our host shuttle
	var/datum/shuttle/shuttle
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
