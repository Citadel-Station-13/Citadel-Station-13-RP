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
	. = list()
	var/bucket_x = CEILING(x / OVERMAP_SPATIAL_HASH_COORDSIZE, 1)
	var/bucket_y = CEILING(y / OVERMAP_SPATIAL_HASH_COORDSIZE, 1)
	// TODO: manual optimization because byond compiler probably doesn't optimize CEILING
	var/closest = min(
		abs(round(x, OVERMAP_SPATIAL_HASH_COORDSIZE) - x),
		abs(round(y, OVERMAP_SPATIAL_HASH_COORDSIZE) - y)
	)
	var/bucket_radius = closest < dist? CEILING(dist / OVERMAP_SPATIAL_HASH_COORDSIZE, 1) : 0
	if(bucket_radius == 0)
		// process the bucket we're in if we just need that
		for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(bucket_x, bucket_y, spatial_hash_width, spatial_hash_height)])
			if(direct_entity_distance_from(E, x, y) <= dist)
				. += E
		return
	// scan all buckets in range
	if(min(spatial_hash_width - bucket_x, spatial_hash_height - bucket_y, bucket_x - 1, bucket_y - 1) > bucket_radius)
		// requires wraparound
		#warn finish
	else
		// no wraparound, fastpath to a slightly cheaper scan
		for(var/x in (bucket_x - bucket_radius) to (bucket_x + bucket_radius))
			for(var/y in (bucket_y - bucket_radius) to (bucket_y + bucket_radius))
				for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
					if(direct_entity_distance_from(E, x, y) <= dist)
						. += E

	#warn redo this section entirely
	var/list/collected = list()
	if(((bucket_x + bucket_radius) > spatial_hash_width) || ((bucket_y + bucket_radius) > spatial_hash_height))
		// worst case - we have to process wraparounds
		// if bucket radius is larger than half the map, we just scan 1 to width
		if(bucket_radius > spatial_)
		for(var/x in (bucket_x - bucket_radius) to (bucket_x + bucket_radius))
			for(var/y in (bucket_y - bucket_radius) to (bucket_y + bucket_radius))
				var/rx = x > spatial_hash_width? x - spatial_hash_width : x
				var/ry = y > spatial_hash_height? y - spatial_hash_height : y
				for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(rx, ry, spatial_hash_width, spatial_hash_height)])
					if(direct_entity_distance_from(E, x, y) <= dist)
						. += E

/**
 * get entity distance from a coordinate
 *
 * has more aggressive optimizations than get_entity_distance
 */
/datum/overmap/proc/direct_entity_distance_from(atom/movable/overmap_object/entity/E, x, y)
	var/ex = E.position_x
	var/ey = E.position_y
	var/dx = ex - x
	var/dy = ey - y
	return sqrt(
		(abs(dx) > cached_coordinate_center_x? (dx > 0? cached_coordinate_width - dx : cached_coordinate_width + dx) : dx)**2
		+
		(abs(dy) > cached_coordinate_center_y? (dy > 0? cached_coordinate_height - dy : cached_coordinate_height + dy) : dy)**2
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
 */
/datum/overmap/proc/get_entity_distance(atom/movable/overmap_object/A, atom/movable/overmap_object/B)
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
	// we save some var dec overhead, fuck you
	ax = ax - bx
	ay = ay - by
	// if greater than center x, wrap the value around
	// at this point, ax pos = a right of b, ay pos = a right of b
	// use cached coordinate sizes
	// regardless use euclidean dist calc after
	return sqrt(
		(abs(ax) > cached_coordinate_center_x? (ax > 0? cached_coordinate_width - ax : cached_coordinate_width + ax) : ax)**2
		+
		(abs(ay) > cached_coordinate_center_y? (ay > 0? cached_coordinate_height - ay : cached_coordinate_height + ay) : ay)**2
	)

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
	spatial_hash_width = CEILING(width / OVERMAP_SPATIAL_HASH_TILES, 1)
	spatial_hash_height = CEILING(height / OVERMAP_SPATIAL_HASH_TILES, 1)
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
