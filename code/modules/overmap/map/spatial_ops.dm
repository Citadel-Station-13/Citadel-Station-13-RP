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
	spatial_hash[E._overmap_spatial_hash_index] -= E

/**
 * adds an entity to the spatial hash
 */
/datum/overmap/proc/_spatial_add_entity(atom/movable/overmap_object/entity/E)
	var/list/bucket = spatial_hash[OVERMAP_SPATIAL_HASH_COORD_INDEX(E.position_x, E.position_y)]
	if(E._overmap_spatial_hash_index)
		spatial_hash[E._overmap_spatial_hash_index] -= E
	bucket += E

/**
 * updates an entity's location in the spatial hash
 */
/datum/overmap/proc/_spatial_update_entity(atom/movable/overmap_object/entity/E)
	_spatial_remove_entity(E)
	_spatial_add_entity(E)

/**
 * get all entities
 */
/datum/overmap/proc/get_all_entities()
	return entities.Copy()

/**
 * sets up our spatial hash
 */
/datum/overmap/proc/SetupSpatialHash()
	log_overmaps_map(src, "[spatial_hash? "resetting" : "setting up"] spatial hash.")
	// make list
	spatial_hash = list()
	// make list of length
	spatial_hash.len = OVERMAP_SPATIAL_HASH_FOR_TILE_SIZE(width, height)
	// make buckets
	for(var/i in 1 to spatial_hash.len)
		spatial_hash[i] = list()
	// inject all entities
	for(var/atom/movable/overmap/entity/E as anything in entities)
		E._overmap_spatial_hash_index = null	// clear old
		if(E.overmap != src)
			stack_trace("entity with wrong overmap found")
			continue
		_spatial_add_entity(E)
	log_overmaps_map(src, "spatial hash set up: [length(spatial_hash)] buckets with [length(entities)] initial entities.")
