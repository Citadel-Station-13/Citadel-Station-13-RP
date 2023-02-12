/**
 * new, more-modular tgui_module system
 *
 * allows for generic interfaces that attach to .. really, whatever, and can even be embedded
 * without having to deal with copypaste code
 *
 * todo: for now, we just use expected_type and typecast. we want to use pointers in the future.
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

/datum/tgui_module/ui_host(mob/user)
	return isnull(host)? src : host

/datum/tgui_module/ui_close(mob/user, datum/tgui_module/module)
	. = ..()
	host?.ui_close(user, src)

/datum/tgui_module/ui_state(mob/user, datum/tgui_module/module)
	return isnull(host)? ..() : host.ui_state(user, src)

//? ui status does not need to be overridden.

/datum/tgui_module/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	SHOULD_NOT_OVERRIDE(TRUE) // nuh uh you do not get to mess with this call on subtypes
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id)
		ui.module = TRUE
		ui.open()

// todo: "better" (more expensive) reducer that allows one-layer-deep-nested, for now we send ui data too

/datum/tgui_module/ui_static_data(mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = ui_module_data(user)
	.["tgui"] = tgui_id
	.["src"] = REF(src)

/datum/tgui_module/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	SHOULD_NOT_OVERRIDE(TRUE)
	return ui_static_data(user)

/**
 * gets ui module data; parameters are variadic
 *
 * @params
 * * user - accessing user
 * * ... - rest of parameters as determined by module
 */
/datum/tgui_module/proc/ui_module_data(mob/user, ...)
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
	SEND_SIGNAL(src, COMSIG_UI_MODULE_ACT, usr, action, params, ui, state)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!module?.ui_status(usr) != UI_INTERACTIVE)
		return TRUE
