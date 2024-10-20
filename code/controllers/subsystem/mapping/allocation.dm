//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * equivalent to SSzclear
 * prototype system to wipe a zlevel
 *
 * ! Warning: this is frankly a shitty system and you shouldn't rely on it
 * ! Yes, I am warning you right now that this code is not great.
 * I included it out of boredom
 * There's genuinely no good way to handle this in BYOND.
 * This is slow, will probably cause a lot of harddels due to objects behaving badly,
 * and will just generally caused grief.
 *
 * I do not recommend anyone use this unless they absolutely know what they're doing.
 * (if you think you need this, you probably don't, to be blunt.)
 */
/datum/controller/subsystem/mapping
	// list of levels ready for reuse
	var/static/list/reusable_levels = list()

// todo: recover()
// todo: zclear system will be in this later, for now, this is just a wrapper

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	// just to make sure order of ops / assumptions are right
	ASSERT(length(ordered_levels) == world.maxz)

/**
 * gets an reusable level, or increments world.maxz
 * WARNING: AFTER THIS, YOU NEED TO USE THE LEVEL, OR READD TO REUSABLE, OR THIS IS A MEMORY LEAK!
 */
/datum/controller/subsystem/mapping/proc/allocate_z_index()
	if(islist(reusable_levels) && length(reusable_levels))
		. = reusable_levels[1]
		reusable_levels.Cut(1, 2)
	else
		ASSERT(ordered_levels.len == world.maxz)
		ordered_levels.len++
		. = world.increment_max_z()
