/client/proc/ooc_wrapper()
	var/message = input("","ooc (text)") as text|null
	if(message)
		ooc(message)

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = VERB_CATEGORY_OOC

	if(!reject_on_initialization_block())
		return
	if(!reject_age_unverified())
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/ooc))
		to_chat(src, "<span class='warning'>You have OOC muted.</span>")
		return

	if(SSbans.t_is_role_banned_ckey(ckey, role = BAN_ROLE_OOC))
		to_chat(src, SPAN_WARNING("You are banned from OOC and deadchat."))
		return

	if(!mob)
		return

	if(!holder)
		if(!config_legacy.ooc_allowed)
			to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
			return
		if(!config_legacy.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return

	if(QDELETED(src))
		return

	// -- HTML ENCODE HERE --
	msg = sanitize_input_ooc(msg)
	// -- END --

	if(!msg)
		return

	var/raw_msg = msg
	msg = emoji_parse(msg)

	if(((msg[1] in list(".",";",":","#")) || findtext_char(msg, "say", 1, 5))) //SSticker.HasRoundStarted() &&
		if(alert("Your message \"[raw_msg]\" looks like it was meant for in game communication, say it in OOC?", "Meant for OOC?", "No", "Yes") != "Yes")
			return

	if(!holder)
		if(handle_spam_prevention(MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return


	if(!get_preference_toggle(/datum/game_preference_toggle/chat/ooc))
		to_chat(src, "<span class='warning'>You have OOC muted.</span>")
		return

	log_ooc(raw_msg, src)

	if(persistent.ligma)
		to_chat(src, "<span class='ooc'><span class='everyone'><span class='message'>OOC: <EM>[src.key]: </EM><span class='linkify'>[msg]</span></span></span></span>")
		log_shadowban("[key_name(src)] OOC: [msg]")
		return

	var/ooc_style = "everyone"
	if(holder && !is_under_stealthmin())
		ooc_style = "elevated"
		if(holder.rights & R_EVENT)
			ooc_style = "event_manager"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	var/effective_color = holder && preferences.get_entry(/datum/game_preference_entry/simple_color/admin_ooc_color)

	for(var/client/target in GLOB.clients)
		if(!target.initialized)
			continue

		if(target.get_preference_toggle(/datum/game_preference_toggle/chat/ooc))
			if(target.is_key_ignored(key)) // If we're ignored by this person, then do nothing.
				continue
			var/display_name
			if(target.holder || target == src)
				display_name = get_revealed_key()
			else
				display_name = get_public_key()
			if(effective_color) // keeping this for the badmins
				to_chat(target, "<span class='prefix [ooc_style]'><span class='ooc'><font color='[effective_color]'>" + "OOC: " + "<EM>[display_name]: </EM><span class='linkify'>[msg]</span></span></span></font>")
			else
				to_chat(target, "<span class='ooc'><span class='[ooc_style]'><span class='message'>OOC: <EM>[display_name]: </EM><span class='linkify'>[msg]</span></span></span></span>")
