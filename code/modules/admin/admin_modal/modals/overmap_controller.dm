//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/overmap_controller
	tgui_interface = "OvermapController"
	var/obj/overmap/entity/target
	var/datum/secondary_map/target_renderer

/datum/admin_modal/overmap_controller/Initialize(obj/overmap/entity/target)
	if(!istype(target))
		return FALSE
	src.target = target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_del))
	for(var/datum/admin_modal/overmap_controller/other in owner.admin_modals)
		if(other == src)
			continue
		if(other.target == src.target)
			return FALSE
	target_renderer = new /datum/secondary_map/follow_entity_with_radius(target, 2)
	return TRUE

/datum/admin_modal/overmap_controller/Destroy()
	target = null
	QDEL_NULL(target_renderer)
	return ..()

/datum/admin_modal/overmap_controller/on_ui_open(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.grant_to_user(user)

/datum/admin_modal/overmap_controller/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.revoke_from_user(user)

/datum/admin_modal/overmap_controller/proc/on_target_del()
	qdel(src)

#warn ui

/datum/admin_modal/overmap_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["vx"] = target.vel_x / OVERMAP_DISTANCE_PIXEL
	.["vY"] = target.vel_y / OVERMAP_DISTANCE_PIXEL
	.["pX"] = target.pos_x / OVERMAP_DISTANCE_PIXEL
	.["pY"] = target.pos_y / OVERMAP_DISTANCE_PIXEL

/datum/admin_modal/overmap_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["name"] = target.name
	.["mapRef"] = target_renderer?.map_id

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
			var/set_x = params["vx"]
			var/set_y = params["vy"]
			if(!isnum(set_x) || !isnum(set_y))
				return TRUE
			target.set_velocity(set_x * OVERMAP_DISTANCE_PIXEL, set_y * OVERMAP_DISTANCE_PIXEL)
			return TRUE
		if("jumpTo")
			#warn impl; adminjump?
			return TRUE
		if("yankToHere")
			var/mob/their_mob = admin_holder.owner?.mob
			if(!their_mob)
				return TRUE
			// no yanking off the overmap!
			if(!istype(their_mob.loc?.loc, /area/overmap))
				return TRUE
			var/pixloc/use = their_mob.pixloc
			if(!use)
				return TRUE
			target.force_move_p(use)
			return TRUE
		if("narrate")
			// special behavior; target shuttle specifically
			// rather than overmap entity if it's a shuttle
			admin_holder.open_admin_modal(/datum/admin_modal/admin_narrate, target)
			return TRUE
