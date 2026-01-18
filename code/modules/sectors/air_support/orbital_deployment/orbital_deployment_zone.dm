//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Tracks all active orbital deployment zones.
 * * Contents: "[zone.id]" = zone
 */
GLOBAL_LIST_EMPTY(orbital_deployment_zones)

/**
 * * markers are used instead of turfs because we can be put on a shuttle, which will translate markers
 *   but turf refs would stay behind
 */
/datum/orbital_deployment_zone
	/// unique ID, if any
	var/id

	var/obj/orbital_deployment_marker/lower_left
	var/obj/orbital_deployment_marker/lower_right
	var/obj/orbital_deployment_marker/upper_right
	var/obj/orbital_deployment_marker/upper_left

	/// linked consoles
	var/list/obj/machinery/orbital_deployment_controller/controllers

	/// are we arming or armed?
	var/arming = FALSE
	/// when were we armed?
	/// * also set when disarmed
	var/arming_last_toggle
	/// arming toggle cooldown
	var/arming_cooldown = 3 SECONDS
	/// arming requirement
	var/arming_time = 10 SECONDS

	/// last launch, if any
	var/launch_last
	/// launch cooldown
	var/launch_cooldown = 2 MINUTES

	/// max overmap bounds dist we can launch at
	var/max_overmap_pixel_dist = WORLD_ICON_SIZE * 3
	/// can launch to same overmap entity
	var/can_target_self_entity = FALSE

	var/c_impact_obj_dmg_base = 150
	var/c_impact_obj_dmg_sides = 150
	var/c_impact_obj_dmg_cnt = 3
	var/c_impact_mob_dmg_base = 15
	var/c_impact_mob_dmg_sides = 10
	var/c_impact_mob_dmg_cnt = 10
	var/c_impact_mob_dmg_sides_for_those_without_plot_armor = 200
	var/c_landing_obj_dmg_base = 15
	var/c_landing_obj_dmg_sides = 15
	var/c_landing_obj_dmg_cnt = 5
	var/c_landing_mob_dmg_base = 5
	var/c_landing_mob_dmg_sides = 15
	var/c_landing_mob_dmg_cnt = 15

	var/c_telegraph_period = 10 SECONDS

	var/area/current_area

/datum/orbital_deployment_zone/New(
	obj/orbital_deployment_marker/lower_left,
	obj/orbital_deployment_marker/lower_right,
	obj/orbital_deployment_marker/upper_right,
	obj/orbital_deployment_marker/upper_left,
)
	if(!id)
		// todo: stupid way to generate ids tbh but whatever
		id = GUID()

	src.lower_left = lower_left
	src.lower_right = lower_right
	src.upper_right = upper_right
	src.upper_left = upper_left

	if(GLOB.orbital_deployment_zones[id])
		stack_trace("duplicate id [id], this zone will not be registered")
		QDEL_IN(src, 0)
	else
		GLOB.orbital_deployment_zones[id] = src

	for(var/obj/orbital_deployment_marker/corner/marker as anything in list(
		lower_left,
		lower_right,
		upper_right,
		upper_left,
	))
		marker.zone_built = TRUE
		marker.zone = src

	construct_initial()

/datum/orbital_deployment_zone/Destroy()
	for(var/obj/machinery/orbital_deployment_controller/controller in controllers)
		controller.unlink_zone()
	GLOB.orbital_deployment_zones -= id
	for(var/obj/orbital_deployment_marker/corner/marker as anything in list(
		lower_left,
		lower_right,
		upper_right,
		upper_left,
	))
		if(marker.zone != src)
			stack_trace("uh oh! marker zone mismatch; this should never happen!")
		else
			marker.zone = null
	lower_left = lower_right = upper_right = upper_left = null
	return ..()

/datum/orbital_deployment_zone/proc/construct_initial()
	// install superstructure
	var/turf/superstructure
	for(var/obj/orbital_deployment_marker/corner/marker as anything in list(
		lower_left,
		lower_right,
		upper_right,
		upper_left,
	))
		superstructure = marker.loc
		superstructure.ChangeTurf(/turf/simulated/wall/orbital_deployment_superstructure)
	// construct zone
	construct_zone()

/**
 * Construct or rebuild zone. Should be called after zone is yeeted.
 */
/datum/orbital_deployment_zone/proc/construct_zone()
	if(lower_left.z != upper_right.z)
		CRASH("LL/UR not on same z?")
	if(!isturf(lower_left.loc))
		CRASH("LL not on turf")
	if(!isturf(upper_right.loc))
		CRASH("UR not on turf")
	if((upper_right.x - lower_left.x) < 2 || (upper_right.y - lower_left.y) < 2)
		CRASH("LL/UR markers swapped")

	var/list/turf/inside_zone = block(get_step(lower_left, NORTHEAST), get_step(upper_right, SOUTHWEST))
	var/area/orbital_deployment_area/deployment_area = new(null)
	current_area = deployment_area

	var/any_area_collision = FALSE
	var/list/area/orbital_deployment_area/left_behind_areas = list()
	for(var/turf/inside as anything in inside_zone)
		if(inside.loc.type == /area/orbital_deployment_area)
			any_area_collision = TRUE
			left_behind_areas |= inside.loc
	deployment_area.take_turfs(inside_zone)
	if(any_area_collision)
		stack_trace("[length(left_behind_areas)] areas left behind on zone construction. \
		A launch probably bugged out or was somehow not done properly.")
	for(var/area/orbital_deployment_area/other_area as anything in left_behind_areas)
		// this is probably laggy but like you shouldn't be leaving areas behind!
		if(!length(other_area.contents))
			// this is DEFINITELY laggy but i don't care make sure it's GONE gone.
			qdel(other_area)

/datum/orbital_deployment_zone/proc/arm()
	if(arming)
		return
	arming = TRUE
	arming_last_toggle = world.time
	current_area.alpha = 175

/datum/orbital_deployment_zone/proc/disarm()
	if(!arming)
		return
	arming = FALSE
	arming_last_toggle = world.time
	current_area.alpha = 0

/datum/orbital_deployment_zone/proc/is_armed()
	return arming && ((arming_last_toggle + arming_time) <= world.time)

/datum/orbital_deployment_zone/proc/time_to_armed()
	return max(0, (arming_last_toggle + arming_time) - world.time)

/datum/orbital_deployment_zone/proc/get_corners()
	return list(lower_left, lower_right, upper_left, upper_right)

/datum/orbital_deployment_zone/proc/get_overmap_entity() as /obj/overmap/entity
	return SSovermaps.get_enclosing_overmap_entity(lower_left)

/datum/orbital_deployment_zone/proc/launch(turf/target_center, dir_from_north, dangerously_unsafe_ignore_checks, datum/event_args/actor/actor) as /obj/overmap/entity/orbital_deployment_transit
	if(!dangerously_unsafe_ignore_checks)
		if(!check_zone(target_center, dir_from_north))
			return null
	var/obj/overmap/entity/our_entity = get_overmap_entity()
	if(!our_entity)
		return null
	var/obj/overmap/entity/their_entity = SSovermaps.get_enclosing_overmap_entity(target_center)
	if(!their_entity)
		return null
	var/datum/orbital_deployment_transit/transit = new(src)
	var/list/target_corners = compute_target_corners(target_center, dir_from_north)
	transit.target_lower_left = target_corners[1]
	transit.target_dir_from_north = dir_from_north
	transit.launching_actor = actor
	if(!transit.allocate_and_package(locate(lower_left.x + 1, lower_left.y + 1, lower_left.z), locate(upper_right.x - 1, upper_right.y - 1, upper_right.z), current_area))
		qdel(transit)
		CRASH("failed to package transit; this shouldn't happen")
	construct_zone()
	var/obj/overmap/entity/orbital_deployment_transit/transit_entity = new(our_entity, src, transit)
	transit_entity.launch(their_entity)
	return transit_entity

/**
 * * input dir is with NORTH as 'do not rotate'
 * * keep in mind this returns TRUE if it's physically possible to translate, even if the player shouldn't be allowed to.
 * @return TRUE if it's safe to translate, codewise, FALSE otherwise
 */
/datum/orbital_deployment_zone/proc/check_zone(turf/target_center, dir_from_north, list/warnings_out, list/errors_out)
	// -- check bounds --
	var/list/target_corners = compute_target_corners(target_center, dir_from_north)
	if(!target_corners)
		errors_out?.Add("Out of bounds of sector or resides on border of valid atmospheric entry corridor.")
		return FALSE

	// -- check area invariance --
	var/turf/lower_left = target_corners[1]
	var/turf/upper_right = target_corners[2]
	do {
		var/area/A = lower_left.loc
		if(A.special)
			// i don't care to be IC about it too bad lol
			errors_out?.Add("Would collide with invariant region.")
			return FALSE
	}
	while(FALSE)
	do {
		var/area/A = upper_right.loc
		if(A.special)
			// i don't care to be IC about it too bad lol
			errors_out?.Add("Would collide with invariant region.")
			return FALSE
	}
	while(FALSE)

	var/list/turf/everything = block(target_corners[1], target_corners[2])
	for(var/turf/T as anything in everything)
		var/area/A = T.loc
		if(A.special)
			// i don't care to be IC about it too bad lol
			errors_out?.Add("Would collide with invariant region.")
			return FALSE
	// -- check balance vectors / safety --

	// lol did you expect safety checks here
	// nah
	// YOLOOOO BOMBS AWAY
	// only shuttles and other invariant areas are protected.
	// TODO: to whoever sees this in 3 months, know that i do not apologize for the fact that
	//       you are reading this inevitably because explo did some variant of bigger gun diplomacy.
	//
	//       my recommendation at that point is to either:
	//       - be very strict and check for any dense turf
	//       - check for a % of turfs being indoors and/or dense
	//       - code in anti-aircraft weaponry

	return TRUE

/**
 * @return list(lower left, upper right), or null if out of bounds.
 */
/datum/orbital_deployment_zone/proc/compute_target_corners(turf/target_center, dir_from_north)
	var/turf/bottom_left
	// -- translation: perform alignment --
	// we align our center (NOT WHAT THE PLAYER BUILT, but OUR ACTUAL CENTER of the ZONE)
	// to the target turf.
	// we will go northeast of relative-north, so bias northeast for uneven bits
	// when facing north, southwest facing south, southeast facing east, northwest facing west
	var/list/frame_dims = get_frame_dimensions()
	switch(dir_from_north)
		if(NORTH)
			bottom_left = locate(
				target_center.x - floor((frame_dims[1] - 1) / 2),
				target_center.y - floor((frame_dims[2] - 1) / 2),
				target_center.z,
			)
		if(SOUTH)
			bottom_left = locate(
				target_center.x - floor((frame_dims[1] - 0) / 2),
				target_center.y - floor((frame_dims[2] - 0) / 2),
				target_center.z,
			)
		if(EAST)
			bottom_left = locate(
				target_center.x - floor((frame_dims[2] - 1) / 2),
				target_center.y - floor((frame_dims[1] - 0) / 2),
				target_center.z,
			)
		if(WEST)
			bottom_left = locate(
				target_center.x - floor((frame_dims[2] - 0) / 2),
				target_center.y - floor((frame_dims[1] - 1) / 2),
				target_center.z,
			)
	// -- end --
	if(!bottom_left)
		return null
	var/turf/top_right = locate(bottom_left.x + frame_dims[1] - 1, bottom_left.y + frame_dims[2] - 1, bottom_left.z)
	if(!top_right)
		return null
	return list(bottom_left, top_right)

/datum/orbital_deployment_zone/proc/get_frame_width()
	return (upper_right.x - lower_left.x) - 1

/datum/orbital_deployment_zone/proc/get_frame_height()
	return (upper_right.y - lower_left.y) - 1

/datum/orbital_deployment_zone/proc/get_frame_dimensions()
	return list(
		(upper_right.x - lower_left.x) - 1,
		(upper_right.y - lower_left.y) - 1,
	)

/datum/orbital_deployment_zone/proc/on_launch()
	var/obj/overmap/entity/our_entity = get_overmap_entity()
	var/list/mob/witnesses = our_entity.get_all_players_in_location(TRUE)
	// TODO: standardize this on /entity
	for(var/mob/witness as anything in witnesses)
		witness.show_message(SPAN_WARNING("The floor lurches beneath you as a shock plows through the installation. \
		Creaking can be heard from the walls."), SAYCODE_TYPE_ALWAYS)
		shake_camera(witness, 0.5 SECONDS, 0.25 * WORLD_ICON_SIZE)

/datum/orbital_deployment_zone/proc/contains_turf(turf/T)
	return T.x >= lower_left.x && T.x <= upper_right.x && T.y >= lower_left.y && T.y <= upper_right.y
