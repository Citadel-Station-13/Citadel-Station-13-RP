/*!
 * External tgui definitions, such as src_object APIs.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * global
 *
 * Associative list of JSON-encoded shared states that were set by
 * tgui clients.
 */
/datum/var/list/tgui_shared_states

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
 * optional parent_ui datum/tgui A parent UI that, when closed, closes this UI as well.
 */
/datum/proc/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	return FALSE // Not implemented.

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
	return list()

/**
 * Gets nested data to be sent to the UI on first launch.
 * * Nested data is 2-deep, instead of the usual data deep. The reducer operates on
 *   lists of the given key, allowing you to replace data in nested lists
 *   without updating the whole list at once.
 * * Nested data is an advanced concept that the majority of UIs will never need.
 *   As such, it is not updated automatically. Use `push_ui_nested_data()` to manually push updates.
 * * This will only be called on initial opens and when static data is being updated.
 *
 * @params
 * * user - (optional) the mob using the UI
 * * ui - (optional) the host tgui
 * @return list of data to send; "key" = list(data), as this is nested data.
 */
/datum/proc/ui_nested_data(mob/user, datum/tgui/ui)
	return list()

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
 * Called on an object when a tgui object is being created, allowing you to
 * push various assets to tgui, for examples spritesheets.
 *
 * todo: support file paths
 * todo: this should be sent to embedding interfaces
 *
 * assets may be:
 * * a /datum/asset_pack
 * * typepath of a /datum/asset_pack
 *
 * @params
 * * ui - the UI instance that's being opened
 * * immediate - what assets to load before the window is opened
 * * deferred - what assets to load after the window is opened
 */
/datum/proc/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	return

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
 *
 * return bool If the user's input has been handled and the UI should update.
 */
/datum/proc/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!ui || ui.status != UI_INTERACTIVE)
		return TRUE

/**
 * private
 *
 * The UI's host object (usually src_object).
 * This allows modules/datums to have the UI attached to them,
 * and be a part of another object.
 */
/datum/proc/ui_host(mob/user)
	return src // Default src.

/**
 * private
 *
 * The UI's state controller to be used for created uis
 * This is a proc over a var for memory reasons
 */
/datum/proc/ui_state(mob/user)
	return GLOB.default_state

/**
 * TODO: replace module system with something else
 *
 * Called to route UI act calls to modules.
 *
 * This is a proc so you can override yourself - very useful if you're doing your own module system
 * rather than copy-pasting module code.
 *
 * TODO: get rid of this, we should use parent ui, not the weird modules system we have going on.
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
	SHOULD_CALL_PARENT(TRUE)
	// todo: the fact this is here is probably a bad thing, as it's very poorly documented.
	// this basically matches the useModule<>() hook used on the UI side, because id is null if
	// we're a host window, and not an act call from an embedded component.
	if(!id)
		return ui_act(action, params, ui, ui.state, new /datum/event_args/actor(usr))
	return FALSE

/**
 * immediately shunts this data to either an user, an ui, or all users.
 *
 * prefer to use this instead of update_static_data or update_ui_data, because this supports embedding
 * and is generally faster.
 *
 * @params
 * * user - when specified, only pushes this user. else, pushes to all windows.
 * * ui - when specified, only pushes this ui for a given user.
 * * data - list(...) for data. the reducer on tgui-side will only overwrite provided data keys.
 * * nested_data - list(id = list(data...), ...) for nested data. the reducer on tgui-side will only overwrite provided data keys.
 */
/datum/proc/push_ui_data(mob/user, datum/tgui/ui, list/data, list/nested_data)
	// todo: the way this works is so jank; this should be COMSIG_DATUM_HOOK_UI_PUSH instead?
	// todo: this is because user, ui, data needs to go to the signal before being auto-resolved, as modules
	// todo: won't necessarily match the values!
	// FUCK
	// ~silicons
	SEND_SIGNAL(src, COMSIG_DATUM_PUSH_UI_DATA, user, ui, data)
	if(!user)
		for (var/datum/tgui/window as anything in open_uis)
			window.push_data(data, nested_data)
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		// todo: this is force because otherwise static data can be desynced. should static data be on another proc instead?
		ui.push_data(data, nested_data, TRUE)

/**
 * immediately pushes module updates to user, an ui, or all users
 *
 * @params
 * * user - when specified, only pushes this user. else, pushes to all windows.
 * * ui - when specified, only pushes this ui for a given user.
 * * updates - list(id = list(data...), ...) for modules. the reducer on tgui-side will only overwrite provided data keys.
 */
/datum/proc/push_ui_nested_data(mob/user, datum/tgui/ui, list/updates)
	if(!user)
		for (var/datum/tgui/window as anything in open_uis)
			window.push_nested_data(updates)
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.push_nested_data(updates)

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
 * * If no user is provided, every user will be updated.
 * * Ignores static and nested data.
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
 * optional hard_refresh use if you need to block the ui from showing if the refresh queues
 */
/datum/proc/update_static_data(mob/user, datum/tgui/ui, hard_refresh)
	if(!user)
		for(var/datum/tgui/window as anything in open_uis)
			window.send_full_update()
		return
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.send_full_update()

//* Checks *//

/**
 * public
 *
 * checks if UIs are open
 */
/datum/proc/has_open_ui()
	return length(open_uis)

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
 * * embedded - this was an embedded ui / the datum is being embedded
 */
/datum/proc/on_ui_open(mob/user, datum/tgui/ui, embedded)
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
 * * embedded - this was an embedded ui / the datum is being un-embedded
 */
/datum/proc/on_ui_close(mob/user, datum/tgui/ui, embedded)
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
 * * embedded - this was an embedded transfer
 */
/datum/proc/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui, embedded)
	return
