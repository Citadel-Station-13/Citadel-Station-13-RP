//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * get z-level indices in this entity
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z
 */
/obj/overmap/entity/proc/get_z_indices()
	RETURN_TYPE(/list)
	return location?.get_z_indices()

/**
 * get a random z-level in this entity
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z
 */
/obj/overmap/entity/proc/get_random_z_index()
	return location?.get_random_z_index()
