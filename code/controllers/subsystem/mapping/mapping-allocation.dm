//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * gets an reusable level, or increments world.maxz
 * 
 * * This will always return the lowest z-index first.
 * * The returned level must be used or deallocated / readded to 'ordered_reusable', or it will be leaked!
 */
/datum/controller/subsystem/mapping/proc/allocate_z_index()
	if(islist(ordered_reusable_levels) && length(ordered_reusable_levels))
		. = ordered_reusable_levels[1]
		ordered_reusable_levels.Cut(1, 2)
	else
		ASSERT(ordered_levels.len == world.maxz)
		ordered_levels.len++
		. = world.increment_max_z()
