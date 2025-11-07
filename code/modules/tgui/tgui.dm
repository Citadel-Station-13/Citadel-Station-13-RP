/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui datum (represents a UI).
 *
 * ## Data
 *
 * TGUI has two levels of data.
 *
 * * 'data': The data and static data pushed into the UI. Data is updated as it's pushed in
 *   with a 1-deep reducer, meaning that anything you push will overwrite the old value of the key
 *   but not replace any other keys. This allows for partial updates.
 * * 'modules': A secondary data-list. This works just like 'data', but the reducer behavior is
 *   2-deep. This is a key-key-value list instead of a key-value list, basically.
 *   This is used to inject 'embeds' into TGUI, as well, as their data can be then sent
 *   without sending data for everything else as well.
 *
 * ## Future Work
 *
 * * move to react
 * * add a way to dynamically pop up modals on tgui with the root renderer, without
 *   needing interface-specific implementation
 * * mob-indirection investigation for remote control (remote controller using rigsuit mob to hack door, as an eaxmple)
 */
/datum/tgui
	/// The mob who opened/is using the UI.
	var/mob/user
	/// The object which owns the UI.
	var/datum/src_object
	/// The title of te UI.
	var/title
	/// The window_id for browse() and onclose().
	var/datum/tgui_window/window
	/// Key that is used for remembering the window geometry.
	var/window_key
	/// The interface (template) to be used for this UI.
	var/interface
	/// Update the UI every MC tick.
	var/autoupdate = TRUE
	/// If the UI has been initialized yet.
	var/initialized = FALSE
	/// Time of opening the window.
	var/opened_at
	/// Stops further updates when close() was called.
	var/closing = FALSE
	/// The status/visibility of the UI.
	var/status = UI_INTERACTIVE
	/// Timed refreshing state
	var/refreshing = UI_NOT_REFRESHING
	/// Topic state used to determine status/interactability.
	var/datum/ui_state/state = null
	/// Rate limit client refreshes to prevent DoS.
	COOLDOWN_DECLARE(refresh_cooldown)

	/// The id of any ByondUi elements that we have opened
	var/list/open_byondui_elements

	/// The Parent UI
	var/datum/tgui/parent_ui
	/// Children of this UI
	var/list/datum/tgui/children = list()

	//* Modules - experimental *//
	/// datums to IDs
	//  todo: rid of this
	var/list/datum/modules_registered
	/// processed modules
	//  todo: rid of this
	var/list/datum/modules_processed

/**
 * Linter check, do not call.
 */
/proc/lint__check_tgui_new_doesnt_sleep()
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/tgui/tgui
	tgui.New()

/**
 * public
 *
 * Create a new UI.
 *
 * * Does not block.
 *
 * required user mob The mob who opened/is using the UI.
 * required src_object datum The object or datum which owns the UI.
 * required interface string The interface used to render the UI.
 * optional title string The title of the UI.
 * * (optional) parent_ui - the UI we spawned off of as a child window.
 *
 * return datum/tgui The requested UI.
 */
/datum/tgui/New(mob/user, datum/src_object, interface, title, datum/tgui/parent_ui)
	log_tgui(user,
		"new [interface] fancy [user?.client?.preferences.get_entry(/datum/game_preference_entry/toggle/tgui_fancy)]",
		src_object = src_object)
	src.user = user
	src.src_object = src_object
	src.window_key = "[REF(src_object)]-main"
	src.interface = interface
	if(title)
		src.title = title
	src.state = src_object.ui_state(user)
	src.parent_ui = parent_ui
	if(src.parent_ui)
		src.parent_ui.children += src

/datum/tgui/Destroy()
	user = null
	src_object = null
	for(var/datum/module in modules_registered)
		unregister_module(module)
	return ..()

/**
 * public
 *
 * Open this UI (and initialize it with data).
 *
 * This proc does not block.
 *
 * @params
 * * data - force certain data sends
 * * nested_data - force certain module sends
 *
 * return bool - TRUE if a new pooled window is opened, FALSE in all other situations including if a new pooled window didn't open because one already exists.
 */
/datum/tgui/proc/open(data, nested_data)
	SHOULD_NOT_SLEEP(TRUE)
	if(!user.client)
		return FALSE
	if(window)
		return FALSE
	process_status()
	if(status < UI_UPDATE)
		return FALSE
	window = SStgui.request_pooled_window(user)
	if(!window)
		return FALSE
	// point of no return; call initialize() asynchronously.
	opened_at = world.time
	window.acquire_lock(src)
	SStgui.on_open(src)
	// defer initialize() to after current call chain.
	spawn(0)
		initialize(data, nested_data)
	return TRUE

/**
 * Initializes the window.
 *
 * * Separate from open() so that open() can be non-blocking.
 */
/datum/tgui/proc/initialize(extra_data, extra_nested_data)
	// todo: this is a blocking proc. src_object can be deleted at any time between the blocking procs.
	//       we need sane handling of deletion order, of runtimes happen.
	if(!window.is_ready())
		window.initialize(
			strict_mode = TRUE,
			fancy = user.client.preferences.get_entry(/datum/game_preference_entry/toggle/tgui_fancy),
			assets = list(
				/datum/asset_pack/simple/tgui,
			),
		)
	else
		window.send_message("ping")
	var/flush_queue = FALSE
	flush_queue |= window.send_asset(/datum/asset_pack/simple/fontawesome)
	flush_queue |= window.send_asset(/datum/asset_pack/simple/tgfont)
	// prep assets
	var/list/assets_immediate = list()
	var/list/assets_deferred = list()
	// fetch wanted assets
	src_object.ui_asset_injection(src, assets_immediate, assets_deferred)
	// send all immediate assets
	for(var/datum/asset_pack/assetlike as anything in assets_immediate)
		flush_queue |= window.send_asset(assetlike)
	// ensure all assets are loaded before continuing
	if (flush_queue)
		user.client.asset_cache_flush_browse_queue()
	window.send_message("update", get_payload(
		with_data = TRUE,
		with_static_data = TRUE,
		extra_data = extra_data,
		extra_nested_data = extra_nested_data,
	))
	// if(mouse_hooked)
	// 	window.set_mouse_macro()
	// todo: should these hooks be here?
	src_object.on_ui_open(user, src)
	for(var/datum/module as anything in modules_registered)
		module.on_ui_open(user, src, TRUE)
	// now send deferred asets
	for(var/datum/asset_pack/assetlike as anything in assets_deferred)
		window.send_asset(assetlike)
	return TRUE

/**
 * public
 *
 * Close the UI.
 *
 * optional can_be_suspended bool
 */
/datum/tgui/proc/close(can_be_suspended = TRUE)
	if(closing)
		return
	closing = TRUE
	// If we don't have window_id, open proc did not have the opportunity
	// to finish, therefore it's safe to skip this whole block.
	if(window)
		// Windows you want to keep are usually blue screens of death
		// and we want to keep them around, to allow user to read
		// the error message properly.
		window.release_lock()
		window.close(can_be_suspended)
		src_object.on_ui_close(user)
		SStgui.on_close(src)

		if(user.client)
			terminate_byondui_elements()

	state = null
	if(parent_ui)
		parent_ui.children -= src
	parent_ui = null
	// todo: should these hooks be here?
	src_object.on_ui_close(user, src)
	for(var/datum/module as anything in modules_registered)
		module.on_ui_close(user, src, TRUE)
	qdel(src)

/**
 * public
 *
 * Closes all ByondUI elements, left dangling by a forceful TGUI exit,
 * such as via Alt+F4, closing in non-fancy mode, or terminating the process
 *
 */
/datum/tgui/proc/terminate_byondui_elements()
	set waitfor = FALSE

	for(var/byondui_element in open_byondui_elements)
		winset(user.client, byondui_element, list("parent" = ""))

/**
 * public
 *
 * Enable/disable auto-updating of the UI.
 *
 * required value bool Enable/disable auto-updating.
 */
/datum/tgui/proc/set_autoupdate(autoupdate)
	src.autoupdate = autoupdate

/**
 * public
 *
 * Replace current ui.state with a new one.
 *
 * required state datum/ui_state/state Next state
 */
/datum/tgui/proc/set_state(datum/ui_state/state)
	src.state = state

/**
 * public
 *
 * Makes an asset available to use in tgui.
 *
 * required asset datum/asset
 *
 * return bool - true if an asset was actually sent
 */
/datum/tgui/proc/send_asset(datum/asset_pack/asset)
	if(!window)
		CRASH("send_asset() was called either without calling open() first or when open() did not return TRUE.")
	return window.send_asset(asset)

/**
 * public
 *
 * Send a full update to the client (includes static data).
 *
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_full_update(force)
	if(!user.client || !initialized || closing)
		return
	if(!COOLDOWN_FINISHED(src, refresh_cooldown))
		refreshing = TRUE
		addtimer(CALLBACK(src, PROC_REF(send_full_update), force), COOLDOWN_TIMELEFT(src, refresh_cooldown), TIMER_UNIQUE)
		return
	refreshing = FALSE
	var/should_update_data = force || status >= UI_UPDATE
	window.send_message("update", get_payload(
		with_data = should_update_data,
		with_static_data = TRUE))
	COOLDOWN_START(src, refresh_cooldown, TGUI_REFRESH_FULL_UPDATE_COOLDOWN)

/**
 * public
 *
 * Send a partial update to the client (excludes static data).
 *
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_update(force)
	if(!user.client || !initialized || closing)
		return
	var/should_update_data = force || status >= UI_UPDATE
	window.send_message("update", get_payload(with_data = should_update_data))

/**
 * private
 *
 * Package the data to send to the UI, as JSON.
 *
 * return list
 */
/datum/tgui/proc/get_payload(with_data, with_static_data, list/extra_data, list/extra_nested_data)
	var/list/json_data = list()
	json_data["config"] = list(
		"title" = title,
		"status" = status,
		"interface" = list(
			"name" = interface,
			"layout" = "", //user.client.preferences.get_entry(src_object.layout_prefs_used),
		),
		"refreshing" = refreshing,
		"window" = list(
			"key" = window_key,
			"fancy" = user.client.preferences.get_entry(/datum/game_preference_entry/toggle/tgui_fancy),
			"locked" = user.client.preferences.get_entry(/datum/game_preference_entry/toggle/tgui_lock),
			"scale" = user.client.preferences.get_entry(/datum/game_preference_entry/toggle/ui_scale),
		),
		"client" = list(
			"ckey" = user.client.ckey,
			"address" = user.client.address,
			"computer_id" = user.client.computer_id,
		),
		"user" = list(
			"name" = "[user]",
			"observer" = isobserver(user),
		),
	)
	var/list/nestedData = with_static_data ? src_object.ui_nested_data(user, src) : list()
	// static first
	if(with_static_data)
		json_data["staticData"] = src_object.ui_static_data(user, src)
		for(var/datum/module as anything in modules_registered)
			var/id = modules_registered[module]
			nestedData[id] = module.ui_static_data(user, src, TRUE)
	if(with_data)
		json_data["data"] = src_object.ui_data(user, src)
		for(var/datum/module as anything in (with_static_data? modules_registered : modules_processed))
			var/id = modules_registered[module]
			nestedData[id] = nestedData[id] | module.ui_data(user, src, TRUE)
	if(nestedData)
		json_data["nestedData"] = nestedData
	if(src_object.tgui_shared_states)
		json_data["shared"] = src_object.tgui_shared_states
	if(extra_data)
		json_data["data"] = (json_data["data"] || list()) | extra_data
	if(extra_nested_data)
		json_data["nestedData"] = (json_data["nestedData"] || list()) | extra_nested_data
	return json_data

/**
 * private
 *
 * Run an update cycle for this UI. Called internally by SStgui
 * every second or so.
 */
/datum/tgui/process(seconds_per_tick, force = FALSE)
	if(closing)
		return
	var/datum/host = src_object.ui_host(user)
	// If the object or user died (or something else), abort.
	if(QDELETED(src_object) || QDELETED(host) || QDELETED(user) || QDELETED(window))
		close(can_be_suspended = FALSE)
		return
	// Validate ping
	if(!initialized && world.time - opened_at > TGUI_PING_TIMEOUT)
		log_tgui(user, "Error: Zombie window detected, closing.",
			window = window,
			src_object = src_object)
		close(can_be_suspended = FALSE)
		return
	// Update through a normal call to ui_interact
	if(status != UI_DISABLED && (autoupdate || force))
		src_object.ui_interact(user, src, parent_ui)
		return
	// Update status only
	var/needs_update = process_status()
	if(status <= UI_CLOSE)
		close()
		return
	if(needs_update)
		window.send_message("update", get_payload())

/**
 * private
 *
 * Updates the status, and returns TRUE if status has changed.
 */
/datum/tgui/proc/process_status()
	var/prev_status = status
	status = src_object.ui_status(user, state)
	if(parent_ui)
		status = min(status, parent_ui.status)
	return prev_status != status

/**
 * private
 *
 * Callback for handling incoming tgui messages.
 */
/datum/tgui/proc/on_message(type, list/payload, list/href_list)
	// Pass act type messages to ui_act
	if(type && copytext(type, 1, 5) == "act/")
		var/act_type = copytext(type, 5)
		log_tgui(user, "Action: [act_type] [href_list["payload"]]",
			window = window,
			src_object = src_object)
		process_status()
		// todo decouple this from on_message and throw it on its own queue loop
		on_act_message(act_type, payload, state)
		// DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(on_act_message), act_type, payload, state))
		return FALSE
	// TODO: probably burn this (mod/) with fire
	if(type && copytext(type, 1, 5) == "mod/")
		var/act_type = copytext(type, 5)
		var/mod_id = payload["$m_id"]
		log_tgui(user, "Module: [act_type] - [mod_id] [href_list["payload"]]",
			window = window,
			src_object = src_object)
		process_status()
		// tell it to route the call
		// note: this is pretty awful code because raw locate()'s are
		// almost never a good idea
		// however given we don't have a way of just tracking a ui module list (yet)
		// we're kind of stuck doing this
		// maybe in the future we'll just have ui modules list but for now
		// eh.
		if(src_object.ui_route(act_type, payload, src, mod_id))
			SStgui.update_uis(src_object)
		return FALSE
	switch(type)
		if("ready")
			// Send a full update when the user manually refreshes the UI
			if(initialized)
				send_full_update()
			initialized = TRUE
		if("ping/reply")
			initialized = TRUE
		if("suspend")
			close(can_be_suspended = TRUE)
		if("close")
			close(can_be_suspended = FALSE)
		if("log")
			if(href_list["fatal"])
				close(can_be_suspended = FALSE)
		if("setSharedState")
			if(status != UI_INTERACTIVE)
				return
			LAZYINITLIST(src_object.tgui_shared_states)
			src_object.tgui_shared_states[href_list["key"]] = href_list["value"]
			SStgui.update_uis(src_object)
		if(TGUI_MANAGED_BYONDUI_TYPE_RENDER)
			var/byond_ui_id = payload[TGUI_MANAGED_BYONDUI_PAYLOAD_ID]
			if(!byond_ui_id || LAZYLEN(open_byondui_elements) > TGUI_MANAGED_BYONDUI_LIMIT)
				return

			LAZYDISTINCTADD(open_byondui_elements, byond_ui_id)
		if(TGUI_MANAGED_BYONDUI_TYPE_UNMOUNT)
			var/byond_ui_id = payload[TGUI_MANAGED_BYONDUI_PAYLOAD_ID]
			if(!byond_ui_id)
				return

			LAZYREMOVE(open_byondui_elements, byond_ui_id)

/// Wrapper for behavior to potentially wait until the next tick if the server is overloaded
/datum/tgui/proc/on_act_message(act_type, payload, state)
	if(QDELETED(src) || QDELETED(src_object))
		return
	if(src_object.ui_act(act_type, payload, src, state, new /datum/event_args/actor(usr)))
		SStgui.update_uis(src_object)

//* Advanced API - Updates *//

/**
 * public
 *
 * Send a partial update to the client of only the provided data lists
 * Does not update config at all
 *
 * WARNING: Do not use this unless you know what you are doing
 *
 * @params
 * * data - The data to send.
 * * nested_data - Data to send to nested_data.
 * * force - (optional) Send an update even if UI is not interactive.
 *
 * @return TRUE if data was sent, FALSE otherwise.
 */
/datum/tgui/proc/push_data(data, nested_data, force)
	if(!user.client || !initialized || closing)
		return FALSE
	if(!force && status < UI_UPDATE)
		return FALSE
	// todo: one message
	window.send_message("data", data)
	window.send_message("nestedData", nested_data)
	return TRUE

/**
 * public
 *
 * Send an update to module data.
 * As with normal data, this will be combined by a reducer
 * to overwrite only where necessary, so partial pushes
 * can work fine.
 *
 * WARNING: Do not use this unless you know what you are doing.
 *
 * @params
 * * updates - list(id = list(data...), ...) of nested data to update.
 * * force - (optional) send update even if UI is not interactive
 *
 * @return TRUE if data was sent, FALSE otherwise.
 */
/datum/tgui/proc/push_nested_data(list/updates, force)
	if(isnull(user.client) || !initialized || closing)
		return FALSE
	if(!force && status < UI_UPDATE)
		return FALSE
	window.send_message("nestedData", updates)
	return TRUE

//* Module System *//

/**
 * Registers a datum as a module into this UI.
 *
 * todo: why is 'interface' a param again..?
 *
 * @params
 * * module - the module in question
 * * id - the id to use for the module
 * * interface - the interface identifier (e.g. TGUILatheContrrol)
 * * process - should this be a processed / auto updated module?
 */
/datum/tgui/proc/register_module(datum/module, id, interface, process = TRUE)
	if(isnull(interface) && istype(module, /datum/tgui_module))
		var/datum/tgui_module/actual_module = module
		interface = actual_module.tgui_id
	LAZYINITLIST(modules_registered)
	modules_registered[module] = id
	if(process)
		LAZYINITLIST(modules_processed)
		modules_processed += module
	RegisterSignal(module, COMSIG_PARENT_QDELETING, PROC_REF(module_deleted))
	RegisterSignal(module, COMSIG_DATUM_PUSH_UI_DATA, PROC_REF(module_send_data))

/datum/tgui/proc/unregister_module(datum/module)
	modules_processed -= module
	modules_registered -= module
	UnregisterSignal(module, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_DATUM_PUSH_UI_DATA,
	))

/datum/tgui/proc/module_deleted(datum/source)
	SIGNAL_HANDLER
	unregister_module(source)

/datum/tgui/proc/module_send_data(datum/source, mob/user, datum/tgui/ui, list/data)
	if(!isnull(user) && user != user)
		return
	if(!isnull(ui) && ui != src)
		return
	// todo: this is force because otherwise static data can be desynced. should static data be on another proc instead?
	push_nested_data(
		updates = list(
			(modules_registered[source]) = data,
		),
		force = TRUE,
	)

//* Helpers - Invoked from ui_act() *//

/**
 * Lazy check to see if the host window is still interactive.
 */
/datum/tgui/proc/still_interactive()
	return status == UI_INTERACTIVE

//* Setters *//

/datum/tgui/proc/set_title(string)
	title = string
