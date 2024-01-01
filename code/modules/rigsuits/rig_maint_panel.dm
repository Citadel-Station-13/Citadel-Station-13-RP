//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * separate maintenance handler from main rig interface
 */
/datum/rig_maint_panel
	/// owner
	var/obj/item/rig/host

/datum/rig_maint_panel/New(obj/item/rig/rig)
	src.host = rig

/datum/rig_maint_panel/Destroy()
	src.host = null
	return ..()

/datum/rig_maint_panel/ui_host()
	return host

/datum/rig_maint_panel/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/rig_maint_panel/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/rig_maint_panel/ui_static_modules(mob/user, datum/tgui/ui)
	. = ..()

/datum/rig_maint_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/rig_maint_panel/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()

/datum/rig_maint_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RigsuitMaintenance")
		ui.open()

#warn impl all
