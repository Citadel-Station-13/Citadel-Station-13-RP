//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: throw this file out and rethink this again; this is not the way to go.

/**
 * new, more-modular tgui_module system
 *
 * allows for generic interfaces that attach to .. really, whatever, and can even be embedded
 * without having to deal with copypaste code
 *
 * warning: the tgui module system is inherently not cheap to run.
 * you should not expect including too many modules to bode well for performance.
 * if you want fast modules, please, design your own modules, and minimize per-tick data sent.
 * the module system actually allows for full control over sent data, and non /datum/tgui_module modules
 *
 * if you're doing anything that will require more than a few modules (hello rigsuits/cyborgs/species),
 * do not use the module system as is. make your own synchronization and update system ontop.
 *
 * /datum/tgui_module is just one implementation of modules.
 * the $tgui and $src data keys are actually what powers a module.
 * you can make your own module system utilzing that, and hooking things like ui_module_route.
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
		RegisterSignal(host, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/tgui_module, on_host_del))
	ASSERT(!ephemeral || autodel)

/datum/tgui_module/Destroy()
	src.host = null
	return ..()

/datum/tgui_module/proc/on_host_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/tgui_module/ui_host()
	return isnull(host)? src : host.ui_host()

/datum/tgui_module/on_ui_close(mob/user, datum/tgui/ui, embedded)
	..()
	if(ephemeral)
		qdel(src)

/datum/tgui_module/ui_state()
	return isnull(host)? ..() : host.ui_state()

/datum/tgui_module/ui_status(mob/user, datum/ui_state/state)
	return isnull(host)? ..() : host.ui_status(user, state, src)

/datum/tgui_module/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id)
		ui.open()

/**
 * called directly, if operating standalone. routes to static_data(user), with all other args skipped.
 */
/datum/tgui_module/ui_static_data(mob/user, datum/tgui/ui)
	return static_data(user)

/**
 * called directly, if operating standalone. routes to data(user), with all other args skipped.
 */
/datum/tgui_module/ui_data(mob/user, datum/tgui/ui)
	return data(user)

/**
 * called directly, if operating standalone.
 */
/datum/tgui_module/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
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
