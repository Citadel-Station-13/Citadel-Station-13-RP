//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * holds the behavior of a module's embedding into an UI
 */
/datum/tgui_module_function
	/// tgui interface
	var/tgui_interface

// todo: this file is unticked and is basically a placeholder for modules v3
// tl;dr
// instead of the overhead of modules-per-datum
// why not singleton datum with context datums made and destroyde when uis are opened/closed?

/datum/tgui_module_function/proc/static_data(datum/tgui_module_context/context)
	return list(
		"$tgui" = tgui_interface,
		"$context" = context.tgui_context(),
	)

/datum/tgui_module_function/proc/data(datum/tgui_module_context/context)
	return list()

/**
 * remember to stop propagation if ..() is truthy.
 *
 * @return TRUE if handled
 */
/datum/tgui_module_function/proc/act(datum/tgui_module_context/context, action, list/params)
	return FALSE
