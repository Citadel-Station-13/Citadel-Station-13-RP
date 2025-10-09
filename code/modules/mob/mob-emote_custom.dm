//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * This module is used for processing custom emotes.
 *
 * Eventually, they'll be used with a proper saycode call-chain and tokenzier
 * to enable language fragment support and more.
 *
 * * Unlike saycode, there's no custom_emote() default wrapper, because custom emotes have so many things to customize.
 */

/**
 * Relay a raw incoming custom emote
 *
 * * Logging happens here.
 */
/mob/proc/run_custom_emote(emote_text, subtle, anti_ghost, saycode_type = SAYCODE_TYPE_VISIBLE, datum/event_args/actor/actor, with_overhead)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	// raw preprocessed text is used
	var/log_string = "[key_name(src)] ([AREACOORD(src)])[actor?.initiator != src ? " (initiated by [key_name(actor.initiator)] at [AREACOORD(actor.initiator)])" : ""]: [emote_text]"

	if(subtle)
		if(anti_ghost)
			log_subtle_anti_ghost(log_string)
		else
			log_subtle(log_string)
	else
		log_emote(log_string)

	var/raw_html = process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	if(!raw_html)
		return
	emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)

/**
 * Perform special preprocessing on an incoming custom emote
 *
 * @return raw HTML
 */
/mob/proc/process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	SHOULD_NOT_SLEEP(TRUE)
	. = emote_text
	. = say_emphasis(.)
	. = "<b>[src]</b> " + .
	if(subtle)
		if(anti_ghost)
			. = SPAN_SINGING(.)
		else
			. = "<i>[.]</i>"

/**
 * Emit a custom emote
 */
/mob/proc/emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)
	SHOULD_NOT_SLEEP(TRUE)
	var/raw_html

	var/list/atom/movable/heard = saycode_view_query(subtle ? 1 : GLOB.game_view_radius, TRUE, anti_ghost)

	// todo: legacy code
	for(var/atom/movable/hearing in heard)
		if(ismob(hearing))
			var/mob/hearing_mob = hearing
			SEND_SIGNAL(hearing_mob, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, raw_html, subtle, anti_ghost, saycode_type)
			hearing_mob.show_message(raw_html, saycode_type)

		else if(isobj(hearing))
			var/obj/hearing_obj = hearing
			hearing_obj.see_emote(src, raw_html, 2)
	#warn impl

	// todo: legacy code
	if(with_overhead)
		say_overhead(raw_html, FALSE, GLOB.game_view_radius)
