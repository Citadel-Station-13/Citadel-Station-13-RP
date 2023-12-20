/**
 * External tgui definitions, such as src_object APIs.
 *
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * global
 *
 * Associative list of JSON-encoded shared states that were set by
 * tgui clients.
 */
/datum/var/list/tgui_shared_states

//* API - Main - UI devs, look here! *//

/**
 * public
 *
 * Called on an object when a tgui object is being created, allowing you to
 * push various assets to tgui, for examples spritesheets.
 *
 * todo: support typepaths
 * todo: support file paths
 * todo: this should be sent to embedding interfaces
 *
 * return list List of asset datum instances (must be /datum/asset instance, not path)
 */
/datum/proc/ui_assets(mob/user)
	return list()

/**
 * public
 *
 * Called on a UI when the UI receieves a href.
 * Think of this as Topic().
 *
 * @params
 * * action - the string of the TGUI-side act() that was invoked by the user
 * * params - the list of key-value parameters of the act() invocation. This is always strings for both key and value!
 * * ui - the TGUI instance invoking this (host window)
 * * embed_context - (optional) if non-null, this datum is receiving an UI act as an embedded UI
 *
 * @return bool If the user's input has been handled and the UI should update.
 */
/datum/proc/ui_act(action, list/params, datum/tgui/ui)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_UI_ACT, usr, action, params, ui)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!ui || ui.status != UI_INTERACTIVE)
		return TRUE

/**
 * public
 *
 * Data to be sent to the UI.
 * This must be implemented for a UI to work.
 *
 * @params
 * * user - (optional) the mob using the UI
 * * ui - (optional) the host tgui
 *
 * return list Data to be sent to the UI.
 */
/datum/proc/ui_data(mob/user, datum/tgui/ui)
	return list() // Not implemented.

/**
 * public
 *
 * Static Data to be sent to the UI.
 *
 * Static data differs from normal data in that it's large data that should be
 * sent infrequently. This is implemented optionally for heavy uis that would
 * be sending a lot of redundant data frequently. Gets squished into one
 * object on the frontend side, but the static part is cached.
 *
 *
 * @params
 * * user - (optional) the mob using the UI
 * * ui - (optional) the host tgui
 *
 * return list Static Data to be sent to the UI.
 */
/datum/proc/ui_static_data(mob/user, datum/tgui/ui)
	return list()

/**
 * public
 *
 * Used to open and update UIs.
 * If this proc is not implemented properly, the UI will not update correctly.
 *
 * todo: how should i ruin this proc? i don't really like update being twined with opening, but it makes sense..? ~silicons
 *
 * required user mob The mob who opened/is using the UI.
 * optional ui datum/tgui The UI to be updated, if it exists.
 *
 *! ## To-Be-Deprecated.
 * optional parent_ui datum/tgui A parent UI that, when closed, closes this UI as well.
 */
/datum/proc/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	return FALSE // Not implemented.

/**
 * private
 *
 * todo: this is just completely ignored for modules/embedding. is this a good thing? ~silicons
 *
 * The UI's host object (usually src_object).
 * This allows modules/datums to have the UI attached to them,
 * and be a part of another object.
 */
/datum/proc/ui_host()
	return src // Default src.

/**
 * private
 *
 * todo: this is just completely ignored for modules/embedding. is this a good thing? ~silicons
 *
 * The UI's state controller to be used for created uis
 * This is a proc over a var for memory reasons
 */
/datum/proc/ui_state()
	return GLOB.default_state

/**
 * Called to route UI act calls to modules.
 * 
 * This is a proc so you can override yourself - very useful if you're doing your own module system
 * rather than copy-pasting module code.
 * 
 * @params
 * * action - the action string of the ui_act
 * * params - list of string key-values; this is always strings, text2num your number args if needed!
 * * ui - the host window ui datum
 * * id - the module ID of the route request
 * 
 * @return TRUE if it was handled by modules.
 */
/datum/proc/ui_route(action, list/params, datum/tgui/ui, id)
	#warn uhh

/**
 * public
 *
 * Checks the overall UI state for a mob.
 *
 * todo: this is just completely ignored for modules/embedding. is this a good thing? ~silicons
 *
 * @params
 * * user - The mob who opened/is using the UI.
 * * state - The state to check.
 *
 * return UI_state The state of the UI.
 */
/datum/proc/ui_status(mob/user, datum/ui_state/state)
	var/src_object = ui_host(user)
	. = UI_CLOSE
	if(!state)
		return

	if(isobserver(user))
		// If they turn on ghost AI control, admins can always interact.
		if(IsAdminGhost(user))
			. = max(., UI_INTERACTIVE)

		// Regular ghosts can always at least view if in range.
		if(user.client)
			// todo: in view range for zooming
			if(get_dist(src_object, user) < max(CEILING(user.client.current_viewport_width / 2, 1), CEILING(user.client.current_viewport_height / 2, 1)))
				. = max(., UI_UPDATE)

	// Check if the state allows interaction
	var/result = state.can_use_topic(src_object, user)
	. = max(., result)

//* API - Update - Optimizers, look here! *//

/**
 * public
 *
 * Forces an update to regular UI data.
 *
 * If no user is provided, every user will be updated.
 *
 * @params
 * * user - (optional) the mob to update
 * * ui - (optional) the /datum/tgui to update
 */
/datum/proc/update_ui_data(mob/user, datum/tgui/ui)
	if(isnull(user))
		SStgui.update_uis(src)
	else
		SStgui.try_update_ui(user, src, ui)
	#warn send to embedders

/**
 * public
 *
 * Forces an update on static data. Should be done manually whenever something
 * happens to change static data.
 *
 * If no user is provided, every user will be updated.
 *
 * optional user the mob currently interacting with the ui
 * optional ui tgui to be updated
 * optional hard_refreshion use if you need to block the ui from showing if the refresh queues
 */
/datum/proc/update_static_data(mob/user, datum/tgui/ui, hard_refresh)
	if(!user)
		for (var/datum/tgui/window as anything in SStgui.open_uis_by_src[REF(src)])
			window.send_full_update(hard_refresh = hard_refresh)
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.send_full_update(hard_refresh = hard_refresh)
	#warn send to embedders

/**
 * immediately shunts this data to either an user, an ui, or all users.
 *
 * @params
 * * user - when specified, only pushes this user. else, pushes to all windows.
 * * ui - when specified, only pushes this ui for a given user.
 * * updates - list(id = list(data...), ...) for modules. the reducer on tgui-side will only overwrite provided data keys.
 */
/datum/proc/push_ui_data(mob/user, datum/tgui/ui, list/data)
	if(!user)
		for (var/datum/tgui/window as anything in SStgui.open_uis_by_src[REF(src)])
			window.push_data(data)
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.push_data(data)
	#warn send to embedders

/**
 * immediately pushes module updates to user, an ui, or all users
 *
 * @params
 * * user - when specified, only pushes this user. else, pushes to all windows.
 * * ui - when specified, only pushes this ui for a given user.
 * * updates - list(id = list(data...), ...) for modules. the reducer on tgui-side will only overwrite provided data keys.
 */
/datum/proc/push_ui_modules(mob/user, datum/tgui/ui, list/updates)
	if(!user)
		for (var/datum/tgui/window as anything in SStgui.open_uis_by_src[REF(src)])
			window.push_modules(updates)
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.push_modules(updates)
	#warn send to embedders

//* Checks *//

/**
 * public
 *
 * checks if UIs are open
 */
/datum/proc/has_open_ui()
	return length(SStgui.open_uis_by_src[REF(src)])

//* Hooks *//

/**
 * Called when a new UI is opened with this datum as the host, or when this datum is embedded into another UI.
 *
 * Called once per embed, if multiple windows embedding this datum is transferred. Handle this accordingly!
 *
 * When overriding this, be sure to cast embed_context to the right type for your datum.
 *
 * @params
 * * user - opening mob
 * * ui - the tgui instance
 * * embed_context - the embedding context; if null, this is a root/host window.
 */
/datum/proc/on_ui_open(mob/user, datum/tgui/ui)
	#warn hook this proc
	SIGNAL_HANDLER

/**
 * Called when an UI with this datum as the host is closed, or when an UI is no longer embedding this datum.
 *
 * Called once per embed, if multiple windows embedding this datum is transferred. Handle this accordingly!
 *
 * When overriding this, be sure to cast embed_context to the right type for your datum.
 *
 * @params
 * * user - opening mob
 * * ui - the tgui instance
 * * embed_context - the embedding context; if null, this is a root/host window.
 */
/datum/proc/on_ui_close(mob/user, datum/tgui/ui)
	SIGNAL_HANDLER

/**
 * Called on a UI's object when the UI is transferred from one mob to another.
 *
 * Called once per embed, if multiple windows embedding this datum is transferred. Handle this accordingly!
 *
 * When overriding this, be sure to cast embed_context to the right type for your datum.
 *
 * @params
 * * old_mob - the old mob
 * * new_mob - the new mob
 * * ui - the tgui instance
 * * embed_context - the embedding context; if null, this is a root/host window.
 */
/datum/proc/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui)
	return
