/**
 * reserved turfs as part of reserved zlevels
 *
 * reserved zlevels are sealed, no-teleport, no-wireless, no-telecomms levels used for internal purposes.
 *
 * players should not spend too much time in reserved areas, as many things will flat out not work in them for optimization reasons.
 *
 * maybe someday we'll have a non-3d-prism game engine and we can have something actually reasonable instead of this pile of shit.
 */
/datum/turf_reservation
	/// are we allocated?
	var/tmp/allocated = FALSE
	/// reserved turfs - set when allocated
	var/list/turf/reserved_turfs
	/// width
	var/width = 0
	/// height
	var/height = 0
	/// list(x, y, z) - set when allocated
	var/bottom_left_coords
	/// list(x, y, z) - set when allocated
	var/top_right_coords
	/// type of our turf - null for default
	var/turf_type
	/// type of our border - null to default to turf_type
	var/border_type
	/// type of our area - null for default
	var/area_type

	//* spatial lookup *//
	var/spatial_bl_x
	var/spatial_bl_y
	var/spatial_tr_x
	var/spatial_tr_y
	var/spatial_z

/datum/turf_reservation/New()
	if(isnull(turf_type))
		turf_type = RESERVED_TURF_TYPE
	if(isnull(area_type))
		area_type = RESERVED_AREA_TYPE

/datum/turf_reservation/Destroy()
	release()
	return ..()

/datum/turf_reservation/proc/release()
	SSmapping.reserve_turfs(reserved_turfs)
	reserved_turfs = null
	allocated = FALSE
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

	return TRUE

/datum/turf_reservation/proc/reserve(width, height, z_override)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		CRASH("invalid request")
	if(!length(SSmapping.reserve_levels))
		CRASH("uh oh")
	UNTIL(!SSmapping.reservation_blocking_op)
	SSmapping.reservation_blocking_op = TRUE
	// pick and take
	var/list/possible_levels = SSmapping.reserve_levels.Copy()
	var/level_index
	var/turf/BL
	var/turf/TR
	var/list/turf/final
	var/area/area_path = area_type
	var/area/area_instance = initial(area_path.unique)? (GLOB.areas_by_type[area_path] || new area_path) : new area_path

	var/found_a_spot = FALSE

	var/how_many_wide = ceil(width / TURF_CHUNK_RESOLUTION)
	var/how_many_high = ceil(height / TURF_CHUNK_RESOLUTION)
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
						if(!(checking.turf_flags & UNUSED_RESERVATION_TURF))
							passing = FALSE
							break
					if(!passing)
						break
				if(!passing)
					continue
				BL = locate(1 + TURF_CHUNK_RESOLUTION * (outer_x - 1), 1 + TURF_CHUNK_RESOLUTION * (outer_y - 1), level_index)
				TR = locate(BL.x + width - 1, BL.y + height - 1, BL.z)
				final = block(BL, TR)
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
		SSmapping.reservation_blocking_op = FALSE
		return FALSE
	for(var/turf/T as anything in final)
		T.turf_flags &= ~UNUSED_RESERVATION_TURF
		if(!isnull(border_type) && (T.type != border_type) && (T.x == BL.x || T.x == TR.x || T.y == BL.y || T.y == TR.y))
			T.ChangeTurf(border_type, border_type)
		else if(T.type != turf_type)
			T.ChangeTurf(turf_type, turf_type)
	// todo: area.assimilate_turfs?
	area_instance.contents.Add(final)
	src.reserved_turfs = final.Copy()
	src.bottom_left_coords = list(BL.x, BL.y, BL.z)
	src.top_right_coords = list(TR.x, TR.y, TR.z)
	src.width = width
	src.height = height
	allocated = TRUE
	SSmapping.reservation_blocking_op = FALSE
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
