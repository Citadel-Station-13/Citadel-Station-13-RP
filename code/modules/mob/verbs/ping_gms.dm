//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Pinging GMs, the verb. See 'gm_pings.dm' for more in admin panels folder.
 * * This is a mob and not a client verb to discourage using it from the lobby.
 *   This is not an adminhelp feature.
 */
// TODO: DECLARE_MOB_VERB
/mob/verb/ping_gms(atom/target as null|obj|mob|turf in world)
	set name = "Ping GMs"
	set category = VERB_CATEGORY_OOC
	set desc = "Ping staff about something you want them to know about for the IC world. \
	This can be you doing something to an event entity, a prayer from your character, \
	and more. This however, should not be for OOC admin ticketing."

	if(target)
		var/is_valid_atom = isloc(target.loc) && !(target.atom_flags & (ATOM_NONWORLD|ATOM_ABSTRACT))
		if(!is_valid_atom)
			to_chat(src, SPAN_BOLDANNOUNCE("<center>-- GM ping rejected: [target] is not a valid in-world entity. --"))
			return

	if(TIMER_COOLDOWN_CHECK(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS))
		to_chat(src, SPAN_BOLDANNOUNCE("<center>-- GM ping is on cooldown. Slow down. --"))
		return

	if(client?.prefs?.muted & MUTE_PRAY)
		TIMER_COOLDOWN_START(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS, 4 SECONDS)
		tgui_alert_async(
			src,
		"You cannot use GM pings because you've been muted from them by staff.",
			"GM Ping Rejected",
		)
		return

	if(isobserver(src) && !GLOB.gm_ping_ghost_allowed)
		TIMER_COOLDOWN_START(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS, 4 SECONDS)
		tgui_alert_async(
			src,
			"GM pings for ghosts are currently disabled.",
			"GM Ping Rejected",
		)
		return

	// Snapshot origin data before they potentially move.
	var/turf/creating_at = get_turf(src)
	if(!creating_at)
		TIMER_COOLDOWN_START(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS, 4 SECONDS)
		tgui_alert_async(
			src,
			"You cannot use GM pings from your current location. If you are stuck and on a black screen, admin help.",
			"GM Ping Rejected",
		)
		return

	var/minimum_length = 16
	var/input_data = tgui_input_text(
		src,
		"Type a message to send to staff. This must at least be [minimum_length] characters, \
		and your message should be neutrally narrated, including for prayers. \
		This is for GMs, so any online staff who can run events and round interference; \
		this is not for admin-tickets regarding OOC matters and complaints. You may use saycode formatting \
		in your message, e.g. \"+bold+ |italics| _underline_ ~strikethrough~\" format.",
		"Pinging GMs[target ? " @ [target]" : ""]",
		"",
		8192,
		TRUE,
		FALSE,
	)

	if(!input_data)
		return

	if(length_char(input_data) < minimum_length)
		to_chat(src, SPAN_BOLDANNOUNCE("<center>-- GM ping rejected: Your message was too short. --"))
		return

	if(TIMER_COOLDOWN_CHECK(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS))
		to_chat(src, SPAN_BOLDANNOUNCE("<center>-- GM ping is on cooldown. Slow down. Your message was [SPAN_TOOLTIP(input_data, "this")] --"))
		return

	TIMER_COOLDOWN_START(src, TIMER_CD_INDEX_MOB_VERB_PING_GMS, 5 SECONDS)

	var/message_to_admins = input_data
	var/sanitized = say_emphasis(html_encode(message_to_admins))

	if(QDELETED(src))
		return
	if(!ckey)
		return

	var/datum/gm_ping/creating_ping = new

	creating_ping.originating_ckey = ckey
	creating_ping.originating_key = key
	creating_ping.originating_mob_weakref = WEAKREF(src)
	creating_ping.link_context(target)
	creating_ping.created_at = creating_at
	creating_ping.unsanitized_message = message_to_admins

	log_admin("[key_name(src)] created a (UID: [creating_ping.lazy_unsafe_uid]) GM ping[target ? " with context-target '[target]' ([target.type]) ([REF(target.type)])" : ""] \
		and content '[message_to_admins]'")

	var/rendered = SPAN_TOOLTIP_DANGEROUS_HTML(SPAN_LINKIFY(sanitized), "message")
	// TODO: make opening the panel a link.
	message_admins("<b>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]</b> is pinging GMs with a [rendered] at [ADMIN_COORDJMP(loc)][target ? " regarding '[target]'" : ""]. Open the GM Ping panel to interact with it.")
	to_chat(src, SPAN_BOLDNOTICE("<center>-- You send a [rendered] to game staff. --</center>"))

	// TODO: soundbyte this.
	for(var/client/admin_client in GLOB.admins)
		SEND_SOUND(admin_client, sound('sound/effects/ding.ogg'))

	GLOB.gm_pings += creating_ping
