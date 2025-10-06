//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Modal *//

/**
 * Base type of admin modals, which tend to be standalone panels.
 */
VV_PROTECT_READONLY(/datum/admin_modal)
/datum/admin_modal
	/// Our name, for UI / output purposes
	var/name = "Unknown Modal"
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

// TODO: don't destroy if it's part of a disconnect, restore after?
/datum/admin_modal/on_ui_close(mob/user, datum/tgui/ui, embedded)
	..()
	qdel(src)

/**
 * Just a wrapper for opening our UI. Ensures everything is initialized.
 */
/datum/admin_modal/proc/open()
	if(!initialized)
		CRASH("attempted to open an uninitialized admin modal")
	if(!owner?.owner?.mob)
		return
	ui_interact(owner.owner.mob)

/**
 * Called with args to open_admin_modal().
 */
/datum/admin_modal/proc/Initialize(...)
	initialized = TRUE
	return TRUE

/**
 * Call to complain about a failure in doing something.
 *
 * * Failures should generally be done UI-side, this is for when something is seriously wrong.
 */
/datum/admin_modal/proc/loud_rejection(message)
	// todo: make this fancier
	to_chat(owner.owner, "<font color='red'><b>[name]</b>: [message]</font>")

