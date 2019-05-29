/datum/turf_bounds
	var/list/turfs
	var/lazy_turfs = TRUE				//set to true unless performance is CRITICAL/it's being looped over MANY times.
	var/turf/bottom_left_turf
	var/turf/top_right_turf
	var/bottom_left_coords[3]
	var/top_right_coords[3]
	var/width = 0
	var/height = 0

/datum/turf_bounds/Destroy()
	turfs = null
	bottom_left_turf = null
	top_right_turf = null
	bottom_left_coords = null
	top_right_coords = null
	return ..()

/datum/turf_bounds/proc/get_turfs()
	return turfs || block(bottom_left_turf, top_right_turf)

/datum/turf_bounds/proc/get_bottom_left()
	return bottom_left_turf

/datum/turf_bounds/proc/get_top_right()
	return top_right_turf

/datum/turf_bounds/proc/get_coords_bottom_left()
	return bottom_left_coords

/datum/turf_bounds/proc/get_coords_top_right()
	return top_right_coords

/datum/turf_bounds/proc/refit_to_world()
	return set_rectangle_coordinates(bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3], top_right_coords[1], top_right_coords[2], top_right_coords[3], TRUE)

/datum/turf_bounds/proc/set_rectangle_coordinates(BLX, BLY, BLZ, TRX, TRY, TRZ, automatic_clamp = FALSE)
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
	width = TRX - BLX
	height = TRY - BLY
	if(!lazy_turfs)
		turfs = block(bottom_left_turf, top_right_turf)
	else
		turfs = null

/datum/turf_bounds/proc/set_using_corners(turf/bottom_left, turf/top_right, autoset_turfs = FALSE)
	return set_rectangle_coordinates(bottom_left.x, bottom_left.y, bottom_left.z, top_right.x, top_right.y, top_right.z, autoset_turfs, FALSE)
