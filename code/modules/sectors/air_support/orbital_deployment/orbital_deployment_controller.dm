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
	var/ui_signal_refresh_throttle = 3 SECONDS

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

/obj/machinery/orbital_deployment_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["refreshOnCooldown"] = world.time < (ui_last_signal_refresh + ui_signal_refresh_throttle)
	.["zone"] = linked_zone ? list(
		"armed" = linked_zone.is_armed(),
		"arming" = linked_zone.arming,
		"armToggleOnCooldown" = world.time < (linked_zone.arming_last_toggle + linked_zone.arming_cooldown),
		"launchOnCooldown" = world.time < linked_zone.launch_next_ready_time,
		"maxOvermapPixelDist" = OVERMAP_PIXEL_TO_DIST(linked_zone.max_overmap_pixel_dist),
	) : null

/obj/machinery/orbital_deployment_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	. += ui_signal_data()

/obj/machinery/orbital_deployment_controller/proc/ui_signal_data()
	. = list()

	var/obj/overmap/entity/our_overmap_entity = get_overmap_sector(src)
	var/list/assembled_signals = list()

	if(our_overmap_entity && linked_zone)
		var/list/obj/overmap/entity/overmap_query_results = SSovermaps.entity_pixel_dist_query(our_overmap_entity, linked_zone.max_overmap_pixel_dist)
		for(var/obj/overmap/entity/entity_in_range as anything in overmap_query_results)
			if(entity_in_range == our_overmap_entity && !linked_zone.can_target_self_entity)
				continue
			if(!isturf(entity_in_range.loc))
				// if they're nested, skip; they're docked.
				continue
			var/overmap_distance = entity_in_range.get_center_px_dist(our_overmap_entity)
			// TODO: overmaps sensor update
			var/overmap_name = entity_in_range.name
			for(var/z in entity_in_range.location?.get_z_indices())
				var/list/datum/component/high_altitude_signal/signals = SSmap_sectors.high_altitude_signal_query(z)
				for(var/datum/component/high_altitude_signal/signal as anything in signals)
					var/turf/effective_turf = signal.get_effective_turf()
					if(!effective_turf)
						continue
					// TODO: better name identification
					assembled_signals[++assembled_signals.len] = list(
						"ref" = ref(signal),
						"name" = signal.visible_name,
						"coords" = SSmapping.get_virtual_coords_x_y_elevation(effective_turf),
						"overmapDist" = overmap_distance,
						"overmapName" = overmap_name,
					)

	.["signals"] = assembled_signals

/obj/machinery/orbital_deployment_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("refreshSignals")
			if(!linked_zone)
				return TRUE
			if(world.time < (ui_last_signal_refresh + ui_signal_refresh_throttle))
				return TRUE
			ui_last_signal_refresh = world.time
			push_ui_data(data = ui_signal_data())
			return TRUE
		if("arm")
			if(!linked_zone)
				return TRUE
			if(linked_zone.arming)
				return TRUE
			if((world.time - linked_zone.arming_last_toggle) < linked_zone.arming_cooldown)
				return TRUE
			linked_zone.arm()
			log_orbital_deployment(actor, "armed zone with controller at [COORD(src)]")
			actor.visible_feedback(
				target = src,
				visible = span_warning("[actor.performer] presses a button on [src]. Mechanical sounds permeate the air as hydraulics come to life."),
				audible = span_warning("You hear the mechanical sounds of hydraulics coming to life."),
			)
			return TRUE
		if("disarm")
			if(!linked_zone)
				return TRUE
			if(!linked_zone.arming)
				return TRUE
			if((world.time - linked_zone.arming_last_toggle) < linked_zone.arming_cooldown)
				return TRUE
			linked_zone.disarm()
			actor.visible_feedback(
				target = src,
				visible = span_warning("[actor.performer] presses a button on [src]. Nearby machinery slows to a stop as the system is disarmed."),
				audible = span_warning("You hear heavy hydraulics slow to a stop."),
			)
			log_orbital_deployment(actor, "armed zone with controller at [COORD(src)]")
			return TRUE
		if("launch")
			if(!linked_zone)
				return TRUE
			if(linked_zone.time_to_armed() > 0)
				return TRUE
			if(linked_zone.launch_next_ready_time > world.time)
				return TRUE
			var/datum/component/high_altitude_signal/signal_ref
			do
				var/datum/component/high_altitude_signal/dangerously_unchecked_target = locate(params["targetRef"])
				if(!istype(dangerously_unchecked_target))
					return TRUE
				signal_ref = dangerously_unchecked_target
			while(FALSE)
			if(!signal_ref.is_active())
				return TRUE
			var/turf/target_center = signal_ref.get_effective_turf()
			if(!target_center)
				return TRUE
			var/dir_from_north = params["dir"]
			// TODO: we should probably care about warnings?? the UI should show them and update automatically...
			var/list/out_warnings = list()
			var/list/out_errors = list()
			var/pass = TRUE
			if(!linked_zone.check_zone(target_center, dir_from_north, out_warnings, out_errors))
				pass = FALSE
			if(length(out_errors))
				pass = FALSE
			if(!pass)
				linked_zone.arming_last_toggle = world.time - max(0, linked_zone.arming_time - linked_zone.arming_cooldown)
				atom_say("Could not launch - [english_list(out_errors)].")
				return TRUE
			linked_zone.launch(target_center, dir_from_north, actor = actor)
			return TRUE
