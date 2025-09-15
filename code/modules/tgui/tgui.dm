/**
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui datum (represents a UI).
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
	/// Are byond mouse events beyond the window passed in to the ui
	var/mouse_hooked = FALSE
	/// The Parent UI
	//? STOP USING THIS. USE MODULES. ~SILICONS
	var/datum/tgui/parent_ui
	/// Children of this UI
	//? STOP USING THIS. USE MODULES. ~SILICONS
	var/list/children = list()

	//* Modules *//
	/// datums to IDs
	var/list/datum/modules_registered
	/// processed modules
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
 * optional parent_ui datum/tgui The parent of this UI.
 *
 * return datum/tgui The requested UI.
 */
/datum/tgui/New(mob/user, datum/src_object, interface, title, datum/tgui/parent_ui)
	log_tgui(user,
		// "new [interface] fancy [user?.client?.prefs.tgui_fancy]",
		"new [interface] fancy 1",
		src_object = src_object)
	src.user = user
	src.src_object = src_object
	src.window_key = "[REF(src_object)]-main"
	src.interface = interface
	if(title)
		src.title = title
	src.state = src_object.ui_state(user)
	src.parent_ui = parent_ui
	if(parent_ui)
		parent_ui.children += src

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
 * * modules - force certain module sends
 *
 * return bool - TRUE if a new pooled window is opened, FALSE in all other situations including if a new pooled window didn't open because one already exists.
 */
/datum/tgui/proc/open(data, modules)
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
		initialize(data, modules)
	return TRUE

/**
 * Initializes the window.
 *
 * * Separate from open() so that open() can be non-blocking.
 */
/datum/tgui/proc/initialize(data, modules)
	// todo: this is a blocking proc. src_object can be deleted at any time between the blocking procs.
	//       we need sane handling of deletion order, of runtimes happen.
	if(!window.is_ready())
		window.initialize(
			strict_mode = TRUE,
			// todo: do we need that lmao
			// fancy = user.client.prefs.tgui_fancy,
			fancy = TRUE,
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
		force_data = data,
		force_modules = modules,
	))
	if(mouse_hooked)
		window.set_mouse_macro()
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
	SStgui.on_close(src)
	// If we don't have window_id, open proc did not have the opportunity
	// to finish, therefore it's safe to skip this whole block.
	if(window)
		// Windows you want to keep are usually blue screens of death
		// and we want to keep them around, to allow user to read
		// the error message properly.
		window.release_lock()
		window.close(can_be_suspended)
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
 * Enable/disable auto-updating of the UI.
 *
 * required value bool Enable/disable auto-updating.
 */
/datum/tgui/proc/set_autoupdate(autoupdate)
	src.autoupdate = autoupdate

/**
 * public
 *
 * Enable/disable passing through byond mouse events to the window
 *
 * todo: this is like the least documented proc in history wtf
 *
 * required value bool Enable/disable hooking.
 */
/datum/tgui/proc/set_mouse_hook(value)
	src.mouse_hooked = value
	// TODO: handle unhooking/hooking on already open windows ?

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
 * optional hard_refresh block the ui entirely while this is refreshing. use if you don't want users to see an ui during a queued refresh.
 */
/datum/tgui/proc/send_full_update(force, hard_refresh)
	if(!initialized || closing || !user.client)
		return
	if(!COOLDOWN_FINISHED(src, refresh_cooldown))
		refreshing = max(refreshing, hard_refresh? UI_HARD_REFRESHING : UI_SOFT_REFRESHING)
		addtimer(CALLBACK(src, PROC_REF(send_full_update)), TGUI_REFRESH_FULL_UPDATE_COOLDOWN, TIMER_UNIQUE)
		return
	refreshing = UI_NOT_REFRESHING
	var/should_update_data = force || status >= UI_UPDATE
	window.send_message(
		"update",
		get_payload(
		with_data = should_update_data,
		with_static_data = TRUE,
		),
	)
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
	window.send_message("update", get_payload(
		with_data = should_update_data,
	))

/**
 * private
 *
 * Package the data to send to the UI, as JSON.
 *
 * return list
 */
/datum/tgui/proc/get_payload(with_data, with_static_data, list/force_data, list/force_modules)
	var/list/json_data = list()
	json_data["config"] = list(
		"title" = title,
		"status" = status,
		"interface" = interface,
		"refreshing" = refreshing,
		"window" = list(
			"key" = window_key,
			// "fancy" = user.client.prefs.tgui_fancy,
			// "locked" = user.client.prefs.tgui_lock,
			"fancy" = TRUE,
			"locked" = TRUE,
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
	var/list/modules = list()
	// static first
	if(with_static_data)
		json_data["static"] = src_object.ui_static_data(user, src)
		for(var/datum/module as anything in modules_registered)
			var/id = modules_registered[module]
			modules[id] = module.ui_static_data(user, src, TRUE)
	if(with_data)
		json_data["data"] = src_object.ui_data(user, src)
		for(var/datum/module as anything in (with_static_data? modules_registered : modules_processed))
			var/id = modules_registered[module]
			modules[id] = modules[id] | module.ui_data(user, src, TRUE)
	if(modules)
		json_data["modules"] = modules
	if(src_object.tgui_shared_states)
		json_data["shared"] = src_object.tgui_shared_states
	if(!isnull(force_data))
		json_data["data"] = (json_data["data"] || list()) | force_data
	if(!isnull(force_modules))
		json_data["modules"] = (json_data["modules"] || list()) | force_modules
	return json_data

/**
 * private
 *
 * Run an update cycle for this UI. Called internally by SStgui
 * every second or so.
 */
/datum/tgui/process(delta_time, force = FALSE)
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
	if(type)
		// micro opt in that these routes are same length so we only copytext once
		switch(copytext(type, 1, 5))
			if("act/")	// normal act
				var/action = copytext(type, 5)
				log_tgui(user, "Action: [action] [href_list["payload"]]",
					window = window,
					src_object = src_object)
				process_status()
				if(src_object.ui_act(action, payload, src, new /datum/event_args/actor(usr)))
					SStgui.update_uis(src_object)
				return FALSE
			if("mod/")	// module act
				var/action = copytext(type, 5)
				var/id = payload["$m_id"]
				// log, update status
				log_tgui(user, "Module: [action] [href_list["payload"]]",
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
				if(src_object.ui_route(action, payload, src, id))
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

//* Advanced API - Updates *//

/**
 * public
 *
 * Send a partial update to the client of only the provided data lists
 * Does not update config at all
 *
 * WARNING: Do not use this unless you know what you are doing
 *
 * required data The data to send
 * optional force bool Send an update even if UI is not interactive.
 *
 * @return TRUE if data was sent, FALSE otherwise.
 */
/datum/tgui/proc/push_data(data, force)
	if(!user.client || !initialized || closing)
		return FALSE
	if(!force && status < UI_UPDATE)
		return FALSE
	window.send_message("data", data)
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
 * * updates - list(id = list(data...), ...) of modules to update.
 * * force - (optional) send update even if UI is not interactive
 *
 * @return TRUE if data was sent, FALSE otherwise.
 */
/datum/tgui/proc/push_modules(list/updates, force)
	if(isnull(user.client) || !initialized || closing)
		return FALSE
	if(!force && status < UI_UPDATE)
		return FALSE
	window.send_message("modules", updates)
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
	push_modules(
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
