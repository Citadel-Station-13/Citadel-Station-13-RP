//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// TODO: generalize this to a tgui helper / whatever, this shouldn't just be for dynamic input modal.
//       this will be very useful for rigs & more.

/**
 * Helper datum used to build a query for tgui_dynamic_input
 * High overhead, technically not necessary, but, this is easy to use as an API.
 */
/datum/tgui_dynamic_query
	/// options list
	var/list/options = list()

/datum/tgui_dynamic_query/proc/string(key, name, desc, max_length = 512, multi_line = FALSE, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options[key] = list(
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_TEXT,
		"constraints" = list(max_length),
	)
	return src

/datum/tgui_dynamic_query/proc/number(key, name, desc, min_value = -INFINITY, max_value = INFINITY, round_to, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options[key] = list(
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_NUM,
		"constraints" = list(min_value, max_value, round_to),
	)
	return src

/datum/tgui_dynamic_query/proc/toggle(key, name, desc, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options[key] = list(
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_TOGGLE,
		"constraints" = list(),
	)
	return src

/datum/tgui_dynamic_query/proc/pick_one(key, name, desc, list/choices = list(), default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options[key] = list(
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_LIST_PICK,
		"constraints" = choices,
	)
	return src

/**
 * builds return list of results
 */
/datum/tgui_dynamic_query/proc/get_results(list/choices)
	. = list()
	var/got
	for(var/key in options)
		var/list/params = options[key]
		var/val = choices[key]
		switch(params[TGUI_INPUT_DATA_TYPE])
			if(TGUI_INPUT_DATATYPE_TEXT)
				got = isnull(val) ? params[TGUI_INPUT_DATA_DEFAULT] : val
				if(!isnull(got))
					if(length(got) > params[TGUI_INPUT_DATA_CONSTRAINTS][1])
						got = copytext_char(got, 1, params[TGUI_INPUT_DATA_CONSTRAINTS][1] + 1)
				.[key] = got
			if(TGUI_INPUT_DATATYPE_NUM)
				got = isnull(val) ? params[TGUI_INPUT_DATA_DEFAULT] : text2num(val)
				if(!isnull(got))
					got = clamp(got, params[TGUI_INPUT_DATA_CONSTRAINTS][1], params[TGUI_INPUT_DATA_CONSTRAINTS][2])
					if(!isnull(params[TGUI_INPUT_DATA_CONSTRAINTS][3]))
						got = round(got, params[TGUI_INPUT_DATA_CONSTRAINTS][3])
				.[key] = got
			if(TGUI_INPUT_DATATYPE_LIST_PICK)
				got = isnull(val) ? params[TGUI_INPUT_DATA_DEFAULT] : val
				if(!isnull(got))
					if(!(got in params[TGUI_INPUT_DATA_CONSTRAINTS]))
						if(length(params[TGUI_INPUT_DATA_CONSTRAINTS]))
							got = params[TGUI_INPUT_DATA_CONSTRAINTS][1]
						else
							got = null
				.[key] = got
			if(TGUI_INPUT_DATATYPE_TOGGLE)
				got = isnull(val) ? params[TGUI_INPUT_DATA_DEFAULT] : val
				if(!isnull(got))
					got = !!got
				.[key] = got

/**
 * returns list to be sent to UI
 */
/datum/tgui_dynamic_query/proc/get_query()
	return options

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
 * * query - built query
 * * timeout - timeout before menu closes. if it times out, choices will be null.
 *
 * @return list of key-value pairs (the TGUI_INPUT_DATA_KEY's you put in) associated to values
 */
/proc/tgui_dynamic_input(mob/user, message, title = "Input", datum/tgui_dynamic_query/query, timeout = 0)
	var/datum/tgui_dynamic_input/modal = new(user, message, title, query, timeout)
	modal.block_on_finished()
	return modal.query.get_results(modal.choices)

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
 * * query - built query
 * * timeout - timeout before menu closes. if it times out, choices will be null.
 * * callback - callback called with first arg being the picked list when we're done.
 *
 * @return the /datum/tgui_dynamic_input instance created. you should probably not touch this unless you know what you're doing.
 */
/proc/tgui_dynamic_input_async(mob/user, message, title = "Input", datum/tgui_dynamic_query/query, timeout = 0, datum/callback/callback)
	return new /datum/tgui_dynamic_input(user, message, title, query, timeout, callback)

/datum/tgui_dynamic_input
	/// title of the windo
	var/title
	/// message that appears inside the window
	var/message
	/// query datum
	var/datum/tgui_dynamic_query/query
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
	/// are we finished? set to true on close, here to prevent double close.
	var/finished = FALSE

/datum/tgui_dynamic_input/New(mob/user, message, title, datum/tgui_dynamic_query/query, timeout, datum/callback/callback)
	src.title = title
	src.message = message
	src.query = query
	src.timeout = timeout
	if(timeout)
		QDEL_IN(src, timeout)
	src.callback = callback
	ui_interact(user)

/datum/tgui_dynamic_input/Destroy()
	// 'choices' and 'query' intentionally kept
	if(!finished)
		finish(null)
	closed = TRUE
	return ..()

/datum/tgui_dynamic_input/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["query"] = query.get_query()
	.["title"] = title
	.["message"] = message
	.["timeout"] = timeout

/datum/tgui_dynamic_input/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "UIDynamicInputModal")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tgui_dynamic_input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("submit")
			finish(params["choices"])
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			if(!finished)
				finish(null)
			return TRUE

/datum/tgui_dynamic_input/ui_state()
	return GLOB.always_state

/datum/tgui_dynamic_input/proc/block_on_finished()
	UNTIL(closed)
	return choices

/datum/tgui_dynamic_input/proc/finish(list/choices)
	finished = TRUE
	choices = query.get_results(choices)
	callback?.InvokeAsync(choices)
	if(!QDESTROYING(src))
		qdel(src)
