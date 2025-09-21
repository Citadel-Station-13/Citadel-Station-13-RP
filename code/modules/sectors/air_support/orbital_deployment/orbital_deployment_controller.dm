//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/orbital_deployment_controller
	//* Init *//
	/// search radius for orbital deployment markers (zones)
	///
	/// * we throw an error if multiple are found
	var/linkage_search_radius = 10
	/// search direction; only cardinals
	var/linkage_search_dirs = NORTH | SOUTH | EAST | WEST
	// TODO: `linkage_set_id` overrides all of the above for advanced uses, see /zone_tagger

	//* Config *//
	/// minimum armed time before launch
	var/conf_minimum_arming_time = 10 SECONDS
	/// max overmap bounds dist we can launch at
	var/conf_max_overmap_pixel_dist = WORLD_ICON_SIZE * 3

	//* State *//
	/// armed?
	var/s_armed = FALSE

/obj/machinery/orbital_deployment_controller/Initialize(mapload)
	. = ..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/orbital_deployment_controller/LateInitialize()

#warn impl

/obj/machinery/orbital_deployment_controller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/orbital_deployment_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/orbital_deployment_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["sArmed"] = s_armed
	.["cMinArmingTime"] = conf_minimum_arming_time
	.["cMaxOvermapsDist"] = OVERMAP_PIXEL_TO_DIST(conf_max_overmap_pixel_dist)
	. += ui_signal_data()

/obj/machinery/orbital_deployment_controller/proc/ui_signal_data()
	. = list()

	var/obj/overmap/entity/our_overmap_entity = get_overmap_sector(src)
	var/list/assembled_lasers = list()
	var/list/assembled_flares = list()

	if(our_overmap_entity)
		var/list/obj/overmap/entity/overmap_query_results = SSovermaps.entity_pixel_dist_query(our_overmap_entity, conf_max_overmap_pixel_dist)
		for(var/obj/overmap/entity/entity_in_range as anything in overmap_query_results)
			if(!istype(entity_in_range, /obj/overmap/entity/visitable))
				continue
			var/obj/overmap/entity/visitable/visitable = entity_in_range
			for(var/z in visitable.map_z)
				var/list/atom/movable/laser_designator_target/lasers = SSmap_sectors.laser_designation_query(z)
				var/list/obj/item/signal_flare/flares = SSmap_sectors.signal_flare_query(z)

				for(var/atom/movable/laser_designator_target/laser as anything in lasers)
					assembled_lasers[++assembled_lasers.len] = list(
					)
					#warn impl
				for(var/obj/item/signal_flare/flare as anything in flares)
					assembled_flares[++assembled_flares.len] = list(
					)
					#warn impl

	.["lasers"] = assembled_lasers
	.["flares"] = assembled_flares


/obj/machinery/orbital_deployment_controller/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("refreshSignals")
			#warn throttle
			push_ui_data(data = ui_signal_data())
			return TRUE
		if("arm")
			#warn impl
		if("disarm")
			#warn impl
		if("launch")
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
			#warn impl

/obj/machinery/orbital_deployment_controller/proc/check_target_laser_validity(atom/movable/laser_designator_target/target)
	if(!isturf(target.loc))
		return
	return SSmap_sectors.is_turf_visible_from_high_altitude(target.loc)

/obj/machinery/orbital_deployment_controller/proc/check_target_flare_validity(obj/item/signal_flare/flare)
	if(!isturf(flare.loc))
		return
	return flare.ready
