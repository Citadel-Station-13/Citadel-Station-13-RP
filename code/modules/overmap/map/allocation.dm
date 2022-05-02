/datum/overmap/proc/Allocate()
	if(turf_reservation)
		log_overmaps_map(src, "DANGER: Attempted to allocate while already allocated.")
		CRASH("Already allocated")
	var/real_width = width + OVERMAP_GENERATION_EDGE_MARGIN
	var/real_height = height + OVERMAP_GENERATION_EDGE_MARGIN
	// i don't trust my own allocation system, and neither should you
	// that said, fuck it
	var/oob = FALSE
	if(real_width > world.maxx)
		real_width = world.maxx
		oob = TRUE
	if(real_height > world.maxy)
		real_height = world.maxy
		oob = TRUE
	if(oob)
		width = real_width - OVERMAP_GENERATION_EDGE_MARGIN
		height = real_height - OVERMAP_GENERATION_EDGE_MARGIN
		log_overmaps_map(src, "Out of bounds allocation of [width]x[height] clamped.")
	log_overmaps_map(src, "Allocating block of [real_width]x[real_height]...")
	turf_reservation = SSmapping.RequestBlockReservation(width = real_width, height = real_height, type = /datum/turf_reservation/overmap, turf_type_override = /turf/overmap)
	if(!turf_reservation)
		log_overmaps_map(src, "Allocation failed! Crashing...")
		CRASH("Failed to allocate.")
	cached_z = turf_reservation.bottom_left_coords[3]
	cached_x_start = turf_reservation.bottom_left_coords[1]
	cached_y_start = turf_reservation.bottom_left_coords[2]
	cached_x_end = turf_reservation.top_right_coords[1]
	cached_y_end = turf_reservation.top_right_coords[2]
	cached_coordinate_width = width * OVERMAP_WORLD_ICON_SIZE * OVERMAP_DISTANCE_PIXEL
	cached_coordinate_height = height * OVERMAP_WORLD_ICON_SIZE * OVERMAP_DISTANCE_PIXEL
	cached_coordinate_center_x = cached_coordinate_width * 0.5
	cached_coordinate_center_y = cached_coordinate_height * 0.5

/datum/overmap/proc/SetupBounds()
	log_overmaps_map(src, "Setting up bounds...")
	if(!turf_reservation)
		log_overmaps_map(src, "Failed - no reservation")
		CRASH("No reservation")
	// only compile this in if there's a border
#if OVERMAP_GENERATION_EDGE_MARGIN > 7
	// this is to catch fuckups
	#error Why?
#endif
#if OVERMAP_GENERATION_EDGE_MARGIN > 0
	var/list/turf/turfs = list()
	// north
	turfs += block(locate(cached_x_start, cached_y_end, cached_z), locate(cached_x_end, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z))
	// south
	turfs += block(locate(cached_x_start, cached_y_start, cached_z), locate(cached_x_end, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z))
	// east
	turfs += block(locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN, cached_z), locate(cached_x_end, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN, cached_z))
	// west
	turfs += block(locate(cached_x_start, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN, cached_z), locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN, cached_z))

	for(var/turf/T as anything in turfs)
		// TODO: CHANGETURF_SKIP
		T.ChangeTurf(/turf/overmap/edge)
	log_overmaps_map(src, "Generated [length(turfs)] border turfs.")
#else
	log_overmaps_map(src, "Skipping borderturf setup - OVERMAP_GENERATION_EDGE_MARGIN is not positive")
#endif

/datum/overmap/proc/SetupVisuals()
	// if we don't have a side, don't bother
#if OVERMAP_SIDE_VISUAL_GLITZ < 1
	log_overmaps_map(src, "Skipping visual setup - OVERMAPS_SIDE_VISUAL_GLITZ is not positive.")
	return
#endif

	var/list/turf/turfs = list()
	// byond will blow the fuck up if vis contents loops, therefore
	// we generate visuals on the tile *outside* the real edge
	// now do you see why edge margin is needed?
#if OVERMAP_GENERATION_EDGE_MARGIN < 1
	#warn Read the comment above, do not delete this if block unless you know what you're doing
#endif
	if(height > 7)
		// south
		for(var/turf/T as anything in block(locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z), locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z)))
			turfs[T] = SOUTH
		// north
		for(var/turf/T as anything in block(locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z), locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z)))
			turfs[T] = NORTH
	if(width > 7)
		// east
		for(var/turf/T as anything in block(locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z), locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z)))
			turfs[T] = EAST
		// west
		for(var/turf/T as anything in block(locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z), locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z)))
			turfs[T] = WEST
	if(height > 7 && width > 7)
		// diagonals
		// southwest
		turfs[locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z)] = SOUTHWEST
		// southeast
		turfs[locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_z)] = SOUTHEAST
		// northwest
		turfs[locate(cached_x_start + OVERMAP_GENERATION_EDGE_MARGIN - 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z)] = NORTHWEST
		// northeast
		turfs[locate(cached_x_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_y_end - OVERMAP_GENERATION_EDGE_MARGIN + 1, cached_z)] = NORTHEAST
	// gen
	for(var/turf/T as anything in turfs)
		var/dir = turfs[T]
		var/atom/movable/overmap_visual_holder/holder = new(T)
		// this entire block can be optimized to a switch() if byond never gets compiler optimizations

		// i'm too tired today to write 400 lines of code to futureproof against someone being an idiot
		// such we assume edge margin is atleast 1
		// since we allocate directly on the inner edge, we don't need to offset an extra 32 to account for the first turf
		// this again is due to byond infinite looping and crashing if vis contents ever coincides
		// holder.pixel_x = (dir & (EAST|WEST))? ((dir == EAST)? (0) : (-32 * (OVERMAP_SIDE_VISUAL_GLITZ - 1))) : 0
		// holder.pixel_y = (dir & (NORTH|SOUTH))? ((dir == NORTH)? (0) : (-32 * (OVERMAP_SIDE_VISUAL_GLITZ - 1))) : 0

		// optimized version since we know where the 0's are
		holder.pixel_x = (dir & WEST)? (-32 * (OVERMAP_SIDE_VISUAL_GLITZ - 1)) : 0
		holder.pixel_y = (dir & SOUTH)? (-32 * (OVERMAP_SIDE_VISUAL_GLITZ - 1)) : 0
		// vis contents moment
		// since we have edge padding (again, see how important this is?)
		// we don't need to add weirdness like "side turf is considered transit turf, do not use", instead all of the overmap is usable*
		// tiled entities would always have issues becuase of how byond cross/uncross works so we still have to glitz that,
		// but entities will always collide properly since we use spatial lookup instead of byond bounds()
		holder.vis_contents = block(
			// ugh
			locate(
				(dir & (EAST|WEST))? ((dir & EAST)? (cached_x_start) : (cached_x_end - OVERMAP_SIDE_VISUAL_GLITZ + 1)) : (T.x),
				(dir & (NORTH|SOUTH))? ((dir & NORTH)? (cached_y_start) : (cached_y_end - OVERMAP_SIDE_VISUAL_GLITZ + 1)) : (T.y),
				cached_z
			),
			locate(
				(dir & (EAST|WEST))? ((dir & EAST)? (cached_x_start + OVERMAP_SIDE_VISUAL_GLITZ - 1) : (cached_x_end)) : (T.x),
				(dir & (NORTH|SOUTH))? ((dir & NORTH)? (cached_y_start + OVERMAP_SIDE_VISUAL_GLITZ - 1) : (cached_y_end)) : (T.y),
				cached_z
			)
		)
	log_overmaps_map(src, "Generated [length(turfs)] edge visuals for turfs.")
