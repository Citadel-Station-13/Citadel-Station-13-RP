//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Gets the sorted Z stack list of a level - the levels accessible from a single level, in multiz
 */
/datum/controller/subsystem/mapping/proc/level_stack_get_ordered(z) as /list
	if(z_stack_dirty)
		recalculate_z_stack()
	var/list/L = z_stack_lookup[z]
	return L.Copy()
