//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * permissions panel for rigs
 */
/datum/rig_auth_panel
	/// owner
	var/obj/item/rig/host

/datum/rig_auth_panel/New(obj/item/rig/rig)
	src.host = rig

/datum/rig_auth_panel/Destroy()
	src.host = null
	return ..()

/datum/rig_auth_panel/ui_host(mob/user)
	return host

/datum/rig_auth_panel/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn icecream update will modify this, check the root definition!

/datum/rig_auth_panel/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn icecream update will modify this, check the root definition!

/datum/rig_auth_panel/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn icecream update will modify this, check the root definition!

/datum/rig_auth_panel/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn icecream update will modify this, check the root definition!

/datum/rig_auth_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/rig_auth_panel/ui_module_act(action, list/params, datum/tgui/ui, id)
	. = ..()
	#warn icecream update will modify this, check the root definition!

/datum/rig_auth_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	#warn icecream update will modify this, check the root definition!
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RigsuitMaintenance")
		ui.open()

#warn impl all
