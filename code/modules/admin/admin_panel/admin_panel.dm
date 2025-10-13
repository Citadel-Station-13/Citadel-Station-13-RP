//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Panel *//

/**
 * Base type of admin panels, which tend to be standalone panels.
 * * Unlike `/datum/admin_modal`, panels aren't deleted on close, and are more stateful long-term things.
 */
VV_PROTECT_READONLY(/datum/admin_panel)
/datum/admin_panel
	/// Our name, for UI / output purposes
	var/name = "Unknown Panel"
	/// The admin datum we belong to
	var/datum/admins/owner
	/// TGUI ID; this will always be loaded from `tgui/interfaces/admin_panel` if possible.
	var/tgui_interface

/datum/admin_panel/New(datum/admins/for_owner)
	owner = for_owner
	LAZYSET(owner.admin_panels, type, src)

/datum/admin_panel/Destroy()
	LAZYREMOVE(owner.admin_panels, type)
	return ..()

/datum/admin_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "admin_panel/[tgui_interface]")
		ui.open()

/datum/admin_panel/ui_state()
	return GLOB.ui_admin_panel_state

/**
 * Just a wrapper for opening our UI. Ensures everything is initialized.
 */
/datum/admin_panel/proc/open()
	if(!owner?.owner?.mob)
		return
	ui_interact(owner.owner.mob)

/**
 * Call to complain about a failure in doing something.
 *
 * * Failures should generally be done UI-side, this is for when something is seriously wrong.
 */
/datum/admin_panel/proc/loud_rejection(message)
	// todo: make this fancier
	to_chat(owner.owner, "<font color='red'><b>[name]</b>: [message]</font>")
