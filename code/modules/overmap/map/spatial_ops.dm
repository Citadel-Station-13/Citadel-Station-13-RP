/**
 * gets all entities in range of this one
 *
 * warning: this is expensive. use sparingly!
 */
/datum/overmap/proc/range(atom/movable/overmap_object/O, dist, high_accuracy)

	#warn impl

/**
 * get all entites in range of x, y
 */
/datum/overmap/proc/entity_query(x, y, dist, high_accuracy)

/**
 * removes an entity from the spatial hash
 */
/datum/overmap/proc/_spatial_remove_entity(atom/movable/overmap_object/entity/E)

/**
 * adds an entity to the spatial hash
 */
/datum/overmap/proc/_spatial_add_entity(atom/movable/overmap_object/entity/E)

/**
 * get all entities
 */
/datum/overmap/proc/get_all_entities()
	return entities.Copy()

/**
 * sets up our spatial hash
 */
/datum/overmap/proc/SetupSpatialHash()


	// inject all entities
	for(var/atom/movable/overmap/entity/E as anything in entities)

