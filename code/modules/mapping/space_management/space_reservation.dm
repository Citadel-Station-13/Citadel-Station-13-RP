//Yes, they can only be rectangular.
//Yes, I'm sorry.
/datum/turf_reservation
	var/datum/turf_bounds/turf_bounds				//If you're accessing it from something else, keep in mind that this is NOT nulled/deleted/otherwise tracked when the reservation is released. It's up to you to deal with that.
	var/wipe_reservation_on_release = TRUE
	var/turf_type = STANDARD_RESERVED_TURF_TYPE

/datum/turf_reservation/transit
	turf_type = STANDARD_TRANSIT_TURF_TYPE

/datum/turf_reservation/proc/Release()
	var/list/turfs = turf_bounds.get_turfs()
	for(var/i in turfs)
		SSmapping.used_turfs -= i
	SSmapping.reserve_turfs(turfs)
	turf_bounds = null							//the reason we're not just qdeling the bounds is it should gc automatically, other stuff might be using it. Might.

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
	turf_bounds.set_using_corners(BL, TR)
	for(var/i in turf_bounds.get_turfs())
		var/turf/T = i
		T.flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.unused_turfs["[T.z]"] -= T
		SSmapping.used_turfs[T] = src
		T.ChangeTurf(turf_type, turf_type)
	return TRUE

/datum/turf_reservation/New()
	LAZYADD(SSmapping.turf_reservations, src)

/datum/turf_reservation/Destroy()
	Release()
	LAZYREMOVE(SSmapping.turf_reservations, src)
	return ..()
