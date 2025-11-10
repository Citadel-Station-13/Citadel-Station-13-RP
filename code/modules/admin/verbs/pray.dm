//TODO: Reimplement IA CentcCom message, seems to have been lost to time.
/// Used by communications consoles to message CentCom.
/proc/message_centcom(text, mob/sender, iamessage)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	// GLOB.requests.message_centcom(sender.client, msg)
	msg = SPAN_ADMINNOTICE("<b><font color=orange>[uppertext((LEGACY_MAP_DATUM).boss_short)]M[iamessage ? " IA" : ""]:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)]:</b> [msg]")
	// to_chat(GLOB.admins, msg, confidential = TRUE)
	for(var/client/C in GLOB.admins)
		if((R_ADMIN | R_MOD) & C.holder.rights)
			to_chat(C, msg)
			SEND_SOUND(C, sound('sound/machines/signal.ogg'))

	for(var/obj/machinery/computer/communications/console in GLOB.machines)
		console.override_cooldown()


/// Used by communications consoles to message the Syndicate
/proc/message_syndicate(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	// GLOB.requests.message_syndicate(sender.client, msg)
	msg = SPAN_ADMINNOTICE("<b><font color=crimson>ILLEGAL:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_SYNDICATE_REPLY(sender)]:</b> [msg]")
	// to_chat(GLOB.admins, msg, confidential = TRUE)
	for(var/client/C in GLOB.admins)
		if((R_ADMIN | R_MOD) & C.holder.rights)
			to_chat(C, msg)
			SEND_SOUND(C, sound('sound/machines/signal.ogg'))

	for(var/obj/machinery/computer/communications/console in GLOB.machines)
		console.override_cooldown()
