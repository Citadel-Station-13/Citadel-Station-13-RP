//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_EMPTY(admin_panels_by_type)

/**
 * for iterating through all open admin panels of a type
 *
 * usually used to push updates to static data
 */
/proc/open_admin_panels_of_type(typepath)
	#warn impl

/datum/admin_panel
	abstract_type = /datum/admin_panel

	/// TGUI interface ID
	var/tgui_interface

/datum/admin_panel/New()
	LAZYADD(GLOB.admin_panels_by_type[type], src)

/datum/admin_panel/Destroy()
	LAZYREMOVE(GLOB.admin_panels_by_type[type], src)
	return ..()

/datum/admin_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/admin_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/admin_panel/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/admin_panel/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/admin_panel/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	. = ..()

/datum/admin_panel/ui_state(mob/user, datum/tgui_module/module)
	. = ..()

#warn impl all
