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
	// our bucket size
	var/bucket_x = x / OVERMAP_SPATIAL_HASH_COORDSIZE
	var/bucket_y = y / OVERMAP_SPATIAL_HASH_COORDSIZE
	bucket_x = CEILING(bucket_x, 1)
	bucket_y = CEILING(bucket_y, 1)
	// detect wraparounds
	/// direction bitfield of wrap dirs
	var/wraparound	 = (dist > cached_coordinate_width - x + 1? EAST : NONE)	| \
						(dist > cached_coordinate_height - y + 1? NORTH : NONE)	| \
						(x - dist >= 0? WEST : NONE)							| \
						(y - dist >= 0? SOUTH : NONE)
	// detect the size being big enough we flat out trample an entire width/height and overlap
	var/diameter = dist * 2 + 1
	var/trampled = NONE
	// trampled gets set with first bit if we'd entirely wrap around east/west, and/or second if north/south
	// upon detection, we also cancel wraparound because we can just safely set the start points to 1 for that x/y/both.
	if(diameter > cached_width_pixels)
		trampled |= (1<<0)
		wraparound &= ~(EAST|WEST)
	if(diameter > cached_height_pixels)
		trampled |= (1<<1)
		wraparound &= ~(NORTH|SOUTH)
	// well this is going to be really !!FUNNY!!
	// within a certian distance, we know everything we grab is going to 100% be within range
	// let's uh, grab those first without considering wraparounds
	// i already hand-optimized raw_bounds_entity_query() let's use procs like smart people this time eh?
	// if i hand-optimize entity_query it's going to be 500 lines long and man i am not feeling like
	// self-inflicting cock and ball torture in the form of
	// "LUMMOX, WHY CAN'T WE HAVE AN OPTIMIZING COMPILER OR HAVE AN OPEN SOURCE ENGINE SO I DON'T HAVE TO DO THIS"
	// (today, anyways)

	// lower coords with overflow allowed
	var/raw_lower_x = x - dist
	var/raw_lower_y = y - dist
	// upper coords with overflow allowed
	var/raw_upper_x = x + dist
	var/raw_upper_y = y + dist

	// "everything is solvable with another layer of abstraction"
	// we use a helper proc that *can* compute wraparounds
	// first grab everything we know is 100% within range
	// btw, round() is used here to FLOOR(i, 1) but faster.
	var/lower_ensured_index_x
	var/upper_ensured_index_x
	if(trampled & (1<<0))
		lower_ensured_index_x = 1
		upper_ensured_index_x = spatial_hash_width
	else
		lower_ensured_index_x = raw_lower_x / OVERMAP_SPATIAL_HASH_COORDSIZE
		upper_ensured_index_x = raw_upper_x / OVERMAP_SPATIAL_HASH_COORDSIZE
		lower_ensured_index_x = CEILING(lower_ensured_index_x, 1) + 1
		upper_ensured_index_x = round(upper_ensured_index_x)
	var/lower_ensured_index_y
	var/upper_ensured_index_y
	if(trampled & (1<<1))
		lower_ensured_index_y = 1
		upper_ensured_index_y = spatial_hash_height
	else
		lower_ensured_index_y = raw_lower_y / OVERMAP_SPATIAL_HASH_COORDSIZE
		upper_ensured_index_y = raw_upper_y / OVERMAP_SPATIAL_HASH_COORDSIZE
		lower_ensured_index_y = CEILING(lower_ensured_index_y, 1)
		upper_ensured_index_y = round(upper_ensured_index_y)

	// if we have no wraparound we know we do not need to use wrapped spatial square at all
	. += wraparound? 																														\
		_entities_in_wrapped_spatial_square(lower_ensured_index_x, lower_ensured_index_y, upper_ensured_index_x, upper_ensured_index_y)		\
		:																																	\
		_entities_in_spatial_square(lower_ensured_index_x, lower_ensured_index_y, upper_ensured_index_x, upper_ensured_index_y)






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

// DANGEROUS PROC START - these are all used for above. if you snowflake use it and bad things happen, eat shit.
/**
 * get all entities in a wrapped square
 * this proc has more checking than _entities_in_spatial_square because we don't check in the wrapping math itself
 */
/datum/overmap/proc/_entities_in_wrapped_spatial_square(x1, y1, x2, y2)
	PRIVATE_PROC(TRUE)
	. = list()
	if(x1 > x2 || y1 > y2)	// negative range
		return
	var/overrun_x
	var/overrun_y
	if(x1 < 0)
		overrun_x = x1 - 1
		x1 = 1
	else if(x2 > spatial_hash_width)
		overrun_x = spatial_hash_width - x2
		x1 -= overrun_x
	if(y1 < 0)
		overrun_y = y1 - 1
		y1 = 1
	else if(y2 > spatial_hash_height)
		overrun_y = spatial_hash_height - y2
		y2 -= overrun_y
	// get non wrapping portion
	. += _entities_in_spatial_square(x1, y1, x2, y2)
	if(overrun_x)
		if(overrun_y)
			// ugh

			return
		// x only
		if(overrun_x > 0)
			// west edge
			. += _entities_in_spatial_square(1, y1, overrun_x, y2)
		else
			// east edge
			. += _entities_in_spatial_square(spatial_hash_width + overrun_x + 1, y1, spatial_hash_width, y2)
	else if(overrun_y)
		// y only
		if(overrun_y > 0)
			// south edge
			. += _entities_in_spatial_square(x1, 1, x2, overrun_y)
		else
			// north edge
			. += _entities_in_spatial_square(x1, spatial_hash_height + overrun_y + 1, x2, spatial_hash_height)

/**
 * get all entities in a square of the spatial hash
 * technically any valid rectange sue me
 * proc does not validate inputs. proc is private. fuck up, it's on you.
 */
/datum/overmap/proc/_entities_in_spatial_square(x1, y1, x2, y2)
	PRIVATE_PROC(TRUE)
	. = list()
	for(var/x in x1 to x2)
		for(var/y in y1 to y2)
			. += spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(x, y, spatial_hash_width, spatial_hash_height)]

/**
 * helper for use bounds() to perform entity query from a dist
 * takes into account wraps
 *
 * @params
 * - x - absolute overmap coordinate x
 * - y - absolute overmap coordinate y
 * - dist - overmap coords to scan. 0 just grabs everything overlapping one singular pixel on us.
 */
/datum/overmap/proc/bounds_entity_query(x, y, dist)
	/// direction bitfield of wrap dirs
	var/computed_wrap = (dist > cached_coordinate_width - x + 1? EAST : NONE)	| \
						(dist > cached_coordinate_height - y + 1? NORTH : NONE)	| \
						(x - dist >= 0? WEST : NONE)							| \
						(y - dist >= 0? SOUTH : NONE)

	return raw_bounds_entity_query(
		round(x / OVERMAP_DISTANCE_PIXEL, 1),
		round(y / OVERMAP_DISTANCE_PIXEL, 1),
		round(dist / OVERMAP_DISTANCE_PIXEL, 1),
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
 * - x - absolute byond pixel coordinate x from bottom left of overmap
 * - y - absolute byond pixel coordinate y from bottom left of overmap
 * - dist - pixels to scan. 0 just grabs anything overlapping the pixel at x, y.
 * - wraparound - do we need to wrap around? bitfield.
 */
/datum/overmap/proc/raw_bounds_entity_query(x, y, dist, wraparound)
	PRIVATE_PROC(TRUE)		// take this off if you need to, unlike the other private procs in here. KNOW WHAT YOU ARE DOING.
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
	// track parameters of first scan for reuse, mostly importantly, overrun
	// overrun is negative when overflowing south or west, positive if overflowing north or east
	var/x_start = (trampled & (1<<0)) ? (cached_bottomleft_pixel_x) : (cached_bottomleft_pixel_x + x - dist - 1),
	var/y_start = (trampled & (1<<1)) ? (cached_bottomleft_pixel_y) : (cached_bottomleft_pixel_y + y - dist - 1),
	var/overrun_x = 0
	var/overrun_y = 0
	if(x_start < cached_bottomleft_pixel_x)
		overrun_x = x_start - cached_bottomleft_pixel_x
		x_start = cached_bottomleft_pixel_x
	if(y_start < cached_bottomleft_pixel_y)
		overrun_y = y_start - cached_bottomleft_pixel_y
		y_start = cached_bottomleft_pixel_y
	var/x_size = diameter
	var/y_size = diameter
	if(x_size > cached_pixel_width - x + 1)
		overrun_x = x_size - (cached_pixel_width - x + 1)
		x_size -= overrun_x
	if(y_size > cached_pixel_height - y + 1)
		overrun_y = y_size - (cached_pixel_height - y + 1)
		y_size -= overrun_y
	// first scan
	scan = bounds(
		x_start,
		y_start,
		x_size,
		y_size
	)
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
	// addendum: overrun vars added
	// static 6 vars + multiple math/comparison ops. however, greatly speeds up math for overrun scan parameters.
	switch(wraparound)
		// these are simple, we can use x/y start/size perfectly
		// only one overrun is not 0
		if(NORTH)
			scan = bounds(
				x_start,
				1,
				x_size,
				overrun_y
			)
			SCAN_BOUNDS(scan)
		if(SOUTH)
			scan = bounds(
				x_start,
				cached_bottomleft_pixel_y + cached_pixel_height + overrun_y,
				x_size,
				-overrun_y
			)
			SCAN_BOUNDS(scan)
		if(EAST)
			scan = bounds(
				1,
				y_start,
				overrun_x,
				y_size
			)
			SCAN_BOUNDS(scan)
		if(WEST)
			scan = bounds(
				cached_bottomleft_pixel_x + cached_pixel_width + overrun_x,
				y_start,
				-overrun_x,
				y_size
			)
		// these are more complicated
		// we cannot use x/y start/size perfectly
		// both overruns are not 0
		if(NORTHEAST)
			// north --> south
			scan = bounds(
				x_start,
				1,
				x_size,
				overrun_y
			)
			SCAN_BOUNDS(scan)
			// east --> west
			scan = bounds(
				1,
				y_start,
				overrun_x,
				y_size
			)
			SCAN_BOUNDS(scan)
			// northeast --> southwest
			scan = bounds(
				1,
				1,
				overrun_x,
				overrun_y
			)
			SCAN_BOUNDS(scan)
		if(NORTHWEST)
			// north --> south
			scan = bounds(
				x_start,
				1,
				x_size,
				overrun_y
			)
			SCAN_BOUNDS(scan)
			// west --> east
			scan = bounds(
				cached_bottomleft_pixel_x + cached_pixel_width + overrun_x,
				y_start,
				-overrun_x,
				y_size
			)
			SCAN_BOUNDS(scan)
			// northwest --> southeast
			scan = bounds(
				cached_bottomleft_pixel_x + cached_pixel_width + overrun_x,
				1,
				-overrun_x,
				overrun_y
			)
			SCAN_BOUNDS(scan)
		if(SOUTHEAST)
			// south --> north
			scan = bounds(
				x_start,
				cached_bottomleft_pixel_y + cached_pixel_height + overrun_y,
				x_size,
				-overrun_y
			)
			SCAN_BOUNDS(scan)
			// east --> west
			scan = bounds(
				1,
				y_start,
				overrun_x,
				y_size
			)
			SCAN_BOUNDS(scan)
			// southeast --> northwest
			scan = bounds(
				1,
				cached_bottomleft_pixel_y + cached_pixel_height + overrun_y,
				overrun_x,
				-overrun_y
			)
			SCAN_BOUNDS(scan)
		if(SOUTHWEST)
			// south --> north
			scan = bounds(

			)
			SCAN_BOUNDS(scan)
			// west --> east
			scan = bounds(
				cached_bottomleft_pixel_x + cached_pixel_width + overrun_x,
				y_start,
				-overrun_x,
				y_size
			)
			SCAN_BOUNDS(scan)
			// southwest --> northeast
			scan = bounds(
				cached_bottomleft_pixel_x + cached_pixel_width + overrun_x,
				cached_bottomleft_pixel_y + cached_pixel_height + overrun_y,
				-overrun_x,
				-overrun_y
			)
			SCAN_BOUNDS(scan)

#undef SCAN_BOUNDS
