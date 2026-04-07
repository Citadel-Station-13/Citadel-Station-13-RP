//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Shuttle manipulation panel
 *
 * * Allows high-level overview of all shuttles
 * * Allows opening a shuttle's controller
 * * Allows spawning and creating new shuttle templates
 */
/datum/admin_panel/shuttle_manipulator
	name = "Shuttle Manipulator"
	tgui_interface = "AdminShuttleManipulator"

#warn impl

/datum/admin_panel/shuttle_manipulator/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/shuttle_manipulator/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/shuttle_manipulator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/datum/admins/admin_holder = usr.client.holder
	var/shuttle_id = params["shuttleId"]
	var/datum/shuttle/shuttle = shuttle_id && SSshuttles.shuttle_lookup[shuttle_id]

	switch(action)
		if("openShuttleController")
			#warn impl
		if("refresh")
			#warn impl
		if("instantiateTemplate")
			#warn impl
		if("uploadTemplate")
			admin_holder.open_admin_modal(/datum/admin_modal/upload_shuttle_template)
			return TRUE
