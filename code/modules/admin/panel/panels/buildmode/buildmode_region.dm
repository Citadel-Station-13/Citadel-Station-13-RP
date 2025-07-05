//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_region
	var/turf/bottom_left
	var/turf/top_right

	var/last_set_bottom_left = FALSE

/datum/buildmode_region/proc/is_complete()
	return bottom_left && top_right && bottom_left.z == top_right.z

/datum/buildmode_region/proc/auto_set_next(turf/next_turf)
	if(last_set_bottom_left)
	else

/datum/buildmode_region/proc/measure()
	if(!bottom_left || !top_right)
		return null
	return list(top_right.x - bottom_left.x + 1, top_right.y - bottom_left.y + 1)

/datum/buildmode_region/proc/get_turfs()
	if(!bottom_left || !top_right)
		return null
	return block(bottom_left, top_right)

/datum/buildmode_region/proc/get_ordered_turfs(assumed_direction = NORTH)
	if(!bottom_left || !top_right)
		return null
	return SSgrids.get_ordered_turfs(
		bottom_left.x,
		top_right.x,
		bottom_left.y,
		top_right.y, bottom_left.z,
		assumed_direction,
	)

/datum/buildmode_region/proc/get_translation_turfs_at_centered(turf/to_center, for_direction = NORTH)
	if(!bottom_left || !top_right)
		return null
	#warn make sure we fit

/datum/buildmode_region/proc/get_translation_turfs_at_lower_left(turf/to_lower_left, for_direction = NORTH)
	if(!bottom_left || !top_right)
		return null
	#warn make sure we fit

