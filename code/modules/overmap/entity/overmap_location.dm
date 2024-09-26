//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Location binding for overmaps.
 *
 * Used to abstract the concept of location.
 *
 * Descriptive, I know.
 *
 * ## Abstract Procs
 *
 * These procs must be implemented on subtypes.
 *
 * * bind(location)
 * * unbind()
 * * get_z_indices() - gets z-levels we are on
 * * get_owned_z_indices() - gets z-levels we physically own; shuttles only own their freeflight levels
 * * physically_is_level(z) - gets if a z-level is physically contained by us.
 *   shuttles, while owning their freeflight levels, does not represent that level
 *   as the level is transient / not part of the shuttle.
 */
/datum/overmap_location
	/// owning entity, if any
	var/obj/overmap/entity/entity
	/// our locked levels
	///
	/// * null if none.
	VAR_PRIVATE/list/acquired_level_locks

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

//* Abstraction - Must Implement! *//

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
	CRASH("unimplemented proc called")

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 *
 * @return null if this is not semantically an entity on a z, and list() if none are owned, otherwise
 */
/datum/overmap_location/proc/get_owned_z_indices()
	RETURN_TYPE(/list)
	CRASH("unimplemented proc called")

/**
 * Gets if we physically are a level.
 *
 * * Shuttles in freeflight are not their level, even if they own them.
 */
/datum/overmap_location/proc/is_physically_level(z)
	CRASH("unimplemented proc called")

//* Registration *//

/**
 * Registers our ownership to the levels we should own.
 *
 * * Runtimes if we already locked levels.
 */
/datum/overmap_location/proc/acquire_level_locks()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!isnull(acquired_level_locks))
		CRASH("already has locked levels, and attempted to acquire level locks")

	var/list/levels_to_lock = query_levels_to_lock()
	for(var/z_index in levels_to_lock)

	acquired_level_locks = levels_to_lock

/**
 * Releases our ownership of the levels we own.
 *
 * * Runtimes if we didn't lock levels.
 */
/datum/overmap_location/proc/release_level_locks()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(isnull(acquired_level_locks))
		CRASH("has not locked levels, but attempted to release level locks")

	for(var/z_index in acquired_level_locks)

	acquired_level_locks = null

#warn impl and hook all

/**
 * Refreshes our owned level locks
 *
 * * Useful if they change.
 * * Runtimes if we didn't lock levels.
 */
/datum/overmap_location/proc/refresh_level_locks()
	SHOULD_NOT_OVERRIDE(TRUE)
	release_level_locks()
	acquire_level_locks()

/**
 * Gets levels we should own
 *
 * * You might want to override this when needed.
 */
/datum/overmap_location/proc/query_levels_to_lock()
	return get_owned_z_indices()
