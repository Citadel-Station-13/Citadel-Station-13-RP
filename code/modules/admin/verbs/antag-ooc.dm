GLOBAL_VAR_INIT(AOOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_aooc_colour, "#ce254f")

/client/proc/aooc(msg as text)
	set name = "AOOC"
	set desc = "An OOC channel exclusive to antagonists."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return

	// if(!(prefs.toggles & CHAT_OOC))
	// 	to_chat(src, "<span class='danger'> You have OOC muted.</span>")
	// 	return
	if(jobban_isbanned(mob, "OOC"))
		to_chat(src, "<span class='danger'>You have been banned from OOC.</span>")
		return

	if(!holder) //admins bypass this.
		// if(!GLOB.aooc_allowed)
		// 	to_chat(src, "<span class='danger'>AOOC is currently muted.</span>")
		// 	return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use AOOC (muted).</span>")
			return
		if(!is_special_character(mob))
			to_chat(usr, "<span class='danger'>You aren't an antagonist!</span>")
		if(handle_spam_prevention(MUTE_OOC)) //msg,
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(mob.stat)
			to_chat(usr, "<span class='danger'>You cannot use AOOC while unconscious or dead.</span>")
			return
		// if(isdead(mob))
		// 	to_chat(src, "<span class='danger'>You cannot use AOOC while ghosting.</span>")
		// 	return
		// if(HAS_TRAIT(mob, TRAIT_AOOC_MUTE))
		// 	to_chat(src, "<span class='danger'>You cannot use AOOC right now.</span>")
		// 	return
		var/datum/antagonist/A = get_antag_data(mob.mind.special_role)
		if(!A || !A.can_speak_aooc || !A.can_hear_aooc)
			to_chat(usr, "<span class='warning'>Sorry, but your antagonist type is not allowed to speak in AOOC.</span>")
			return

	if(QDELETED(src))
		return

	msg = sanitize(msg)
	// var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)

	if(!holder)
		if(handle_spam_prevention(MUTE_OOC))//msg,
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in AOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in AOOC: [msg]")
			return

	log_aooc(msg, src)

	var/keyname = key
	// if(prefs.unlock_content)
	// 	if(prefs.toggles & MEMBER_PUBLIC)
	// 		keyname = "<font color='[prefs.aooccolor ? prefs.aooccolor : GLOB.normal_aooc_colour]'>[icon2html('icons/member_content.dmi', world, "blag")][keyname]</font>"
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url

	var/antaglisting = list() //List of valid people

	// for(var/datum/mind/M in get_antag_minds(/datum/antagonist)) //trators
	// 	if(!M.current || !M.current.client || isnewplayer(M.current))
	// 		continue
	// 	antaglisting |= M.current.client
	for(var/mob/M in mob_list)
		if(!M.client || !M.mind || isnewplayer(M))
			continue
		var/datum/antagonist/A = null
		A = get_antag_data(M.mind.special_role)
		if(A?.can_hear_aooc)
			antaglisting |= M.client

	for(var/mob/M in player_list) //admemes & ghosts
		if(M.client && (M.stat == DEAD || M.client.holder) && !isnewplayer(M))
			antaglisting |= M.client

	for(var/client/C in antaglisting)
		if(!C || !istype(C))
			continue
		if(holder)
			if(!holder.fakekey || C.holder)
				if(check_rights((R_ADMIN | R_MOD), FALSE)) //CONFIG_GET(flag/allow_admin_ooccolor) &&
					to_chat(C, "<span class='adminooc'>[prefs.ooccolor ? "<font color=[prefs.ooccolor]>" :"" ]<span class='prefix'>Antag OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span></span></font>")
				else
					to_chat(C, "<span class='adminobserverooc'><span class='prefix'>Antag OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span></span>")
			else
				if(GLOB.AOOC_COLOR)
					to_chat(C, "<font color='[GLOB.AOOC_COLOR]'><b><span class='prefix'>Antag OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></b></font>")
				else
					to_chat(C, "<span class='antagooc'><span class='prefix'>Antag OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></span>")

		else // if(!(key in C.prefs.ignoring))
			if(GLOB.AOOC_COLOR)
				to_chat(C, "<font color='[GLOB.AOOC_COLOR]'><b><span class='prefix'>Antag OOC:</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>")
			else
				to_chat(C, "<span class='antagooc'><span class='prefix'>Antag OOC:</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></span>")
