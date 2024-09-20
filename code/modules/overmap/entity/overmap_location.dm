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
	/// owning entity, if any
	var/obj/overmap/entity/entity

/datum/overmap_location/New(location, obj/overmap/entity/entity)
	if(entity)
		if(entity.location)
			stack_trace("entity [entity] already had a location")
		else
			src.entity = entity
	if(location)
		bind(location)

/datum/overmap_location/Destroy()
	if(entity.location == src)
		entity.location = null
	entity = null
	unbind()
	return ..()

/datum/overmap_location/proc/bind(location)
	CRASH("unimplemented proc called")

/datum/overmap_location/proc/unbind()
	CRASH("unimplemented proc called")

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 *
 * @return null if there are none / this is not semantically an entity on a z, and list() if we're not in a level right now.
 */
/datum/overmap_location/proc/get_z_indices()
	RETURN_TYPE(/list)

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 *
 * @return null if this is not semantically an entity on a z, and list() if none are owned, otherwise
 */
/datum/overmap_location/proc/get_owned_z_indices()
	RETURN_TYPE(/list)

#warn impl
