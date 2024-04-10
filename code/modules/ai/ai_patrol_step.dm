//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a patrol step
 */
/datum/ai_patrol_step
	/// turf to go to
	var/turf/target

	/// clustering distance; this is the distance
	/// where they'll try to be within.
	/// this is randomized via gaussian; this is the center
	var/clustering_center = 4
	/// gaussian deviation for clustering
	var/clustering_deviation = 2.5

	/// how fast to get here; this is randomized via guassian.
	/// this is in tiles/second
	var/travel_speed_center = 4
	/// gaussian deviation for travel speed in tiles/second
	var/travel_speed_deviation = 1

	/// how long to stay here; this is randomized via gaussian.
	/// this is in deciseconds.
	var/linger_delay_center = 3 SECONDS
	/// gaussian deviation for linger delay in deciseconds
	var/linger_delay_deviation = 2 SECONDS
