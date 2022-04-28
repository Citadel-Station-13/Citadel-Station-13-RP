/**
 * gets all entities in range of this one
 *
 * warning: this is expensive. use sparingly!
 */
/datum/overmap/proc/range(atom/movable/overmap_object/O, dist)

	#warn impl

/**
 * get all entites in range of x, y
 */
/datum/overmap/proc/entity_query(x, y, dist)

/**
 * get all entities
 */
/datum/overmap/proc/get_all_entities()
	return entities.Copy()

/**
 * sets up our spatial hash
 */
/datum/overmap/proc/SetupSpatialHash()

