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

/datum/orbital_deployment_zone/proc/construct()

/datum/orbital_deployment_zone
