//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/saycode_view_query(range, global_observers, exclude_observers)
	if(global_observers)
		return GLOB.ghost_list.Copy()
	. = list()
	for(var/mob/observer/observer as anything in GLOB.ghost_list)
		var/list/already_gotten = list()
		for(var/mob/observer/observer in .)
			already_gotten[observer] = TRUE
		for(var/mob/observer/observer in GLOB.ghost_list)
			if(already_gotten[observer])
				continue
			. += observer

/mob/observer/dead/process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	. = ..()
	. = SPAN_DEADSAY(.)
