/// Used by players to ask badmins to do things for them, but ICly.
/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	msg = sanitize(msg)
	if(!msg)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	// log_prayer("[src.key]/([src.name]): [msg]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, SPAN_DANGER("You cannot pray (muted)."), confidential = TRUE)
			return
		if(src.client.handle_spam_prevention(msg, MUTE_PRAY))
			return

	var/mutable_appearance/cross = mutable_appearance('icons/obj/storage.dmi', "bible")
	var/font_color = "purple"
	var/prayer_type = "PRAYER"
	var/deity
	//TODO: Unshit this when we have some better job and trait systems. @Zandario
	// if(usr.job == JOB_CHAPLAIN)
	if(usr.mind.assigned_role == CHAPLAIN)
		cross.icon_state = "bible"
		font_color = "blue"
		prayer_type = "CHAPLAIN PRAYER"
		if(GLOB.deity)
			deity = GLOB.deity
	// else if(IS_CULTIST(usr))
	// 	cross.icon_state = "tome"
	// 	font_color = "red"
	// 	prayer_type = "CULTIST PRAYER"
	// 	deity = "Nar'Sie"
	else if(isliving(usr))
		// var/mob/living/L = usr
		// if(HAS_TRAIT(L, TRAIT_SPIRITUAL))
		if(usr.mind.isholy == TRUE)
			cross.icon_state = "holylight"
			font_color = "blue"
			prayer_type = "SPIRITUAL PRAYER"

	var/msg_tmp = msg
	// GLOB.requests.pray(usr.client, msg, usr.mind.assigned_role == CHAPLAIN)
	msg = SPAN_ADMINNOTICE("[icon2html(cross, GLOB.admins)][SPAN_BOLD("<font color=[font_color]>[prayer_type][deity ? " (to [deity])" : ""]: </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)] [ADMIN_ST(src)]:")]</b> [SPAN_LINKIFY(msg)]")

	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			if(C.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
				to_chat(C, msg)
				SEND_SOUND(C, sound('sound/effects/ding.ogg'))

	to_chat(usr, SPAN_INFO("You pray to the gods: \"[msg_tmp]\""), confidential = TRUE)

	feedback_add_details("admin_verb", "PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//TODO: Reimplement IA CentcCom message, seems to have been lost to time.
/// Used by communications consoles to message CentCom.
/proc/message_centcom(text, mob/sender, iamessage)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	// GLOB.requests.message_centcom(sender.client, msg)
	msg = SPAN_ADMINNOTICE("<b><font color=orange>[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""]:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)]:</b> [msg]")
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
