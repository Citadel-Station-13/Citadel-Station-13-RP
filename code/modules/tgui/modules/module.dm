/**
 * new, more-modular tgui_module system
 *
 * allows for generic interfaces that attach to .. really, whatever, and can even be embedded
 * without having to deal with copypaste code
 */
/datum/tgui_module
	/// root datum - only one for the moment, sorry
	var/datum/host
	/// tgui module id
	var/tgui_id

/datum/tgui_module/New(datum/host)
	src.host = host

/datum/tgui_module/Destroy()
	src.host = null
	return ..()

#warn impl

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
	. = ui_data(user)
	.["tgui"] = tgui_id
	.["src"] = REF(src)

/datum/tgui_module/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return list()
