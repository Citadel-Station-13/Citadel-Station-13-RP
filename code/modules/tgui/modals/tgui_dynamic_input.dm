//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Creates a TGUI input window and returns the user's response
 *
 * This is used to grab a set of responses to various datatypes.
 * This proc blocks until finished.
 *
 * @params
 * * user - who to send this to
 * * message - description in interface
 * * title - self explanatory
 * * query - structured list of input items (see TGUI_INPUT_DATA_* defines) as list(list(data...), ...)
 * * timeout - timeout before menu closes. if it times out, choices will be null.
 * * sanitize - perform sanitize in this proc instead of trusting caller to do it
 *
 * @return list of key-value pairs (TGUI_INPUT_DATA_KEY) associated to values
 */
/proc/tgui_dynamic_input(mob/user, message, title = "Input", list/query, timeout = 0, sanitize = FALSE)
	#warn impl

/**
 * Creates a TGUI input window and returns the user's response
 *
 * This is used to grab a set of responses to various datatypes.
 * This proc immediately returns.
 *
 * @params
 * * user - who to send this to
 * * message - description in interface
 * * title - self explanatory
 * * query - structured list of input items (see TGUI_INPUT_DATA_* defines) as list(list(data...), ...)
 * * callback - callback called with first arg being the picked list when we're done.
 * * sanitize - perform sanitize in this proc instead of trusting caller to do it
 */
/proc/tgui_dynamic_input_async(mob/user, message, title = "Input", list/query, sanitize = FALSE, datum/callback/callback)
	#warn impl

/datum/tgui_dynamic_input
	/// title of the windo
	var/title
	/// message that appears inside the window
	var/message
	/// structured query list
	var/list/query
	/// list of user's choices; null if they haven't picked yet
	var/list/choices
	/// when we were opened
	var/opened_time
	/// how long our timeout is; null for infinite
	var/timeout
	/// did user close us yet? also set to true if we're qdeleted
	var/closed
	/// callback to invoke on finish
	var/datum/callback/callback
	/// do we sanitize?
	var/sanitize

	#warn impl

/datum/tgui_dynamic_input/New(mob/user, message, title, list/query, timeout, sanitize, datum/callback/callback)
	#warn impl

/datum/tgui_dynamic_input/Destroy()
	query = null
	choices = null
	closed = TRUE
	return ..()

/datum/tgui_dynamic_input/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn impl

/datum/tgui_dynamic_input/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	#warn impl

/datum/tgui_dynamic_input/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("submit")
			#warn impl
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

/datum/tgui_dynamic_input/proc/block_on_finished()
	#warn impl

/datum/tgui_dynamic_input/proc/finish(list/choices)
	callback?.InvokeAsync(cohices)

/datum/tgui_dynamic_input/proc/sanitize(list/choices)
	#warn impl
