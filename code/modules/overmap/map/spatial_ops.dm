// Everything in this file uses "real virtual" overmap coordinates
// aka they use our pretend coordinates from bottom left, NOT from the center
// player facing things should not use these real coordinates

/**
 * gets all entities in range of this one's **center**
 * this does not take hitbox size into account, it is not the
 * physics backend's job to!
 *
 * however, if the object in question is a non entity, we do take into account its "hitbox"!
 * this should only be the case for tiled objects.
 *
 * warning: this is expensive. use sparingly!
 */
/datum/overmap/proc/range(atom/movable/overmap_object/O, dist)
	if(istype(O, /atom/movable/overmap_object/entity))
		var/atom/movable/overmap_object/entity/E = O
		return entity_query(E.position_x, E.position_y, dist)
	return entity_query(get_x_of_object(O), get_y_of_object(O), dist + OVERMAP_WORLD_ICON_SIZE * 0.5)

/**
 * get real x coordinate of object's **center**
 * this skips the object's internal cache, and is usually used
 * for tiled entities or for rebuilding an entity's cache
 *
 * assumes object is in bounds
 */
/datum/overmap/proc/get_x_of_object(atom/movable/overmap_object/O)
	. = ((cached_x_start - O.x) * OVERMAP_WORLD_ICON_SIZE * OVERMAP_DISTANCE_PIXEL)
	if(istype(O, /atom/movable/overmap_object/entity))
		var/atom/movable/overmap_object/entity/E = O
		. += E.pixel_x
		// TODO: pixel movement
	else
		. += (OVERMAP_WORLD_ICON_SIZE * 0.5)

/**
 * get real y coordinate of object
 * this skips the object's internal cache, and is usually used
 * for tiled entities or for rebuilding an entity's cache
 *
 * assumes object is in bounds
 */
/datum/overmap/proc/get_y_of_object(atom/movable/overmap_object/O)
	. = ((cached_y_start - O.y) * OVERMAP_WORLD_ICON_SIZE * OVERMAP_DISTANCE_PIXEL)
	if(istype(O, /atom/movable/overmap_object/entity))
		var/atom/movable/overmap_object/entity/E = O
		. += E.pixel_y
		// TODO: pixel movement
	else
		. += (OVERMAP_WORLD_ICON_SIZE * 0.5)

/**
 * gets if something is in bounds of our map, physically, on the byond map
 */
/datum/overmap/proc/physically_in_bounds(atom/movable/AM)
	return AM.z == cached_z && AM.x >= cached_x_start && AM.x <= cached_x_end && AM.y >= cached_y_start && AM.y <= cached_y_end

/**
 * get all entites in range of x, y. this does NOT take into account
 * hitboxes, that's not the physics backend's job!
 *
 * warning: expensive, use sparingly!
 */
/datum/overmap/proc/entity_query(x, y, dist)
	#warn finish

/**
 * get distance from one object to another, taking into account wraps
 *
 * unlike what the name suggests, tiled objects are supported
 *
 * this proc **does** depend on entity cached positions!
 */
/datum/overmap/proc/get_entity_distance(atom/movable/overmap_object/A, atom/movable/overmap_object/B)


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
