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

/datum/turf_reservation/proc/reserve(width, height, zlevel)
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
	var/how_many_wide = FLOOR(width / RESERVED_TURF_RESOLUTION, 1)
	var/how_many_high = FLOOR(height / RESERVED_TURF_RESOLUTION, 1)
	var/total_many_wide = FLOOR(world.maxx / RESERVED_TURF_RESOLUTION, 1)
	var/total_many_high = FLOOR(world.maxy / RESERVED_TURF_RESOLUTION, 1)
	// the dreaded 5 deep for loop
	while((level_index = pick_n_take(possible_levels)))
		/**
		 * here's the magic
		 * because reservations are aligned to RESERVED_TURF_RESOLUTION,
		 * we just have to check the start spots, since we always align to them.
		 *
		 * bottom-right turfs on reservations align to 0 * RESERVED_TURF_RESOLUTION + 1, 1 * RESERVED_TURF_RESOLUTION + 1, 2 * RESERVED_TURF_RESOLUTION + 1, ...
		 */
		for(var/outer_x in 1 to (total_many_wide - how_many_wide + 1))
			for(var/outer_y in 1 to (total_many_high - how_many_high + 1))
				var/passing = TRUE
				for(var/inner_x in outer_x to outer_x + how_many_wide - 1)
					for(var/inner_y in outer_y to outer_y + how_many_high - 1)
						var/turf/checking = locate(1 + RESERVED_TURF_RESOLUTION * (inner_x - 1), 1 + RESERVED_TURF_RESOLUTION * (inner_y - 1), level_index)
						if(!(checking.turf_flags & UNUSED_RESERVATION_TURF))
							passing = FALSE
							break
					if(!passing)
						break
				if(!passing)
					continue
				BL = locate(1 + RESERVED_TURF_RESOLUTION * (outer_x - 1), 1 + RESERVED_TURF_RESOLUTION * (outer_y - 1), level_index)
				TR = locate(BL.x + width - 1, BL.y + height - 1, BL.z)
				final = block(BL, TR)
				found_a_spot = TRUE
				break
			if(found_a_spot)
				break
		if(found_a_spot)
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
		if(T.loc != area_instance)
			T.loc = area_instance
	src.reserved_turfs = final.Copy()
	src.bottom_left_coords = list(BL.x, BL.y, BL.z)
	src.top_right_coords = list(TR.x, TR.y, TR.z)
	src.width = width
	src.height = height
	allocated = TRUE
	SSmapping.reservation_blocking_op = FALSE
	SSmapping.reservations += src
	return TRUE
