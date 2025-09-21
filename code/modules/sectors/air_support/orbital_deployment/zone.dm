//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * markers are used instead of turfs because we can be put on a shuttle, which will translate markers
 *   but turf refs would stay behind
 */
/datum/orbital_deployment_zone
	/// unique ID
	var/id
	#warn impl id

	/// lower left marker
	var/obj/orbital_deployment_marker/lower_left
	/// upper right marker
	var/obj/orbital_deployment_marker/upper_right

#warn impl

/datum/orbital_deployment_zone/New(obj/orbital_deployment_marker/lower_left, obj/orbital_deployment_marker/upper_right)

/datum/orbital_deployment_zone/proc/construct_initial()

	construct_zone()

/datum/orbital_deployment_zone/proc/construct_zone()
	if(!isturf(lower_left.loc))
		CRASH("LL not on turf")
	if(!isturf(upper_right.loc))
		CRASH("UR not on turf")
	if((upper_right.x - lower_left.x) < 2 || (upper_right.y - lower_left.y) < 2)
		CRASH("LL/UR markers swapped")

	var/turf/test_turf = get_step(lower_left, NORTHEAST)
	if(istype(test_turf.loc, /area/orbital_deployment))
		CRASH("tried to write-over a zone (lower-left test failed)")
	var/list/turf/inside_zone = block(get_step(lower_left, NORTHEAST), get_step(upper_right, SOUTHWEST))
	var/area/orbital_deployment/deployment_area = new(null)


	#warn impl

/**
 * input dir is with NORTH as 'do not rotate'
 */
/datum/orbital_deployment_zone/proc/check_validity(turf/target_center, dir)

/datum/orbital_deployment_zone/proc/do_translate(turf/target_lower_left, rotation_degrees)

	var/wanted_dir = math__angle_to_dir_exact_or_throw(rotation_degrees)

	var/width
	var/height

	#warn impl
	calculate_entity_motion_with_respect_to_moving_point()
	var/list/destination_turfs = SSgrids.get_ordered_turfs(
		target_lower_left.x,
		target_lower_left.x + width - 1,
		target_lower_left.y,
		target_lower_left.y + height - 1,
		target_lower_left.z,
	)

/datum/orbital_deployment_zone/proc/get_width()

/datum/orbital_deployment_zone/proc/get_height()
