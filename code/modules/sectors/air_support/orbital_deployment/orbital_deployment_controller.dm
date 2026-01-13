//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

CREATE_WALL_MOUNTING_TYPES_SHIFTED_AUTOSPRITE(/obj/machinery/orbital_deployment_controller, 28, "controller")
/obj/machinery/orbital_deployment_controller
	name = "orbital deployment controller"
	desc = "A controller for an orbital base deployment system."
	icon = 'icons/modules/sectors/air_support/orbital_deployment_controller.dmi'
	icon_state = "controller"
	base_icon_state = "controller"

	//* Init *//
	/// search radius for orbital deployment markers (zones)
	var/linkage_search_radius = 10
	// TODO: `linkage_set_id` overrides all of the above for advanced uses, see /zone_tagger

	//* Linkage *//
	/// Our linked zone
	var/datum/orbital_deployment_zone/linked_zone

	//* UI *//
	var/ui_last_signal_refresh

/obj/machinery/orbital_deployment_controller/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/orbital_deployment_controller/Destroy()
	unlink_zone()
	return ..()

/obj/machinery/orbital_deployment_controller/LateInitialize()
	find_zone()

/obj/machinery/orbital_deployment_controller/proc/find_zone()
	var/datum/orbital_deployment_zone/found
	for(var/id in GLOB.orbital_deployment_zones)
		var/datum/orbital_deployment_zone/zone = GLOB.orbital_deployment_zones[id]
		for(var/obj/orbital_deployment_marker/corner/corner as anything in zone.get_corners())
			if(get_dist(corner, src) < linkage_search_radius)
				found = zone
				break
	if(!found)
		CRASH("[src] ([COORD(src)]) couldn't find an orbital deployment zone.")
	link_zone(found)

/obj/machinery/orbital_deployment_controller/proc/link_zone(datum/orbital_deployment_zone/zone)
	if(linked_zone)
		if(linked_zone == zone)
			return TRUE
		unlink_zone()
	linked_zone = zone
	LAZYADD(linked_zone.controllers, src)
	update_static_data()
	return TRUE

/obj/machinery/orbital_deployment_controller/proc/unlink_zone()
	if(!linked_zone)
		return TRUE
	LAZYREMOVE(linked_zone.controllers, src)
	linked_zone = null
	update_static_data()
	return TRUE

/obj/machinery/orbital_deployment_controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/OrbitalDeploymentController")
		ui.open()

/obj/machinery/orbital_deployment_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["zone"] = linked_zone ? list(
		"arming" = linked_zone.arming,
		"armingLast" = linked_zone.arming_last_toggle,
	) : null
	.["armingTime"] = linked_zone.arming_time
	.["armingCooldown"] = linked_zone.arming_cooldown
	.["maxOvermapPixelDist"] = OVERMAP_PIXEL_TO_DIST(linked_zone.max_overmap_pixel_dist)
	. += ui_signal_data()

/obj/machinery/orbital_deployment_controller/proc/ui_signal_data()
	. = list()

	var/obj/overmap/entity/our_overmap_entity = get_overmap_sector(src)
	var/list/assembled_lasers = list()
	var/list/assembled_flares = list()

	if(our_overmap_entity)
		var/list/obj/overmap/entity/overmap_query_results = SSovermaps.entity_pixel_dist_query(our_overmap_entity, linked_zone.max_overmap_pixel_dist)
		for(var/obj/overmap/entity/entity_in_range as anything in overmap_query_results)
			if(!isturf(entity_in_range.loc))
				// if they're nested, skip; they're docked.
				continue
			var/overmap_distance = entity_in_range.entity_overmap_distance(our_overmap_entity)
			// TODO: overmaps sensor update
			var/overmap_name = entity_in_range.name
			for(var/z in entity_in_range.location?.get_z_indices())
				var/list/atom/movable/laser_designator_target/lasers = SSmap_sectors.laser_designation_query(z)
				var/list/obj/item/signal_flare/flares = SSmap_sectors.signal_flare_query(z)

				for(var/atom/movable/laser_designator_target/laser as anything in lasers)
					// TODO: better name identification
					assembled_lasers[++assembled_lasers.len] = list(
						"name" = "targeting laser",
						"coords" = SSmapping.get_virtual_coords_x_y_elevation(get_turf(laser)),
						"overmapDist" = overmap_distance,
						"overmapName" = overmap_name,
					)
				for(var/obj/item/signal_flare/flare as anything in flares)
					// TODO: better name identification
					assembled_flares[++assembled_flares.len] = list(
						"name" = "signal flare",
						"coords" = SSmapping.get_virtual_coords_x_y_elevation(get_turf(flare)),
						"overmapDist" = overmap_distance,
						"overmapName" = overmap_name,
					)

	.["lasers"] = assembled_lasers
	.["flares"] = assembled_flares

/obj/machinery/orbital_deployment_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("refreshSignals")
			if(!linked_zone)
				return TRUE
			if(world.time < ui_last_signal_refresh + 5 SECONDS)
				return TRUE
			ui_last_signal_refresh = world.time
			push_ui_data(data = ui_signal_data())
			return TRUE
		if("arm")
			if(!linked_zone)
				return TRUE
			if(linked_zone.arming_cooldown > world.time - linked_zone.arming_last_toggle)
				return TRUE
			linked_zone.arm()
			log_orbital_deployment(actor, "armed zone with controller at [COORD(src)]")
			actor.visible_feedback(
				target = src,
				visible = SPAN_WARNING("[actor.performer] presses a button on [src]. Mechanical sounds permeate the air as hydraulics come to life."),
				audible = SPAN_WARNING("You hear the mechanical sounds of hydraulics coming to life."),
			)
			return TRUE
		if("disarm")
			if(!linked_zone)
				return TRUE
			if(linked_zone.arming_cooldown > world.time - linked_zone.arming_last_toggle)
				return TRUE
			linked_zone.disarm()
			actor.visible_feedback(
				target = src,
				visible = SPAN_WARNING("[actor.performer] presses a button on [src]. Nearby machinery slows to a stop as the system is disarmed."),
				audible = SPAN_WARNING("You hear heavy hydraulics slow to a stop."),
			)
			log_orbital_deployment(actor, "armed zone with controller at [COORD(src)]")
			return TRUE
		if("launch")
			if(!linked_zone)
				return TRUE
			if(linked_zone.time_to_armed() > 0)
				return TRUE
			var/atom/movable/target_ref
			if(params["targetType"] == "laser")
				var/atom/movable/laser_designator_target/dangerously_unchecked_target = locate(params["targetRef"])
				if(!istype(dangerously_unchecked_target))
					return TRUE
				if(!check_target_laser_validity(dangerously_unchecked_target))
					return TRUE
				target_ref = dangerously_unchecked_target
			else if(params["targetType" == "flare"])
				var/obj/item/signal_flare/dangerously_unchecked_target = locate(params["targetRef"])
				if(!istype(dangerously_unchecked_target))
					return TRUE
				if(!check_target_flare_validity(dangerously_unchecked_target))
					return TRUE
				target_ref = dangerously_unchecked_target
			var/turf/target_center = get_turf(target_ref)
			var/dir_from_north = params["dir"]
			var/list/out_warnings = list()
			var/list/out_errors = list()
			if(!linked_zone.check_zone(target_center, dir_from_north, out_warnings, out_errors))
				return TRUE
			// TODO: emit warnings / errors as spoken output?
			if(length(out_errors))
				return TRUE
			linked_zone.launch(target_center, dir_from_north, actor = actor)
			return TRUE

/obj/machinery/orbital_deployment_controller/proc/check_target_laser_validity(atom/movable/laser_designator_target/target)
	if(!isturf(target.loc))
		return
	return SSmap_sectors.is_turf_visible_from_high_altitude(target.loc)

/obj/machinery/orbital_deployment_controller/proc/check_target_flare_validity(obj/item/signal_flare/flare)
	if(!isturf(flare.loc))
		return
	return flare.ready
