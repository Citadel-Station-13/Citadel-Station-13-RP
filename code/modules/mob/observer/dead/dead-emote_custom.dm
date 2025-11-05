//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/saycode_view_query(range, global_observers, exclude_observers)
	if(global_observers)
		return GLOB.ghost_list.Copy()
	. = list()
	for(var/mob/observer/observer as anything in GLOB.ghost_list)
		if(get_dist(src, observer) <= range)
			. += observer

/mob/observer/dead/run_custom_emote(emote_text, subtle, anti_ghost, saycode_type, datum/event_args/actor/actor, with_overhead)
	// Now watch, as I violate a codebase best practice for shits and giggles.
	if(!usr)
		return FALSE
	if(usr != src)
		to_chat(usr, SPAN_DANGER("How did you just try to emote as another player's ghost?"))
		return FALSE
	// Validated to be 'self' at this point.
	if(!client)
		return FALSE
	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send deadchat emotes (muted)."))
		return FALSE
	if(!get_preference_toggle(/datum/game_preference_toggle/chat/dsay))
		to_chat(src, SPAN_DANGER("You have deadchat muted."))
		return FALSE
	if(!config_legacy.dsay_allowed && !check_rights(show_msg = FALSE, C = client))
		to_chat(src, SPAN_DANGER("Deadchat is globally muted."))
		return FALSE
	if(SSbans.t_is_role_banned_ckey(ckey, role = BAN_ROLE_OOC))
		to_chat(src, SPAN_DANGER("You are banned from OOC and deadchat."))
		return FALSE
	if(subtle)
		to_chat(src, SPAN_DANGER("Why are you trying to subtle emote as a ghost?"))
		return FALSE
	if(anti_ghost)
		to_chat(src, SPAN_DANGER("Why are you trying to anti-ghost emote as a ghost?"))
		return FALSE

	log_ghostemote(emote_text, src)
	var/raw_html = process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	if(!raw_html)
		return
	emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)

/mob/observer/dead/process_custom_emote(emote_text, subtle, anti_ghost, saycode_type, with_overhead)
	. = emote_text
	. = html_encode(emote_text)
	. = say_emphasis(.)
	. = SPAN_DEADSAY(emoji_parse(.))

/mob/observer/dead/emit_custom_emote(raw_html, subtle, anti_ghost, saycode_type, with_overhead)
	say_dead_direct(raw_html, src)
