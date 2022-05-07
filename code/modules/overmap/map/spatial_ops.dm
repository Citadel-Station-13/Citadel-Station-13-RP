// Everything in this file uses "real virtual" overmap coordinates
// aka they use our pretend coordinates from bottom left, NOT from the center
// player facing things should not use these real coordinates
////// ALL DISTANCES ARE MANHATTAN DISTANCE!! //////

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
 * get entity distance from a coordinate
 *
 * has more aggressive optimizations than get_entity_distance
 *
 * **uses byond manhattan distance**
 */
/datum/overmap/proc/direct_entity_distance_from(atom/movable/overmap_object/entity/E, x, y)
	var/dx = abs(x - E.position_x)
	var/dy = abs(y - E.position_y)
	return min(
		(dx > cached_coordinate_center_x? cached_coordinate_width - dx : dx),
		(dy > cached_coordinate_center_y? cached_coordinate_height - dy : dy)
	)

/**
 * get distance from one object to another, taking into account wraps
 * this is from the **center of one to the other!**
 *
 * unlike what the name suggests, tiled objects are supported
 *
 * this proc **does** depend on entity cached positions!
 * this proc assumes A and B are infact on the same overmap
 * if they are not, coder skill issue, check them yourself!
 *
 * **uses byond manhattan distance**
 */
/datum/overmap/proc/get_entity_distance(atom/movable/overmap_object/A, atom/movable/overmap_object/B)
	// aggressively optimized
	var/ax
	var/ay
	var/atom/movable/overmap_object/entity/cast
	if(istype(A, /atom/movable/overmap_object/entity))
		cast = A
		ax = cast.position_x
		ay = cast.position_y
	else
		ax = get_x_of_object(A)
		ay = get_y_of_object(A)
	if(istype(B, /atom/movable/overmap_object/entity))
		cast = B
		ax = abs(cast.position_x - ax)
		ay = abs(cast.position_y - ay)
	else
		ax = abs(get_x_of_object(B) - ax)
		ay = abs(get_y_of_object(B) - ay)
	return min(
		(ax > cached_coordinate_center_x? cached_coordinate_width - ax : ax),
		(ay > cached_coordinate_center_y? cached_coordinate_height - ay : ay)
	)

/**
 * gets wraparound-considered angle in degrees from A to B
 * assumes A and B are on the same overmap
 *
 * @return angle from A to B in angle clockwise from north
 */
/datum/overmap/proc/get_entity_angle(atom/movable/overmap_object/A, atom/movable/overmap_object/B)
	// aggressively optimized
	// if anyone needs to debug this, which you hopefully won't, please forgive me
	var/ax
	var/ay
	var/bx
	var/by
	var/atom/movable/overmap_object/entity/cast
	if(istype(A, /atom/movable/overmap_object/entity))
		cast = A
		ax = cast.position_x
		ay = cast.position_y
	else
		ax = get_x_of_object(A)
		ay = get_y_of_object(A)
	if(istype(B, /atom/movable/overmap_object/entity))
		cast = B
		bx = cast.position_x
		by = cast.position_y
	else
		bx = get_x_of_object(B)
		by = get_y_of_object(B)
	#warn finish this algorithm - clockwise from north
	. = arctan(
		abs(bx - ax) > cached_coordinate_center_x? (
			(bx > ax)? (-ax - (cached_coordinate_width - bx)) : (bx + (cached_coordinate_width - ax))
		) : (
			bx - ax
		),
		abs(by - ay) > cached_coordinate_center_y? (
			(by > ay)? (-ay - (cached_coordinate_height - by)) : (by + (cached_coordinate_width - ay))
		) : (
			by - ay
		)
	)
	. = SIMPLIFY_DEGREES(.)

/**
 * removes an entity from the spatial hash
 */
/datum/overmap/proc/_spatial_remove_entity(atom/movable/overmap_object/entity/E)
	spatial_hash[E._overmap_spatial_hash_index] -= E

/**
 * adds an entity to the spatial hash
 */
/datum/overmap/proc/_spatial_add_entity(atom/movable/overmap_object/entity/E)
	var/list/bucket = spatial_hash[OVERMAP_SPATIAL_HASH_COORD_INDEX(E.position_x, E.position_y, spatial_hash_width, spatial_hash_height)]
	if(E._overmap_spatial_hash_index)
		spatial_hash[E._overmap_spatial_hash_index] -= E
	bucket += E
	E.last_spatial_x = round(E.position_x / OVERMAP_SPATIAL_HASH_COORDSIZE)
	E.last_spatial_y = round(E.position_y / OVERMAP_SPATIAL_HASH_COORDSIZE)

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
	spatial_hash_width = CEILING(width / OVERMAP_SPATIAL_HASH_SIZE, 1)
	spatial_hash_height = CEILING(height / OVERMAP_SPATIAL_HASH_SIZE, 1)
	ASSERT(spatial_hash.len == (spatial_hash_height * spatial_hash_width))
	// make buckets
	for(var/i in 1 to spatial_hash.len)
		spatial_hash[i] = list()
	// inject all entities
	for(var/atom/movable/overmap_object/entity/E as anything in entities)
		E._overmap_spatial_hash_index = null	// clear old
		if(E.overmap != src)
			stack_trace("entity with wrong overmap found")
			continue
		_spatial_add_entity(E)
	log_overmaps_map(src, "spatial hash set up: [length(spatial_hash)] buckets with [length(entities)] initial entities.")
