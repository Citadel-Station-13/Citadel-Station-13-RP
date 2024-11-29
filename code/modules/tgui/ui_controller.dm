//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A UI controller that hooks to a datum.
 */
/datum/ui_controller
	/// The datum type that we bind to.
	var/expected_type = /datum
	/// TGUI interface path.
	///
	/// Accepted:
	/// * "Paper" for 'tgui/interfaces/Paper.tsx' or 'tgui/interfaces/Paper/index.tsx'.
	/// * "admin/modals/UploadMapSector" for 'tgui/interfaces/admin/modals/UploadMapSector.tsx' or 'tgui/interfaces/admin/modals/UploadMapSector/index.tsx'.
	var/interface_path

#warn impl

/**
 * Pulls initial data.
 */
/datum/ui_controller/proc/pull_static_data(datum/entity, datum/ui_context/context, datum/tgui/view)
	return list(
		"$interface" = interface_path,
	)

/**
 * Pulls tick-updated data.
 */
/datum/ui_controller/proc/pull_data(datum/entity, datum/ui_context/context, datum/tgui/view)
	return list()

/**
 * Called on an act() coming through from a TGUI that terminates on this controller.
 *
 * @params
 * * entity - The /datum. This may be type-casted to our expected type.
 * * context - The /datum/ui_context of the open UI window.
 * * view - The real /datum/tgui instance. This should generally not be accessed, and is here as an escape hatch
 *          for when access is really needed. An example of when this is needed is to send data only to that UI -
 *          which is also an example of something that is *rarely* needed.
 * * action - Action string passed to act().
 * * params - List of key-value's passed to act().
 *
 * @return TRUE if handled.
 */
/datum/ui_controller/proc/on_act(datum/entity, datum/ui_context/context, datum/tgui/view, action, list/params)
	return

/**
 * Called when a /datum's `notify_uis()` is called.
 *
 * @params
 * * entity - The /datum. This may be type-casted to our expected type.
 * * key - A string key.
 * * ... - A variable number of arguments that the datum passes into the signal.
 */
/datum/ui_controller/proc/on_notify(datum/entity, key, ...)
	return
