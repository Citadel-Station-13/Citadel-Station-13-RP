//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/overmap_controller
	var/obj/overmap/entity/target
	tgui_interface = "OvermapController"

#warn ui

/datum/admin_modal/overmap_controller/Initialize(obj/overmap/entity/target)
	if(!istype(target))
		return FALSE
	src.target = target
	for(var/datum/admin_modal/overmap_controller/other in owner.admin_modals)
		if(other == src)
			continue
		if(other.target == src.target)
			return FALSE
	return TRUE

/datum/admin_modal/overmap_controller/on_ui_open(mob/user, datum/tgui/ui, embedded)
	. = ..()

/datum/admin_modal/overmap_controller/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()


/datum/admin_modal/overmap_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["vx"] = target.vel_x / OVERMAP_DISTANCE_PIXEL
	.["vY"] = target.vel_y / OVERMAP_DISTANCE_PIXEL
	.["pX"] = target.pos_x / OVERMAP_DISTANCE_PIXEL
	.["pY"] = target.pos_y / OVERMAP_DISTANCE_PIXEL

/datum/admin_modal/overmap_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["name"] = target.name
	#warn secondary map
	.["mapRef"] = ""

	if(target.location)
		if(istype(target.location, /datum/overmap_location/shuttle))
			.["location"] = list(
				"type" = "shuttle",
			)
		if(istype(target.location, /datum/overmap_location/map))
			.["location"] = list(
				"type" = "map",
			)
	else
		.["location"] = null

/datum/admin_modal/overmap_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/datum/admins/admin_holder = usr.client.holder

	if(istype(target.location, /datum/overmap_location/shuttle))
		var/datum/overmap_location/shuttle/casted_location = target.location
		switch(action)
			if("openShuttleController")
				admin_holder.open_admin_modal(/datum/admin_modal/shuttle_controller, casted_location.shuttle)
				return TRUE

	switch(action)
		if("setVel")
		if("setPos")
		if("yankToHere")
		if("narrate")
			// special behavior; target shuttle specifically
			// rather than overmap entity if it's a shuttle
		if("halt")
		if("unhalt")

#warn impl
