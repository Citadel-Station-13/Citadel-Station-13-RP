//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * holds the context of a module's embedding into an UI
 */
/datum/tgui_module_context
	/// thing being controlled
	var/datum/delegate
	/// person doing the controlling
	var/datum/event_args/actor/actor
	/// the host ui
	var/datum/tgui/ui

#warn /datum/tgui/proc/register_functional_module(datum/target = src)

/datum/tgui_module_context/New(datum/host, datum/delegate, datum/event_args/actor/actor, datum/tgui/ui)
	src.delegate = delegate
	src.host = host
	src.actor = actor
	src.ui = ui


/datum/tgui_module_context/proc/tgui_context()
	return list(
		"host" = ui.src_object,
	)

// todo: this file is unticked and is basically a placeholder for modules v3
// more in tgui_module_function.dm
