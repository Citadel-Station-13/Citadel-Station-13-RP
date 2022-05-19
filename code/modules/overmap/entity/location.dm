/**
 * checks if we're real
 */
/atom/movable/overmap_object/entity/proc/has_physical_location()
	return instantiation == OVERMAP_ENTITY_INSTANTIATION_REAL || instantiation == OVERMAP_ENTITY_INSTANTIATION_UNLOADED

/**
 * requests we load in
 */
/atom/movable/overmap_object/entity/proc/ensure_instantiated()
	if(instantiation == OVERMAP_ENTITY_INSTANTIATION_REAL)
		return TRUE
	if(instantiation != OVERMAP_ENTITY_INSTANTIATION_UNLOADED)
		return FALSE
	instantiate_location()
	if(!location)
		stack_trace("Failed to instantiate location upon request.")
		instantiation = OVERMAP_ENTITY_INSTANTIATION_ERRORED
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
