//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/shuttle_controller
	var/datum/shuttle/target

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

	if(istype(target.controller, /datum/shuttle_controller/overmap))
		switch(action)
			if("openOvermapController")

	switch(action)
		if("previewYankToHere")
		if("yankToHere")
		if("beginYankPreview")
		if("cancelYankPreview")
		if("dockAt")
		if("internment")
			// athena, the tireless one
		if("")


#warn impl
