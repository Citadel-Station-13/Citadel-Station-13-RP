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
 * todo: there's no way to push custom data at the moment, which makes modules not too advantageous in certain cases.
 *
 * warning: the tgui module system is inherently not cheap to run.
 * you should not expect including too many modules to bode well for performance.
 * if you want fast modules, please, design your own modules, and minimize per-tick data sent.
 * the module system actually allows for full control over sent data, and non /datum/tgui_module modules
 *
 * if you're doing anything that will require more than a few modules (hello rigsuits/cyborgs/species),
 * do not use the module system as is. make your own synchronization and update system ontop.
 */
/datum/tgui_module
	/// root datum - only one for the moment, sorry
	var/datum/host
	/// autodel - register signal to delete with parent, usually used for standalones / modules that behave like components.
	var/autodel = FALSE
	/// ephemeral - qdel on close. *MUST* have autodel to use this.
	var/ephemeral = FALSE
	/// tgui module id - this *must* begin with `TGUI`, e.g. `TGUICardMod`.
	var/tgui_id
	/// expected type
	var/expected_type

/datum/tgui_module/New(datum/host)
	src.host = host
	if(expected_type && !istype(host, expected_type))
		CRASH("bad host: [host] not [expected_type] instead [isdatum(host)? host.type : "(not datum)"]")
	if(autodel && host)
		RegisterSignal(host, COMSIG_PARENT_QDELETING, /datum/tgui_module/proc/on_host_del)
	ASSERT(!ephemeral || autodel)

/datum/tgui_module/Destroy()
	src.host = null
	return ..()

/datum/tgui_module/proc/on_host_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/tgui_module/ui_host(mob/user, datum/tgui_module/module)
	return isnull(host)? src : host.ui_host(user, src)

/datum/tgui_module/ui_close(mob/user, datum/tgui_module/module)
	. = ..()
	host?.ui_close(user, src)
	if(ephemeral)
		qdel(src)

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
 * called directly, if operating standalone. routes to static_data(user), with all other args skipped.
 */
/datum/tgui_module/ui_static_data(mob/user)
	return static_data(user)

/**
 * called directly, if operating standalone. routes to data(user), with all other args skipped.
 */
/datum/tgui_module/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return data(user)

/**
 * called directly, if operating standalone.
 */
/datum/tgui_module/ui_act(action, list/params, datum/tgui/ui)
	// we only override this to provide comment
	// yes yes proc overhead sue me it's called like 10k times a round, tops.
	return ..()

/**
 * returns static module data
 */
/datum/tgui_module/proc/static_data(mob/user, ...)
	return list(
		"$tgui" = tgui_id,
		"$src" = REF(src),
	)

/**
 * returns module data
 */
/datum/tgui_module/proc/data(mob/user, ...)
	return list()

/**
 * route a received ui_act for module handling
 * remember that $id, $ref in params corrosponds to module id, module ref.
 *
 * we use id instead of module to prevent potential security issues down the line.
 */
/datum/proc/ui_module_route(action, list/params, datum/tgui/ui, id)
	if(!id)
		// no id?
		// i know that guy!
		// it's me!
		return ui_act(action, params, ui)
	// it's not us, respect overrides that wish to hook module behavior
	if(ui_module_act(action, params, ui, id))
		return TRUE

/**
 * called as a hook for intercepting ui acts from a module
 * remember that $id, $ref in params corrosponds to module id, module ref.
 * we don't provide $ref directly for security reasons.
 * you can use it if you know what you're doing.
 *
 * this is an advanced proc.
 * the module's ui_status() is *not* checked for you in ..()!
 *
 * return TRUE for ui update + prevent propagation to the module
 */
/datum/proc/ui_module_act(action, list/params, datum/tgui/ui, id)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_UI_MODULE_ACT, usr, id, action, params, ui)

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
 */
/datum/proc/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return list()

/**
 * called to inject ui module static data.
 * they will be handled by a separate reducer to make static data work.
 * you can technically use this for things other than tgui_module's
 * for example, for RIG/other "modular items-in-items" to hold data.
 *
 * this will be sent into data.modules[id].* instead of just data.*
 *
 * @params
 * * user - user
 * * ui - root tgui module is in
 * * state - ui state
 */
/datum/proc/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
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
