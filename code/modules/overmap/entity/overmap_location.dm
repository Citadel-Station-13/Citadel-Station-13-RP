//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Location binding for overmaps.
 *
 * Used to abstract the concept of location.
 *
 * Descriptive, I know.
 */
/datum/overmap_location

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z
 */
/datum/overmap_location/proc/get_z_indices()
	RETURN_TYPE(/list)

/**
 * get a random z-level from ourselves
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z
 */
/datum/overmap_location/proc/get_random_z_index()

#warn impl
