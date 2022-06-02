/**
 * checks if we're real
 */
/atom/movable/overmap_object/entity/proc/has_physical_location()
	return instantiation == ENTITY_INSTANTIATION_REAL || instantiation == ENTITY_INSTANTIATION_UNLOADED

/**
 * checks if we're loaded
 */
/atom/movable/overmap_object/entity/proc/is_instantiated()
	return instantiation == ENTITY_INSTANTIATION_REAL

/**
 * requests we load in
 */
/atom/movable/overmap_object/entity/proc/ensure_instantiated()
	if(instantiation == ENTITY_INSTANTIATION_REAL)
		return TRUE
	if(instantiation != ENTITY_INSTANTIATION_UNLOADED)
		return FALSE
	instantiate_location()
	if(!location)
		stack_trace("Failed to instantiate location upon request.")
		instantiation = ENTITY_INSTANTIATION_ERRORED
		return FALSE
	return TRUE

/**
 * attempts to instantiate our location
 */
/atom/movable/overmap_object/entity/proc/instantiate_location()
	return

/**
 * gets our location datum
 */
/atom/movable/overmap_object/entity/proc/get_location()
	RETURN_TYPE(/datum/overmap_location)
	ensure_instantiated()
	return location

/**
 * represents a physical location that an entity is
 */
/datum/overmap_location


#warn impl
