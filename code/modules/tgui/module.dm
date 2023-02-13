/**
 *! SPDX-License-Identifier: MIT
 */

/**
 * new, more-modular tgui_module system
 *
 * allows for generic interfaces that attach to .. really, whatever, and can even be embedded
 * without having to deal with copypaste code
 *
 * todo: for now, we just use expected_type and typecast. we want to use pointers in the future.
 *
 * warning: the tgui module system is inherently not cheap to run.
 * you should not expect including too many modules to bode well for performance.
 * if you want fast modules, please, design your own modules, and minimize per-tick data sent.
 * the module system actually allows for full control over sent data.
 *
 * if you're doing anything that will require more than a few modules (hello rigsuits/cyborgs/species),
 * *DO NOT* use the module system as is. make your own synchronization and update system ontop.
 */
/datum/tgui_module
	/// root datum - only one for the moment, sorry
	var/datum/host
	/// tgui module id
	var/tgui_id
	/// expected type
	var/expected_type = /datum

/datum/tgui_module/New(datum/host)
	src.host = host
	if(!istype(host, expected_type))
		CRASH("bad host: [host] not [expected_type] instead [isdatum(host)? host.type : "(not datum)"]")

/datum/tgui_module/Destroy()
	src.host = null
	return ..()

/datum/tgui_module/ui_host(mob/user, datum/tgui_module/module)
	return isnull(host)? src : host.ui_host(user, src)

/datum/tgui_module/ui_close(mob/user, datum/tgui_module/module)
	. = ..()
	host?.ui_close(user, src)

/datum/tgui_module/ui_state(mob/user, datum/tgui_module/module)
	return isnull(host)? ..() : host.ui_state(user, src)

/datum/tgui_module/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	return isnull(host)? ..() : host.ui_status(user, state, src)

/datum/tgui_module/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id)
		ui.open()

/**
 * gets ui static module data; this will always contain
 * list("$tgui" = interfaceID, "$src" = module ref).
 */
/datum/tgui_module/ui_static_data(mob/user)
	. = list()
	.["$tgui"] = tgui_id
	.["$src"] = REF(src)

/**
 * gets ui module data; parameters are variadic
 *
 * @params
 * * user - accessing user
 * * ... - rest of parameters as determined by module
 */
/datum/tgui_module/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state, ...)
	return list()

/**
 * called on module act only when a module **is** operating in standalone mode
 *
 * return TRUE for ui update
 */
/datum/tgui_module/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	return ..()

/**
 * called on module act only when a module **is not** operating in standalone mode
 *
 * return TRUE for ui update
 */
/datum/proc/ui_module_act(action, list/params, datum/tgui_module/module, datum/ui_state/state)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_UI_MODULE_ACT, usr, action, params, module, state)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!module?.ui_status(usr) != UI_INTERACTIVE)
		return TRUE

#warn this is shit

/**
 * called to inject ui module data.
 * they will be handled by a separate reducer to make static data work.
 * you can technically use this for things other than tgui_module's
 * for example, for RIG/other "modular items-in-items" to hold data.
 *
 * this will be sent into data.modules.* instead of just data.*
 *
 * @params
 * * user - user
 * * ui - root tgui module is in
 * * state - ui state
 * * with_static - push static update too?
 */
/datum/proc/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state, with_static)
	return list()


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
 */
/datum/tgui/proc/push_modules(list/updates, force)
	if(isnull(user.client) || !initialized || closing)
		return
	if(!force && status < UI_UPDATE)
		return
	window.send_message("modules", updates)
