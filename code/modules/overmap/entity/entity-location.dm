//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z, and list() if we're not in a level right now.
 */
/obj/overmap/entity/proc/get_z_indices()
	RETURN_TYPE(/list)
	return location?.get_z_indices()

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 *
 * @return null if this is not semantically an entity on a z, and list() if none are owned, otherwise
 */
/obj/overmap/entity/proc/get_owned_z_indices()
	RETURN_TYPE(/list)
	return location?.get_owned_z_indices()
