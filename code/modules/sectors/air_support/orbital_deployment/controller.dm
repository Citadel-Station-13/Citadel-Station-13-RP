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

	var/list/atom/movable/laser_designator_target/lasers
	var/list/assembled_lasers

	var/list/obj/item/signal_flare/flares
	var/list/assembled_flares

	.["lasers"] = assembled_lasers
	.["flares"] = assembled_flares

/obj/machinery/orbital_deployment_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/orbital_deployment_controller/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("arm")
		if("disarm")
		if("launch")
			var/atom/movable/target_ref
			if(params["targetType"] = "laser")
			else if(params["targetType" = "flare"])
