//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: DECLARE_MOB_VERB
/mob/verb/ping_gms(atom/target as null|obj|mob|turf in world)
	set name = "Ping GMs"
	set category = VERB_CATEGORY_OOC
	set desc = "Ping staff about something you want them to know about for the IC world. \
	This can be you doing something to an event entity, a prayer from your character, \
	and more. This however, should not be for OOC admin ticketing."

	#warn verb cooldown

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

	if(length_char(input_data) < minimum_length)
		to_chat(src, SPAN_BOLDANNOUNCE("<center>-- GM ping rejected: Your message was too short. --"))
		return

	#warn apply verb cooldown

	var/message_to_admins = input_data

	if(QDELETED(src))
		return
	if(!ckey)
		return

	var/datum/gm_ping/creating_ping = new

	creating_ping.originating_ckey = ckey
	creating_ping.originating_mob_weakref = WEAKREF(src)
	creating_ping.link_context(target)

	#warn log & message admins

	GLOB.gm_pings += creating_ping
