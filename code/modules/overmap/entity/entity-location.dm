//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Checks if we're actually loaded in
 */
/obj/overmap/entity/proc/is_loaded_into_world()
	return !isnull(location)

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
