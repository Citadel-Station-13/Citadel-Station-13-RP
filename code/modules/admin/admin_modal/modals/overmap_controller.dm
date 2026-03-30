//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/overmap_controller
	var/obj/overmap/entity/target
	tgui_interface = "OvermapController"

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

	if(istype(target.location, /datum/overmap_location/shuttle))
		switch(action)
			if("openShuttleController")

	switch(action)
		if("setVel")
		if("setPos")
		if("yankToHere")
		if("narrate")

#warn impl
