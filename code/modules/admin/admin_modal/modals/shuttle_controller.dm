//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/shuttle_controller
	var/datum/shuttle/target
	var/datum/secondary_map/render_entire_shuttle/target_renderer

/datum/admin_modal/shuttle_controller/Initialize(datum/shuttle/target)
	if(!istype(target))
		return FALSE
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_target_del))
	src.target = target
	for(var/datum/admin_modal/shuttle_controller/other in owner.admin_modals)
		if(other == src)
			continue
		if(other.target == src.target)
			return FALSE
	target_renderer = new /datum/secondary_map/render_entire_shuttle(target)
	return TRUE

/datum/admin_modal/shuttle_controller/Destroy()
	target = null
	QDEL_NULL(target_renderer)
	return ..()

/datum/admin_modal/shuttle_controller/on_target_del()
	qdel(src)

#warn ui

/datum/admin_modal/shuttle_controller/on_ui_open(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.grant_to_user(user)

/datum/admin_modal/shuttle_controller/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.revoke_from_user(user)

/datum/admin_modal/shuttle_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_modal/shuttle_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["name"] = target.name
	.["mapRef"] = target_renderer?.map_id

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
