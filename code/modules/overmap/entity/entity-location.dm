//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Assigns us a location.
 *
 * * Will cause the location to acquire its level locks if it isn't already.
 */
/obj/overmap/entity/proc/set_location(datum/overmap_location/location)
	if(!isnull(src.location))
		// todo: swaps / de-assignment
		CRASH("location de-assignment not implemented yet")

	src.location = location
	location.entity = src

	if(!src.location.has_level_locks())
		src.location.acquire_level_locks()

/**
 * Checks loaded status
 */
/obj/overmap/entity/proc/get_location_load_status()
	return location ? location.get_load_status() : OVERMAP_LOCATION_IS_NOT_LOADED

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return list() of indices; empty list is possible.
 */
/obj/overmap/entity/proc/get_z_indices()
	RETURN_TYPE(/list)
	return location ? location.get_owned_z_indices() : list()

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 *
 * @return list() of indices; empty list is possible.
 */
/obj/overmap/entity/proc/get_owned_z_indices()
	RETURN_TYPE(/list)
	return location ? location.get_owned_z_indices() : list()
