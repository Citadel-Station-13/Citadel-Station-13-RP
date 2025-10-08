//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/saycode_view_query(range, global_observers, exclude_observers)
	. = ..()

/mob/observer/dead/process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	. = ..()
	. = SPAN_DEADSAY(.)

/mob/observer/dead/emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)
	SHOULD_NOT_SLEEP(TRUE)
	var/raw_html

	var/list/atom/movable/heard = saycode_view_query(subtle ? 1 : GLOB.game_view_radius, TRUE, anti_ghost)

	// todo: legacy code
	for(var/atom/movable/hearing in heard)
		if(ismob(hearing))
			var/mob/hearing_mob = hearing
			hearing_mob.show_message(raw_html, saycode_type)

		else if(isobj(hearing))
			var/obj/hearing_obj = hearing
			hearing_obj.see_emote(src, raw_html, 2)
	#warn impl

	// todo: legacy code
	if(with_overhead)
		say_overhead(raw_html, FALSE, GLOB.game_view_radius)
