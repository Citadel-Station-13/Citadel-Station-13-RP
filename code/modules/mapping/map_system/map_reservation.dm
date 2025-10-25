/**
 * reserved turfs as part of reserved zlevels
 *
 * reserved zlevels are sealed, no-teleport, no-wireless, no-telecomms levels used for internal purposes.
 *
 * players should not spend too much time in reserved areas, as many things will flat out not work in them for optimization reasons.
 *
 * maybe someday we'll have a non-3d-prism game engine and we can have something actually reasonable instead of this pile of shit.
 */
/datum/map_reservation
	/// are we allocated?
	var/tmp/allocated = FALSE
	/// border turfs - just the first layer / the immediate border
	///
	///  todo: this shouldn't be a var, make it a proc
	///
	/// * does not include the rest of the border
	/// * you shouldn't need to initialize more than one layer of turfs.
	var/list/turf/border_turfs

	/// width
	var/width = 0
	/// height
	var/height = 0
	/// border size
	var/border = 0
	/// list(x, y, z) - set when allocated
	var/list/bottom_left_coords
	/// list(x, y, z) - set when allocated
	var/list/top_right_coords
	/// list(x, y, z) - set when allocated
	/// this includes border
	var/list/bottom_left_border_coords
	/// list(x, y, z) - set when allocated
	var/list/top_right_border_coords

	/// callback to use when something crosses border
	///
	/// * called with (turf/border)
	/// * only used if border is custom-initalized, otherwise we use selflooping transition borders
	/// * specifying this makes us put a reservation border component on the turfs as needed.
	var/datum/callback/border_handler
	/// if using another initializer, do we still do the standard mirages?
	var/border_mirage_anyways = FALSE
	/// border initializer to call with every turf on the border to init them
	///
	/// * called with (turf/border, datum/map_reservation/reservation)
	/// * if border is specified but initializer isn't, we just make them transition borders.
	var/datum/callback/border_initializer

	/// type of our turf - null for default
	var/turf_type
	/// type of our area - null for default
	var/area_type

	/// our border area instance if needed
	var/area/reservation_border/border_area
	/// our area instance
	var/area/reservation_area

	//* spatial lookup *//
	var/spatial_bl_x
	var/spatial_bl_y
	var/spatial_tr_x
	var/spatial_tr_y
	var/spatial_z

/datum/map_reservation/New()
	if(isnull(turf_type))
		turf_type = RESERVED_TURF_TYPE
	if(isnull(area_type))
		area_type = RESERVED_AREA_TYPE

/datum/map_reservation/Destroy()
	release()
	return ..()

/datum/map_reservation/proc/get_approximately_center_turf()
	return locate(
		bottom_left_coords[1] + floor(top_right_coords[1] - bottom_left_coords[1]),
		bottom_left_coords[2] + floor(top_right_coords[2] - bottom_left_coords[2]),
		bottom_left_coords[3],
	)

/datum/map_reservation/proc/is_atom_inside(atom/A)
	A = get_turf(A)
	return A.z == bottom_left_coords[3] && \
		A.x >= bottom_left_coords[1] && A.x <= top_right_coords[1] && \
		A.y >= bottom_left_coords[2] && A.y <= top_right_coords[2]

/datum/map_reservation/proc/release()
	if(border)
		SSmapping.initialize_unused_reservation_turfs(block(locate(
			bottom_left_border_coords[1], bottom_left_border_coords[2], bottom_left_border_coords[3]
			), locate(
			top_right_border_coords[1], top_right_border_coords[2], top_right_border_coords[3])
		))
	else
		SSmapping.initialize_unused_reservation_turfs(block(locate(
			bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3]
			), locate(
			top_right_coords[1], top_right_coords[2], top_right_coords[3])
		))
	allocated = FALSE
	if(border_area)
		QDEL_NULL(border_area)
	SSmapping.reservations -= src

	// unegister from lookup
	var/list/spatial_lookup = SSmapping.reservation_spatial_lookups[spatial_z]
	var/spatial_width = ceil(world.maxx / TURF_CHUNK_RESOLUTION)
	for(var/spatial_x in spatial_bl_x to spatial_tr_x)
		for(var/spatial_y in spatial_bl_y to spatial_tr_y)
			var/index = spatial_x + (spatial_y - 1) * spatial_width
			if(spatial_lookup[index] != src)
				stack_trace("index [index] wasn't self, what happened?")
				continue
			spatial_lookup[index] = null

	spatial_bl_x = spatial_tr_x = spatial_bl_y = spatial_tr_y = spatial_z = null

	if(!reservation_area.unique)
		qdel(reservation_area)
	reservation_area = null

	return TRUE

/datum/map_reservation/proc/reserve(width, height, border, z_override)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		CRASH("invalid request")
	if(border && ceil(border) != border)
		CRASH("invalid border")
	if(!length(SSmapping.reservation_levels))
		CRASH("uh oh")
	UNTIL(!SSmapping.reservation_system_mutex)
	SSmapping.reservation_system_mutex = TRUE
	// pick and take
	var/list/possible_levels = SSmapping.reservation_levels.Copy()
	var/level_index

	// with border
	var/real_width = width + border * 2
	var/real_height = height + border * 2

	// without border
	var/turf/BL
	var/turf/TR

	// with border
	var/list/turf/final_border
	// without border
	var/list/turf/final

	// area to use
	var/area/area_path = area_type
	var/area/area_instance = initial(area_path.unique)? (GLOB.areas_by_type[area_path] || new area_path) : new area_path

	var/found_a_spot = FALSE

	var/how_many_wide = ceil(real_width / TURF_CHUNK_RESOLUTION)
	var/how_many_high = ceil(real_height / TURF_CHUNK_RESOLUTION)
	var/total_many_wide = floor(world.maxx / TURF_CHUNK_RESOLUTION)
	var/total_many_high = floor(world.maxy / TURF_CHUNK_RESOLUTION)

	// the dreaded 5 deep for loop
	while((level_index = z_override) || (level_index = pick_n_take(possible_levels)))
		/**
		 * here's the magic
		 * because reservations are aligned to TURF_CHUNK_RESOLUTION,
		 * we just have to check the start spots, since we always align to them.
		 *
		 * bottom-left turfs on reservations align to
		 * (chunk_x - 1) * TURF_CHUNK_RESOLUTION + 1
		 * (chunk_y - 1) * TURF_CHUNK_RESOLUTION + 1
		 */
		for(var/outer_x in 1 to (total_many_wide - how_many_wide + 1))
			for(var/outer_y in 1 to (total_many_high - how_many_high + 1))
				var/passing = TRUE
				for(var/inner_x in outer_x to outer_x + how_many_wide - 1)
					for(var/inner_y in outer_y to outer_y + how_many_high - 1)
						var/turf/checking = locate(
							1 + (inner_x - 1) * TURF_CHUNK_RESOLUTION,
							1 + (inner_y - 1) * TURF_CHUNK_RESOLUTION,
							level_index,
						)
						if(!(checking.turf_flags & TURF_FLAG_UNUSED_RESERVATION))
							passing = FALSE
							break
					if(!passing)
						break
				if(!passing)
					continue

				// calculate non-bordered
				BL = locate(1 + TURF_CHUNK_RESOLUTION * (outer_x - 1) + border, 1 + TURF_CHUNK_RESOLUTION * (outer_y - 1) + border, level_index)
				TR = locate(BL.x + width - 1, BL.y + height - 1, level_index)
				final = block(BL, TR)

				// calculate border
				if(border)
					final_border = list(
						) + block( // left pane
							locate(
								1 + TURF_CHUNK_RESOLUTION * (outer_x - 1),
								1 + TURF_CHUNK_RESOLUTION * (outer_y - 1),
								level_index,
							),
							locate(
								1 + TURF_CHUNK_RESOLUTION * (outer_x - 1) + (border - 1),
								BL.y + (real_height - 1),
								level_index,
							),
						) + block( // right pane
							locate(
								BL.x + (real_width - 1) - (border - 1),
								1 + TURF_CHUNK_RESOLUTION * (outer_y - 1),
								level_index,
							),
							locate(
								BL.x + (real_width - 1),
								BL.y + (real_height - 1),
								level_index,
							),
						) + block( // top pane without left and right
							locate(
								1 + TURF_CHUNK_RESOLUTION * (outer_x - 1) + border,
								BL.y + (real_height - 1) - (border - 1),
								level_index,
							),
							locate(
								BL.x + (real_width - 1) - border,
								BL.y + (real_height - 1),
								level_index,
							),
						) + block( // bottom pane without left and right
							locate(
								1 + TURF_CHUNK_RESOLUTION * (outer_x - 1) + border,
								1 + TURF_CHUNK_RESOLUTION * (outer_y - 1),
								level_index,
							),
							locate(
								BL.x + (real_width - 1) - border,
								1 + TURF_CHUNK_RESOLUTION * (outer_y - 1) + (border - 1),
								level_index,
							),
						)

				found_a_spot = TRUE
				break
			if(found_a_spot)
				break
		if(found_a_spot)
			break
		// if we were overriding and we didn't, break anyways
		if(!isnull(z_override))
			break
	if(!found_a_spot)
		SSmapping.reservation_system_mutex = FALSE
		return FALSE
	for(var/turf/T as anything in final)
		T.turf_flags &= ~TURF_FLAG_UNUSED_RESERVATION
		if(T.type != turf_type)
			T.ChangeTurf(turf_type, turf_type)

	src.bottom_left_coords = list(BL.x, BL.y, BL.z)
	src.top_right_coords = list(TR.x, TR.y, TR.z)

	if(border)
		var/mirage_range = max(min(width - 3, height - 3, 9), 0)
		var/should_mirage = (border_mirage_anyways || !border_initializer) && mirage_range
		var/needs_component = border_handler || (should_mirage && !border_initializer)

		src.border_area = new
		src.border_area.reservation = src
		// todo: take_turfs
		src.border_area.contents.Add(final_border)
		for(var/turf/T as anything in final_border)
			T.turf_flags &= ~TURF_FLAG_UNUSED_RESERVATION
		// get just the first layer, but also init them at the same time
		var/list/turf/final_immediate_border
		// left
		var/list/turf/immediate_left = block(
			locate(bottom_left_coords[1] - 1, bottom_left_coords[2], bottom_left_coords[3]),
			locate(bottom_left_coords[1] - 1, top_right_coords[2], bottom_left_coords[3]),
		)
		for(var/turf/T as anything in immediate_left)
			border_initializer?.Invoke(T, src)
			if(needs_component)
				T.AddComponent(/datum/component/reservation_border, mirage_range, WEST, should_mirage, locate(top_right_coords[1], T.y, T.z), border_handler)
			CHECK_TICK
		// right
		var/list/turf/immediate_right = block(
			locate(top_right_coords[1] + 1, bottom_left_coords[2], bottom_left_coords[3]),
			locate(top_right_coords[1] + 1, top_right_coords[2], bottom_left_coords[3]),
		)
		for(var/turf/T as anything in immediate_right)
			border_initializer?.Invoke(T, src)
			if(needs_component)
				T.AddComponent(/datum/component/reservation_border, mirage_range, EAST, should_mirage, locate(bottom_left_coords[1], T.y, T.z), border_handler)
			CHECK_TICK
		// up
		var/list/turf/immediate_up = block(
			locate(bottom_left_coords[1], top_right_coords[2] + 1, bottom_left_coords[3]),
			locate(top_right_coords[1], top_right_coords[2] + 1, bottom_left_coords[3]),
		)
		for(var/turf/T as anything in immediate_up)
			border_initializer?.Invoke(T, src)
			if(needs_component)
				T.AddComponent(/datum/component/reservation_border, mirage_range, NORTH, should_mirage, locate(T.x, bottom_left_coords[2], T.z), border_handler)
			CHECK_TICK
		// down
		var/list/turf/immediate_down = block(
			locate(bottom_left_coords[1], bottom_left_coords[2] - 1, bottom_left_coords[3]),
			locate(top_right_coords[1], bottom_left_coords[2] - 1, bottom_left_coords[3]),
		)
		for(var/turf/T as anything in immediate_down)
			border_initializer?.Invoke(T, src)
			if(needs_component)
				T.AddComponent(/datum/component/reservation_border, mirage_range, SOUTH, should_mirage, locate(T.x, top_right_coords[2], T.z), border_handler)
			CHECK_TICK

		var/list/immediate_corners = list()
		var/turf/corner
		// top left
		corner = locate(bottom_left_coords[1] - 1, top_right_coords[2] + 1, bottom_left_coords[3])
		border_initializer?.Invoke(corner, src)
		if(needs_component)
			corner.AddComponent(/datum/component/reservation_border, mirage_range, NORTHWEST, should_mirage, locate(top_right_coords[1], bottom_left_coords[2], bottom_left_coords[3]), border_handler)
		immediate_corners += corner
		// top right
		corner = locate(top_right_coords[1] + 1, top_right_coords[2] + 1, bottom_left_coords[3])
		border_initializer?.Invoke(corner, src)
		if(needs_component)
			corner.AddComponent(/datum/component/reservation_border, mirage_range, NORTHEAST, should_mirage, locate(bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3]), border_handler)
		immediate_corners += corner
		// bottom left
		corner = locate(bottom_left_coords[1] - 1, bottom_left_coords[2] - 1, bottom_left_coords[3])
		border_initializer?.Invoke(corner, src)
		if(needs_component)
			corner.AddComponent(/datum/component/reservation_border, mirage_range, SOUTHWEST, should_mirage, locate(top_right_coords[1], top_right_coords[2], bottom_left_coords[3]), border_handler)
		immediate_corners += corner
		// bottom right
		corner = locate(top_right_coords[1] + 1, bottom_left_coords[2] - 1, bottom_left_coords[3])
		border_initializer?.Invoke(corner, src)
		if(needs_component)
			corner.AddComponent(/datum/component/reservation_border, mirage_range, SOUTHEAST, should_mirage, locate(bottom_left_coords[1], top_right_coords[2], bottom_left_coords[3]), border_handler)
		immediate_corners += corner

		final_immediate_border = \
			immediate_left + \
			immediate_right + \
			immediate_up + \
			immediate_down + \
			immediate_corners
		src.border_turfs = final_immediate_border

	// todo: area.assimilate_turfs?
	area_instance.contents.Add(final)
	src.reservation_area = area_instance
	src.width = width
	src.height = height
	src.border = border
	allocated = TRUE
	SSmapping.reservation_system_mutex = FALSE
	SSmapping.reservations += src

	// register in lookup
	ASSERT(bottom_left_coords[3] == top_right_coords[3]) // just to make sure assumptions made at time of writing are still true
	src.spatial_bl_x = ceil(bottom_left_coords[1] / TURF_CHUNK_RESOLUTION)
	src.spatial_bl_y = ceil(bottom_left_coords[2] / TURF_CHUNK_RESOLUTION)
	src.spatial_tr_x = ceil(top_right_coords[1] / TURF_CHUNK_RESOLUTION)
	src.spatial_tr_y = ceil(top_right_coords[2] / TURF_CHUNK_RESOLUTION)
	src.spatial_z = bottom_left_coords[3]
	var/spatial_width = ceil(world.maxx / TURF_CHUNK_RESOLUTION)
	var/list/spatial_lookup = SSmapping.reservation_spatial_lookups[spatial_z]
	for(var/spatial_x in src.spatial_bl_x to src.spatial_tr_x)
		for(var/spatial_y in src.spatial_bl_y to src.spatial_tr_y)
			var/index = spatial_x + (spatial_y - 1) * spatial_width
			if(spatial_lookup[index])
				stack_trace("index [index] wasn't null, what happened?")
				continue
			spatial_lookup[index] = src

	return TRUE

/**
 * gets an unordered list of all inner (non-border) turfs
 */
/datum/map_reservation/proc/unordered_inner_turfs()
	return block(
		locate(bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3]),
		locate(top_right_coords[1], top_right_coords[2], top_right_coords[3]),
	)

/**
 * gets an unordered list of all outer (border) turfs
 */
/datum/map_reservation/proc/unordered_border_turfs()
	if(!border)
		return list()
	return border_turfs.Copy()

/**
 * gets an unordered list of all immediate (1-outside) turfs
 */
/datum/map_reservation/proc/unordered_immediate_border_turfs()
	if(!border)
		return list()
	// todo: implement this
	CRASH("unimplemented")

//* Reservation Border Area *//

/area/reservation_border
	name = "Reservation Border Area"
	unique = FALSE
	always_unpowered = TRUE
	has_gravity = FALSE

	/// the reservation that owns us
	var/datum/map_reservation/reservation

/area/reservation_border/Destroy()
	reservation = null
	return ..()
