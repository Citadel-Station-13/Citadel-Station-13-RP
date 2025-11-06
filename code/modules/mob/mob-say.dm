//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * The transmission end of saycode.
 */

/**
 * Gets everyone (and everything) in a given range that can hear our say / emote.
 *
 * * Does not check if they are blind / deaf / whatever
 * * Not specifying global or exclude observers means observers can only hear if they're in range.
 * * This does **not** check ghost ears/sight prefs.
 *
 * @params
 * * range - tile radius; 0 is 1x1 on yourself, 1 is 3x3, ...
 * * global_observers - all observers are included
 * * exclude_observers - prevent **any** observer from being included. overrides `global_observers`.
 */
/mob/proc/saycode_view_query(range, global_observers, exclude_observers)
	. = get_hearers_in_view(range, src)

	if(exclude_observers)
		for(var/mob/observer/observer in .)
			. -= observer
	else if(global_observers)
		var/list/already_gotten = list()
		for(var/mob/observer/observer in .)
			already_gotten[observer] = TRUE
		for(var/mob/observer/observer in GLOB.ghost_list)
			if(already_gotten[observer])
				continue
			. += observer
