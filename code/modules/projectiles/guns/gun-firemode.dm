//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/proc/set_firemode(datum/firemode/firemode, defer_render)
	src.firemode = firemode
	firemode.apply_legacy_variables(src)

	if(!defer_render)
		// todo: only re-render if needed
		update_icon()

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

/obj/item/gun/proc/user_switch_firemodes(datum/event_args/actor/actor, datum/firemode/request_firemode)
	#warn impl

	playsound(src, selector_sound, 50, 1)

// /obj/item/gun/proc/switch_firemodes(mob/user)
// 	if(firemodes.len <= 1)
// 		return null

// 	var/datum/firemode/new_mode = get_next_firemode()
// 	if(new_mode)
// 		sel_mode = firemodes.Find(new_mode)
// 	new_mode.apply_legacy_variables(src)
// 	if(user)
// 		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")
// 	return new_mode
