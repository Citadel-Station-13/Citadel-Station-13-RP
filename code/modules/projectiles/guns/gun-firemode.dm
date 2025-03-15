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
/obj/item/gun/proc/get_next_firemode(prefer_nonlethal) as /datum/firemode
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
	switch(length(firemodes))
		if(0)
			return
		if(1)
			if(firemode && (!request_firemode || (request_firemode == firemode)))
				return
	var/datum/firemode/switch_to = (request_firemode && (request_firemode in firemodes) && request_firemode) ||	\
		(firemodes_use_radial ? user_firemode_radial(actor) : get_next_firemode())
	set_firemode(switch_to)
	actor.chat_feedback(
		SPAN_NOTICE("[src] is now set to [switch_to.name]."),
		target = src,
	)
	playsound(src, selector_sound, 50, TRUE)

/obj/item/gun/proc/user_firemode_radial(datum/event_args/actor/actor)
	var/atom/use_anchor = inv_inside ? inv_inside.owner : src
	var/list/use_choices = list()
	for(var/datum/firemode/firemode as anything in firemodes)
		use_choices[firemode] = firemode.fetch_radial_appearance()
	return show_radial_menu(actor.initiator, use_anchor, use_choices, require_near = TRUE)
