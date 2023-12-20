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

/**
 * read-only
 *
 * The type of /datum/tgui_embed_context that should be provided to this datum when it's embedded in another UI.
 */
/datum/var/tgui_embed_context = /datum/tgui_embed_context

//* API - Main - UI devs, look here! *//

/**
 * public
 *
 * Called on a UI when the UI receieves a href.
 * Think of this as Topic().
 *
 * required action string The action/button that has been invoked by the user.
 * required params list A list of parameters attached to the button.
 *
 * return bool If the user's input has been handled and the UI should update.
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
 * required user mob The mob interacting with the UI.
 *
 * return list Data to be sent to the UI.
 */
/datum/proc/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
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
 * required user mob The mob interacting with the UI.
 *
 * return list Statuic Data to be sent to the UI.
 */
/datum/proc/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return list()

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
/datum/proc/on_ui_open(mob/user, datum/tgui/ui, datum/tgui_embed_context/embed_context)
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
/datum/proc/on_ui_close(mob/user, datum/tgui/ui, datum/tgui_embed_context/embed_context)
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
/datum/proc/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui, datum/tgui_embed_context/embed_context)
	return
