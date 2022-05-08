// "so why did you implement a 2d physics engine ontop of another 2d physics engine"
// because i hate myself, i hate byond, and i hate working here


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

	#warn we will never beat byond builtins at low ranges. use bounds() when under a certain limit.

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
 * helper for use bounds() to perform entity query from a dist
 * takes into account wraps
 *
 * @params
 * - x - absolute overmap coordinate x
 * - y - absolute overmap coordinate y
 * - dist - overmap coords to scan
 */
/datum/overmap/proc/bounds_entity_query(x, y, dist)
	/// direction bitfield of wrap dirs
	var/computed_wrap = (x > dist? NONE : WEST) | (y > dist? NONE : SOUTH) | \
						((cached_coordinate_width - x) >= 1? NONE : EAST)  | \
						((cached_coordinate_height - y) >= 1? NONE : NORTH)
	return raw_bounds_entity_query(
		x / OVERMAP_DISTANCE_PIXEL,
		y / OVERMAP_DISTANCE_PIXEL,
		dist / OVERMAP_DISTANCE_PIXEL,
		computed_wrap
	)

#define SCAN_BOUNDS(B) \
	for(var/atom/movable/overmap_object/entity/E in B) { . += E; }

/**
 * helper for use bounds() to perform entity query from a dist
 * takes into account wraps
 *
 * warning this proc operates on byond pixels!
 *
 * @params
 * - x - absolute byond pixel coordinate x
 * - y - absolute byond pixel coordinate y
 * - dist - pixels to scan. 0 just grabs anything overlapping the pixel at x, y.
 * - wraparound - do we need to wrap around? bitfield.
 */
/datum/overmap/proc/raw_bounds_entity_query(x, y, dist, wraparound)
	. = list()
	var/diameter = dist * 2 + 1
	// early optimization - if diameter is too big, remove wraps and reset x/y's because we know it'll trample
	var/trampled = NONE
	// trampled gets set with first bit if we'd entirely wrap around east/west, and/or second if north/south
	// upon detection, we also cancel wraparound because we can just safely set the start points to 1 for that x/y/both.
	if(diameter > cached_width_pixels)
		trampled |= (1<<0)
		wraparound &= ~(EAST|WEST)
	if(diameter > cached_height_pixels)
		trampled |= (1<<1)
		wraparound &= ~(NORTH|SOUTH)
	if(trampled == ((1<<0) | (1<<1)))
		return entities.Copy()		// we're getting the whole map.
	var/list/scan
	// first scan
	scan = bounds(
		(trampled & (1<<0)) ? (cached_bottomleft_pixel_x) : (cached_bottomleft_pixel_x + x - dist - 1)
		(trampled & (1<<1)) ? (cached_bottomleft_pixel_y) : (cached_bottomleft_pixel_y + y - dist - 1),
		diameter - 1,
		diameter - 1)
	SCAN_BOUNDS(scan)
	if(!wraparound)
		// if we aren't wrapping around this first scan caught everything
		return
	// we know at this point we are wrapping around atleast one side
	// thanks to the dist trample checks, we know that we don't have to worry about duplicates either.
	// also, we know that we cannot wrap more than one side. what does this mean?
	// this means that we just reduced our workload by a **lot**
	// we can optimize further but for now, 4 if's and a switch will do just fine.
	// furthermore, in these if's we can assume we don't have to check trampled if wraparound is in
	// a trampled dir flag, because then wraparound wouldn't have those dirs!
	if(wraparound & NORTH)
		scan = bounds(
			cached_coordinate_width - (dist - x),
			cached_coordinate_height - (dist - y),

		)
		SCAN_BOUNDS(scan)
	else if(wraparound & SOUTH)
		scan = bounds(
			cached_coordinate_width - (dist - x),
			cached_coordinate_height - (dist - y),

		)
		SCAN_BOUNDS(scan)
	if(wraparound & EAST)
		scan = bounds(
			cached_coordinate_width - (dist - x),
			cached_coordinate_height - (dist - y),

		)
		SCAN_BOUNDS(scan)
	else if(wraparound & WEST)
		scan = bounds(
			cached_coordinate_width - (dist - x),
			cached_coordinate_height - (dist - y),

		)
		SCAN_BOUNDS(scan)
	// if there's a diagonal..
	// (if anything is trampled there can't be!)
	if(isDiagonal(wraparound))
		// wraparound cannot be more than one diagonal, or something would have been trampled,
		// so we use bitfields to check dir
		// NOTE: math can still be manually optimized later!
		scan = bounds(
			(wraparound & EAST)?  (cached_bottomleft_pixel_x) : (cached_bottomleft_pixel_x - 1 + cached_pixel_width - (dist - x)),
			(wraparound & NORTH)? (cached_bottomleft_pixel_y) : (cached_bottomleft_pixel_y - 1 + cached_pixel_height - (dist - y)),
			(wraparound & EAST)?  () : (dist - x + 1),
			(wraparound & NORTH)? () : (dist - y + 1)
		)
		SCAN_BOUNDS(scan)

#undef SCAN_BOUNDS
