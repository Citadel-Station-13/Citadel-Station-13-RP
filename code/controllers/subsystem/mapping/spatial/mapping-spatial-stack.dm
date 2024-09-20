//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get all turfs in the zstack up/down from the given turf.
 */
/datum/controller/subsystem/mapping/proc/get_turfs_within_stack(turf/T)
	var/list/stack = get_z_stack(T.z)
	if(isnull(stack))
		return list(T)
	. = list()
	for(var/z in stack)
		. += locate(T.x, T.y, z)
