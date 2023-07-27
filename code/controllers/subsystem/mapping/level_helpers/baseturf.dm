//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Gets baseturf type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_baseturf(z)
	var/datum/map_level/L = ordered_levels[z]
	return L.base_turf || world.turf
