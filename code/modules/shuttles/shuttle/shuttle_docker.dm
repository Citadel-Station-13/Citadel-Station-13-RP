//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle custom docking handler
 */
/datum/shuttle_docker
	/// our host shuttle
	var/datum/shuttle/shuttle

	/// our current orientation
	var/orientation

#warn impl all

/**
 * Returns a list of name-to-turf of valid jump points
 */
/datum/shuttle_docker/proc/docking_beacons(zlevel)
	RETURN_TYPE(/list)
	#warn impl


