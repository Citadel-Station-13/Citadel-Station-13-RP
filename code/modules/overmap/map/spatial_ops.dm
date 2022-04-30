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
 * get all entities
 */
/datum/overmap/proc/get_all_entities()
	return entities.Copy()

/**
 * sets up our spatial hash
 */
/datum/overmap/proc/SetupSpatialHash()

