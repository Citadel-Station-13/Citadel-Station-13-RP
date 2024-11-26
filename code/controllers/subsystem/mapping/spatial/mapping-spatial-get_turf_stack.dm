//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * get all turfs in the zstack up/down from the given turf.
 *
 * * This is ordered from bottom to top.
 */
/datum/controller/subsystem/mapping/proc/spatial_get_turf_stack(turf/T) as /list
	var/list/stack = level_get_stack(T.z)
	if(isnull(stack))
		return list(T)
	. = list()
	for(var/z in stack)
		. += locate(T.x, T.y, z)
