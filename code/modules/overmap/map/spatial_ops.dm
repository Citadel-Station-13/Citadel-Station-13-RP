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
 * get all entites in range of x, y. this does NOT take into account
 * hitboxes, that's not the physics backend's job!
 *
 * warning: expensive, use sparingly!
 *
 * TODO: optimizations for when you only require an off-centered 2x2 scan instead of a full 3x3 scan
 * TODO: generalize said optimizations so we don't go 1x1 to 3x3 to 5x5 ++, and can use 2x2, 4x4, 6x6, etc, when needed?
 */
/datum/overmap/proc/entity_query(x, y, dist)
	. = list()
	var/bucket_x = CEILING(x / OVERMAP_SPATIAL_HASH_COORDSIZE, 1)
	var/bucket_y = CEILING(y / OVERMAP_SPATIAL_HASH_COORDSIZE, 1)
	// TODO: manual optimization because byond compiler probably doesn't optimize CEILING
	// the cached coordinate height/width is needed because spatial size can go past the high edges

	#warn we will never beat byond builtins. use bounds() when under a certain limit.

	var/closest = min(
		abs(round(x, OVERMAP_SPATIAL_HASH_COORDSIZE) - x),
		abs(round(y, OVERMAP_SPATIAL_HASH_COORDSIZE) - y),
		cached_coordinate_height - x,
		cached_coordinate_width - y
	)
	var/bucket_radius = closest < dist? CEILING(dist / OVERMAP_SPATIAL_HASH_COORDSIZE, 1) : 0
	if(bucket_radius == 0)
		// process the bucket we're in if we just need that
		for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(bucket_x, bucket_y, spatial_hash_width, spatial_hash_height)])
			if(direct_entity_distance_from(E, x, y) <= dist)
				. += E
		return



	#warn REDO AGAIN
	// we could not do the easy route
	// so, we only need to do distance calcs for the edges of our spatial scan
	// for everything inside a certain range, we know for sure they'll be in range.


	#warn old code below
	// scan all buckets in range
	if(min(spatial_hash_width - bucket_x, spatial_hash_height - bucket_y, bucket_x - 1, bucket_y - 1) > bucket_radius)
		// requires wraparound
		// okay THIS IS GOING TO BE AWFUL
		// first, scan x coordinate
		// we KNOW we will need to wrap around so first check is is our dist big enough
		// that we will wrap around the entirety of the map and to the other side of the check?
		// we can optimize it out if so
		if(dist > cached_coordinate_center_x)
			// if we're bigger we know we are going to need to scan the entire x width of the map
			if(dist > cached_coordinate_center_y)
				// oh they literally wanted the entire goddamn map
				return entities.Copy()
			var/y_wrap_edge = (y - dist) < 0? SOUTH : ((y + dist) > cached_coordinate_height? SOUTH : NONE)
			// unfortunately we didn't luck out and they're picky
			for(var/x in 1 to spatial_hash_width)
				// scan y
				switch(y_wrap_edge)
					if(NORTH)
						for(var/y in bucket_y to spatial_hash_height)
							for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
								if(direct_entity_distance_from(E, x, y) <= dist)
									. += E
						for(var/y in 1 to ((bucket_y + bucket_radius) - spatial_hash_height))
							for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
								if(direct_entity_distance_from(E, x, y) <= dist)
									. += E
					if(SOUTH)
						for(var/y in 1 to bucket_y)
							for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
								if(direct_entity_distance_from(E, x, y) <= dist)
									. += E
						for(var/y in spatial_hash_height to (spatial_hash_height - (bucket_y - bucket_radius)) step -1)
							for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
								if(direct_entity_distance_from(E, x, y) <= dist)
									. += E
					else
						CRASH("unexpected edge value")
		else if(dist > cached_coordinate_center_y)
			// if we're bigger we know we are going to need to scan the entire y height of the map

		else
			// ughhhhh, most common case, no shortcuts

		#warn finish
	else
		// no wraparound, fastpath to a slightly cheaper scan
		for(var/x in (bucket_x - bucket_radius) to (bucket_x + bucket_radius))
			for(var/y in (bucket_y - bucket_radius) to (bucket_y + bucket_radius))
				for(var/atom/movable/overmap_object/entity/E as anything in spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)])
					if(direct_entity_distance_from(E, x, y) <= dist)
						. += E

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
	#warn finish this algorithm
	return arctan(
		abs(bx - ax) > cached_coordinate_center_x?
			(bx > ax?
				(-ax - (cached_coordinate_width - bx))
				:
				(bx + (cached_coordinate_width - ax))
			)
			:
			(bx - ax)
		,
		abs(by - ay) > cached_coordinate_center_y?
			(by > ay?
				(-ay - (cached_coordinate_height - by))
				:
				(by + (cached_coordinate_height - ay))
			)
			:
			(by - ay)
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
