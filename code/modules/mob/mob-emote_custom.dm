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
 * * THE INPUT EMOTE TEXT IS NOT SANITIZED AT THIS STAGE.
 */
/mob/proc/run_custom_emote(emote_text, subtle, anti_ghost, saycode_type = SAYCODE_TYPE_VISIBLE, datum/event_args/actor/actor, with_overhead)
	if(stat)
		// TODO: tooltip with copy link.
		to_chat(src, SPAN_WARNING("You are unable to emote."))
		return
	if(isnull(actor))
		actor = new(src)

	// raw preprocessed text is used
	// var/log_string = "[key_name(src)] ([AREACOORD(src)])[actor?.initiator != src ? " (initiated by [key_name(actor.initiator)] at [AREACOORD(actor.initiator)])" : ""]: [emote_text]"
	var/log_string = "[actor?.initiator != src ? " (initiated by [key_name(actor.initiator)] at [AREACOORD(actor.initiator)]) " : ""][emote_text]"

	if(anti_ghost)
		// implicit
		subtle = TRUE

	if(subtle)
		if(anti_ghost)
			log_subtle_anti_ghost(log_string, src)
		else
			log_subtle(log_string, src)
	else
		log_emote(log_string, src)

	var/raw_html = process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	if(!raw_html)
		return
	emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)

/**
 * Perform special preprocessing on an incoming custom emote
 * * The base level will html_encode().
 * * THE INPUT EMOTE TEXT IS NOT SANITIZED AT THIS STAGE.
 *
 * @return raw HTML
 */
/mob/proc/process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	. = emote_text
	. = html_encode(.)
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
	var/list/atom/movable/heard = saycode_view_query(subtle ? 1 : GLOB.game_view_radius, TRUE, anti_ghost)
	// TODO: centralized observer pref check in saycode_view_query
	var/optimize_this_later_max_number = world_view_max_number() + 2
	var/mob/filtered_mobs = list()
	// todo: legacy code
	for(var/atom/movable/hearing in heard)
		if(ismob(hearing))
			var/mob/hearing_mob = hearing
			if(isobserver(hearing_mob))
				if((get_dist(hearing_mob, src) > optimize_this_later_max_number) && !hearing_mob.get_preference_toggle(/datum/game_preference_toggle/observer/ghost_sight))
					continue
				if(subtle && !hearing_mob.get_preference_toggle(/datum/game_preference_toggle/observer/ghost_subtle))
					continue
			SEND_SIGNAL(hearing_mob, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, src, raw_html, subtle, anti_ghost, saycode_type)
			hearing_mob.show_message(raw_html, saycode_type)
			filtered_mobs += hearing
		else if(isobj(hearing))
			var/obj/hearing_obj = hearing
			hearing_obj.see_emote(src, raw_html, 2)
	var/turf/our_loc = get_turf(src)
	var/use_sfx = subtle ? /datum/soundbyte/talksound/generic_subtle_emote_1 : /datum/soundbyte/talksound/generic_emote_1
	// todo: cache this or maybe just have a distinction between regular hear and 'observer heard us from far away'?
	var/max_vocal_cue_dist = world_view_max_number()
	for(var/mob/M as anything in filtered_mobs)
		if(M.get_preference_toggle(/datum/game_preference_toggle/game/vocal_cues) && get_dist(M, src) <= max_vocal_cue_dist)
			M.playsound_local(our_loc, use_sfx, 50, TRUE)
	if(with_overhead)
		say_overhead(raw_html, FALSE, GLOB.game_view_radius, passed_hearing_list = filtered_mobs)
