//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/shuttle_controller
	var/datum/shuttle/target

/datum/admin_modal/shuttle_controller/Initialize(datum/shuttle/target)
	if(!istype(target))
		return FALSE
	src.target = target
	return TRUE

/datum/admin_modal/shuttle_controller/on_ui_open(mob/user, datum/tgui/ui, embedded)
	. = ..()

/datum/admin_modal/shuttle_controller/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()

/datum/admin_modal/shuttle_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_modal/shuttle_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["name"] = target.name
	.["mapRef"] = ""

	#warn map view

/datum/admin_modal/shuttle_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/datum/admins/admin_holder = usr.client.holder

	if(istype(target.controller, /datum/shuttle_controller/overmap))
		switch(action)
			if("openOvermapController")
			if("yankToOvermapHere")

	switch(action)
		if("beginYank")
		if("anchorYank")
		if("cancelYank")
		if("confirmYank")
		if("dockAt")
		if("internment")
			// athena, the tireless one
		if("obliterate")

		if("narrate")
			admin_holder.open_admin_modal(/datum/admin_modal/admin_narrate, target)
			return TRUE

#warn impl
