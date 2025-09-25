/*!
 * External tgui definitions, such as src_object APIs.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * global
 *
 * Tracks open windows for a user.
 */
/client/var/list/tgui_windows = list()

/**
 * global
 *
 * TRUE if cache was reloaded by tgui dev server at least once.
 */
/client/var/tgui_cache_reloaded = FALSE

/**
 * verb
 *
 * Called by UIs when they are closed.
 * Must be a verb so winset() can call it.
 *
 * required uiref ref The UI that was closed.
 */
/client/verb/uiclose(window_id as text)
	// Name the verb, and hide it from the user panel.
	set name = "uiclose"
	set hidden = TRUE
	var/mob/user = src?.mob
	if(!user)
		return
	// Close all tgui datums based on window_id.
	SStgui.force_close_window(user, window_id)

/**
 * Middleware for /client/Topic.
 *
 * return bool If TRUE, prevents propagation of the topic call.
 */
/client/proc/tgui_topic(href_list)
	if(usr.client != src)
		CRASH("client mismatch [usr?.client] vs [src]")
	// Skip non-tgui topics
	if(!href_list["tgui"])
		return FALSE
	var/type = href_list["type"]
	// Unconditionally collect tgui logs
	if(type == "log")
		var/context = href_list["window_id"]
		if (href_list["ns"])
			context += " ([href_list["ns"]])"
		log_tgui(usr, href_list["message"],
			context = context)
	// Reload all tgui windows
	if(type == "cacheReloaded")
		if(!check_rights(R_ADMIN) || usr.client.tgui_cache_reloaded)
			return TRUE
		// Mark as reloaded
		usr.client.tgui_cache_reloaded = TRUE
		// Notify windows
		var/list/windows = usr.client.tgui_windows
		for(var/window_id in windows)
			var/datum/tgui_window/window = windows[window_id]
			if (window.status == TGUI_WINDOW_READY)
				window.on_message(type, null, href_list)
		return TRUE
	// Locate window
	var/window_id = href_list["window_id"]
	var/datum/tgui_window/window
	if(window_id)
		window = usr.client.tgui_windows[window_id]
		if(!window)
			log_tgui(usr,
				"Error: Couldn't find the window datum, force closing.",
				context = window_id)
			SStgui.force_close_window(usr, window_id)
			return TRUE

	// Decode payload
	var/payload
	if(href_list["payload"])
		var/payload_text = href_list["payload"]

		if (!rustg_json_is_valid(payload_text))
			log_tgui(usr, "Error: Invalid JSON")
			return TRUE

		payload = json_decode(payload_text)

	// Pass message to window
	if(window)
		window.on_message(type, payload, href_list)
	return TRUE
