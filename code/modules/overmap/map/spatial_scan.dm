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

	// fastpath if we are trampling every side just grab the whole goddamn map
	if(trampled == ((1<<0) | (1<<1)))
		return entities.Copy()

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

	// we now have all the things we know for sure will be in us
	// everything else must be verified via dist calcs

	#warn unsure edges


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
	if(overrun_x)
		if(overrun_y)
			// ugh
			// auhguhgusaheohtjrytwierkpokytew3joi45ey6rtre wesrdtfhdjszloifhr4esr
			// FUCK YOU FUCK YOU FUCK YOU FUCK YOU FUCK Y-
			// I AM NOT EVEN GOING TO BOTHER OPTIMIZING FUCK YOU
			for(var/_x in x1 to x2)
				for(var/_y in y1 to y2)
					// at the very least we know we cannot have duplicates because var/trampled up above would have detected it
					// ... probably
					// ensured spatial hash scanning code is conservative so we should be fine(tm)
					if(_x <= 0)
						_x += spatial_hash_width
					else if(_x > spatial_hash_width)
						_x -= spatial_hash_width
					if(_y <= 0)
						_y += spatial_hash_height
					else if(_y > spatial_hash_height)
						_y -= spatial_hash_height
					// AAAAAAAAAAAAAAAAAAAAAAAAAa
					. += spatial_hash[OVERMAP_SPATIAL_HASH_INDEX(_x, _y, spatial_hash_width, spatial_hash_height)]
			return
		// x only
		// get non wrapping portion
		. += _entities_in_spatial_square(x1, y1, x2, y2)
		if(overrun_x > 0)
			// west edge
			. += _entities_in_spatial_square(1, y1, overrun_x, y2)
		else
			// east edge
			. += _entities_in_spatial_square(spatial_hash_width + overrun_x + 1, y1, spatial_hash_width, y2)
	else if(overrun_y)
		// y only
		// get non wrapping portion
		. += _entities_in_spatial_square(x1, y1, x2, y2)
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
	var/x_start = (trampled & (1<<0)) ? (cached_bottomleft_pixel_x) : (cached_bottomleft_pixel_x + x - dist - 1)
	var/y_start = (trampled & (1<<1)) ? (cached_bottomleft_pixel_y) : (cached_bottomleft_pixel_y + y - dist - 1)
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
