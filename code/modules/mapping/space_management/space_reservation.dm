/datum/turf_bounds
	var/list/turfs		//lazyaccessed
	var/turf/bottom_left_turf
	var/turf/top_right_turf
	var/bottom_left_coords[3]
	var/top_right_coords[3]
	var/width = 0
	var/height = 0

/datum/turf_bounds/Destroy()
	turfs.Cut()
	return ..()

/datum/turf_bounds/proc/get_turfs()
	return SANITIZE_LIST(turfs)

/datum/turf_bounds/proc/get_bottom_left()
	return bottom_left_turf

/datum/turf_bounds/proc/get_top_right()
	return top_right_turf

/datum/turf_bounds/proc/get_coords_bottom_left()
	return bottom_left_coords

/datum/turf_bounds/proc/get_coords_top_right()
	return top_right_coords

/datum/turf_bounds/proc/add_turf(turf/T)
	LAZYADD(turfs, T)

/datum/turf_bounds/proc/remove_turf(turf/T)
	LAZYREMOVE(turfs, T)

/datum/turf_bounds/proc/refit_to_world()
	return set_rectangle(bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3], top_right_coords[1], top_right_coords[2], top_right_coords[3], TRUE, TRUE)

/datum/turf_bounds/proc/set_rectangle(BLX, BLY, BLZ, TRX, TRY, TRZ, autoset_turfs = FALSE, automatic_clamp = FALSE)
	if(automatic_clamp)
		BLX = CLAMP(BLX, 0, world.maxx)
		TRX = CLAMP(TRX, BLX, world.maxx)
		BLY = CLAMP(BLY, 0, world.maxy)
		TRY = CLAMP(TRY, BLY, world.maxy)
		BLZ = CLAMP(BLZ, 0, world.maxz)
		TRZ = CLAMP(TRZ, BLZ, world.maxz)
	bottom_left_turf = locate(BLX, BLY, BLZ)
	top_right_turf = locate(TRX, TRY, TRZ)
	if(!bottom_left_turf || !top_right_turf)
		CRASH("Warning: turf_bounds/proc/set_rectangle() attemped to index turfs not in the world!")
	bottom_left_coords = list(BLX, BLY, BLZ)
	top_right_coords = list(TRX, TRY, TRZ)
	if(autoset_turfs)
		turfs = block(bottom_left_turf, top_right_turf)

//Yes, they can only be rectangular.
//Yes, I'm sorry.
/datum/turf_reservation
	var/datum/turf_bounds/bounds
	var/wipe_reservation_on_release = TRUE
	var/turf_type = STANDARD_RESERVED_TURF_TYPE

/datum/turf_reservation/transit
	turf_type = STANDARD_TRANSIT_TURF_TYPE

/datum/turf_reservation/proc/Release()
	var/v = reserved_turfs.Copy()
	for(var/i in bounds.turfs)
		reserved_turfs -= i
		SSmapping.used_turfs -= i
	SSmapping.reserve_turfs(v)

/datum/turf_reservation/proc/Reserve(width, height, zlevel)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		return FALSE
	var/list/avail = SSmapping.unused_turfs["[zlevel]"]
	var/turf/BL
	var/turf/TR
	var/list/turf/final = list()
	var/passing = FALSE
	for(var/i in avail)
		CHECK_TICK
		BL = i
		if(!(BL.flags & UNUSED_RESERVATION_TURF))
			continue
		if(BL.x + width > world.maxx || BL.y + height > world.maxy)
			continue
		TR = locate(BL.x + width - 1, BL.y + height - 1, BL.z)
		if(!(TR.flags & UNUSED_RESERVATION_TURF))
			continue
		final = block(BL, TR)
		if(!final)
			continue
		passing = TRUE
		for(var/I in final)
			var/turf/checking = I
			if(!(checking.flags & UNUSED_RESERVATION_TURF))
				passing = FALSE
				break
		if(!passing)
			continue
		break
	if(!passing || !istype(BL) || !istype(TR))
		return FALSE
	bottom_left_coords = list(BL.x, BL.y, BL.z)
	top_right_coords = list(TR.x, TR.y, TR.z)
	for(var/i in final)
		var/turf/T = i
		reserved_turfs |= T
		T.flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.unused_turfs["[T.z]"] -= T
		SSmapping.used_turfs[T] = src
		T.ChangeTurf(turf_type, turf_type)
	bounds.width = width
	bounds.height = height
	return TRUE

/datum/turf_reservation/New()
	LAZYADD(SSmapping.turf_reservations, src)

/datum/turf_reservation/Destroy()
	Release()
	LAZYREMOVE(SSmapping.turf_reservations, src)
	return ..()
