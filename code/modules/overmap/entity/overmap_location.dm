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
			CRASH("entity [entity] already had a location")
		else
			entity.set_location(src)
	if(location)
		bind(location)

/datum/overmap_location/Destroy()
	if(entity.location == src)
		entity.location = null
	entity = null
	unbind()
	if(has_level_locks())
		release_level_locks()
	return ..()

//* Abstraction - Must Implement! *//

/datum/overmap_location/proc/bind(location)
	PROTECTED_PROC(TRUE)
	CRASH("unimplemented proc called")

/datum/overmap_location/proc/unbind()
	PROTECTED_PROC(TRUE)
	CRASH("unimplemented proc called")

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return null if there are none / this is not semantically an entity on a z, and list() if we're not in a level right now.
 */
/datum/overmap_location/proc/get_z_indices_impl() as /list
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/list)
	CRASH("unimplemented proc called")

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return null if this is not semantically an entity on a z, and list() if none are owned, otherwise
 */
/datum/overmap_location/proc/get_owned_z_indices_impl() as /list
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/list)
	CRASH("unimplemented proc called")

/**
 * Gets if we physically are a level.
 *
 * * Shuttles in freeflight are not their level, even if they own them.
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return TRUE / FALSE based on if we are the physical level, or just represent the level.
 */
/datum/overmap_location/proc/is_physically_level_impl(z) as num
	PROTECTED_PROC(TRUE)
	CRASH("unimplemented proc called")

//* API *//

/**
 * get our z-level indices
 *
 * * entities that are on z's like shuttles instead of owning them use the z level they're on
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return null if there are none / this is not semantically an entity on a z, and list() if we're not in a level right now.
 */
/datum/overmap_location/proc/get_z_indices() as /list
	RETURN_TYPE(/list)
	if(!acquired_level_locks)
		return list()
	return get_z_indices_impl()

/**
 * get our owned z-level indices
 *
 * * shuttles and similar entities don't own their indices.
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return null if this is not semantically an entity on a z, and list() if none are owned, otherwise
 */
/datum/overmap_location/proc/get_owned_z_indices() as /list
	RETURN_TYPE(/list)
	if(!acquired_level_locks)
		return list()
	return get_owned_z_indices_impl()

/**
 * Gets if we physically are a level.
 *
 * * Shuttles in freeflight are not their level, even if they own them.
 * * this proc has no safety checks for if we have z-level locks! it only makes sense to call this
 *   once we're already on an entity and considered loaded.
 *
 * @return TRUE / FALSE based on if we are the physical level, or just represent the level.
 */
/datum/overmap_location/proc/is_physically_level(z) as num
	if(!acquired_level_locks)
		return FALSE
	return is_physically_level_impl(z)

//* Instantiation *//

/**
 * Checks if we're loaded in.
 */
/datum/overmap_location/proc/get_load_status()
	return OVERMAP_LOCATION_IS_LOADED

//* Registration *//

/**
 * Checks if we've locked our levels
 */
/datum/overmap_location/proc/has_level_locks()
	return !isnull(acquired_level_locks)

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
		if(SSovermaps.location_enclosed_levels[z_index])
			CRASH("attempted to lock levels but [z_index] was already locked")
	for(var/z_index in levels_to_lock)
		SSovermaps.location_enclosed_levels[z_index] = src

	SSovermaps.active_overmap_locations += src
	acquired_level_locks = levels_to_lock
	return TRUE

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
		if(SSovermaps.location_enclosed_levels[z_index] != src)
			stack_trace("attempted to unlock [z_index] but was not owned by self")
			continue
		SSovermaps.location_enclosed_levels[z_index] = null

	acquired_level_locks = null
	SSovermaps.active_overmap_locations -= src
	return TRUE

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
