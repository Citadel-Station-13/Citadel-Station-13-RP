//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Checks if a firemode is preferred right now
 */
/obj/item/gun/proc/is_preferred_firemode(datum/firemode/firemode)
	return TRUE

/**
 * Picks the next firemode.
 *
 * @return /datum/firemode instance
 */
/obj/item/gun/proc/get_next_firemode(prefer_nonlethal) as /datum/firmeode
	// todo: this is just for compatibility when 'firemode' becomes a variable
	var/datum/firemode/firemode = legacy_get_firemode()

	var/datum/firemode/first_found
	var/datum/firemode/preferred
	if(!firemode)
		for(var/datum/firemode/potential as anything in firemodes)
			if(!first_found)
				first_found = potential
			if(!is_preferred_firemode(potential))
				continue
			preferred = potential
			break
	else
		var/current_index = firemodes.Find(firemode)
		if(!current_index)
			CRASH("can't find current firemode in firemodes")
		for(var/i in current_index + 1 to length(firemodes))
			var/datum/firemode/potential = firemodes[i]
			if(!first_found)
				first_found = potential
			if(!is_preferred_firemode(potential))
				continue
			preferred = potential
			break
		if(!preferred)
			for(var/i in 1 to current_index - 1)
				var/datum/firemode/potential = firemodes[i]
				if(!first_found)
					first_found = potential
				if(!is_preferred_firemode(potential))
					continue
				preferred = potential
				break

	return preferred || first_found
