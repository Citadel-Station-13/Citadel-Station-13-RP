//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_DATUM_INIT(ui_admin_modal_state, /datum/ui_state/admin_modal_state, new)

/datum/ui_state/admin_modal_state/can_use_topic(src_object, mob/user)
	. = ..()
	#warn impl

/**
 * Base type of admin modals, which tend to be standalone panels.
 */
/datum/admin_modal
	/// The admin datum that opened us
	var/datum/admins/owner
	/// TGUI ID; this will always be loaded from `tgui/interfaces/admin_modal` if possible.
	var/tgui_interface
	/// Do we autoupdate?
	var/tgui_update = TRUE
	/// are we initialized?
	var/initialized = FALSE

/datum/admin_modal/New(datum/admins/for_owner)
	owner = for_owner
	LAZYADD(owner.admin_modals, src)

/datum/admin_modal/Destroy()
	LAZYREMOVE(owner.admin_modals, src)
	return ..()

/datum/admin_modal/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "admin_modal/[tgui_interface]")
		ui.set_autoupdate(tgui_update)
		ui.open()

/datum/admin_modal/ui_state()
	return GLOB.ui_admin_modal_state

/**
 * Just a wrapper for opening our UI. Ensures everything is initialized.
 */
/datum/admin_modal/proc/open()
	if(!initialized)
		if(!Initialize())
			return
		initialized = TRUE
	#warn impl

/datum/admin_modal/proc/Initialize()
	return

/**
 * Call to complain about a failure in doing something.
 */
/datum/admin_modal/proc/loud_rejection(message)
	#warn impl
