//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Helper datum used to build a query for tgui_dynamic_input
 * High overhead, technically not necessary, but, this is easy to use as an API.
 */
/datum/tgui_dynamic_query
	/// options list
	var/list/options

/datum/tgui_dyamic_query/proc/text(key, name, desc, max_length = 512, multi_line = FALSE, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options += list(
		"key" = key,
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_TEXT,
		"constraints" = list(max_length),
	)
	return src

/datum/tgui_dynamic_query/proc/number(key, name, desc, min_value = -INFINITY, max_value = INFINITY, round_to, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options += list(
		"key" = key,
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_NUM,
		"constraints" = list(min_value, max_value, round_to),
	)
	return src

/datum/tgui_dynamic_query/proc/toggle(key, name, desc, default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options += list(
		"key" = key,
		"name" = name,
		"desc" = desc,
		"default" = default,
		"type" = TGUI_INPUT_DATATYPE_TOGGLE,
		"constraints" = list(),
	)
	return src

/datum/tgui_dynamic_query/proc/pick(key, name, desc, list/choices = list(), default)
	RETURN_TYPE(/datum/tgui_dynamic_query)
	options += list(
		"key" = key,
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
	for(var/i in 1 to length(choices))
		var/list/params = options[i]
		switch(params[TGUI_INPUT_DATA_TYPE])
			if(TGUI_INPUT_DATATYPE_TEXT)
				got = isnull(choices[i]) ? params[TGUI_INPUT_DATA_DEFAULT] : choices[i]
				if(!isnull(got))
					if(length(got) > params[TGUI_INPUT_DATA_CONSTRAINTS][1])
						got = copytext_char(got, 1, params[TGUI_INPUT_DATA_CONSTRAINTS][1] + 1)
				. += got
			if(TGUI_INPUT_DATATYPE_NUM)
				got = isnull(choices[i]) ? params[TGUI_INPUT_DATA_DEFAULT] : text2num(choices[i])
				if(!isnull(got))
					got = clamp(got, params[TGUI_INPUT_DATA_CONSTRAINTS][1], params[TGUI_INPUT_DATA_CONSTRAINTS][2])
					got = round(got, params[TGUI_INPUT_DATA_CONSTRAINTS][3])
			if(TGUI_INPUT_DATATYPE_LIST_PICK)
				got = isnull(choices[i]) ? params[TGUI_INPUT_DATA_DEFAULT] : choices[i]
				if(!isnull(got))
					if(!(got in params[TGUI_INPUT_DATA_CONSTRAINTS]))
						if(length(params[TGUI_INPUT_DATA_CONSTRAINTS]))
							got = params[TGUI_INPUT_DATA_CONSTRAINTS][1]
						else
							got = null
				. += got
			if(TGUI_INPUT_DATATYPE_TOGGLE)
				got = isnull(choices[i]) ? params[TGUI_INPUT_DATA_DEFAULT] : choices[i]
				if(!isnull(got))
					got = !!got
				. += got

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

/datum/tgui_dynamic_input/New(mob/user, message, title, datum/tgui_dynaimc_query/query, timeout, datum/callback/callback)
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
	callback?.InvokeAsync(choices)

/datum/tgui_dynamic_input/proc/sanitize(list/choices)
	#warn impl
