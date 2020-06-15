/client/verb/fix_chat()
	set name = "Fix chat"
	set category = "OOC"
	if (!chatOutput || !istype(chatOutput))
		var/action = alert(src, "Invalid Chat Output data found!\nRecreate data?", "Wot?", "Recreate Chat Output data", "Cancel")
		if (action != "Recreate Chat Output data")
			return
		chatOutput = new /datum/chatOutput(src)
		chatOutput.start()
		action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum")
		else
			chatOutput.load()
			action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by re-creating the chatOutput datum and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", "is-visible=true;is-disabled=false")
					winset(src, "browseroutput", "is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after recreating the chatOutput and forcing a load()")

	else if (chatOutput.loaded)
		var/action = alert(src, "ChatOutput seems to be loaded\nDo you want me to force a reload, wiping the chat log or just refresh the chat window because it broke/went away?", "Hmmm", "Force Reload", "Refresh", "Cancel")
		switch (action)
			if ("Force Reload")
				chatOutput.loaded = FALSE
				chatOutput.start() //this is likely to fail since it asks , but we should try it anyways so we know.
				action = alert(src, "Goon chat reloading, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a start()")
				else
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a start() and forcing a load()")

			if ("Refresh")
				chatOutput.showChat()
				action = alert(src, "Goon chat refreshing, wait a bit and tell me if it's fixed", "", "Fixed", "Nope, force a reload")
				if (action == "Fixed")
					log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a show()")
				else
					chatOutput.loaded = FALSE
					chatOutput.load()
					action = alert(src, "How about now? (give it a moment)", "", "Yes", "No")
					if (action == "Yes")
						log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by forcing a load()")
					else
						action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
						if (action == "Switch to old chat")
							winset(src, "output", "is-visible=true;is-disabled=false")
							winset(src, "browseroutput", "is-visible=false")
						log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window forcing a show() and forcing a load()")
		return

	else
		chatOutput.start()
		var/action = alert(src, "Manually loading Chat, wait a bit and tell me if it's fixed", "", "Fixed", "Nope")
		if (action == "Fixed")
			log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start()")
		else
			chatOutput.load()
			action = alert(src, "How about now? (give it a moment (it may also try to load twice))", "", "Yes", "No")
			if (action == "Yes")
				log_game("GOONCHAT: [key_name(src)] Had to fix their goonchat by manually calling start() and forcing a load()")
			else
				action = alert(src, "Welp, I'm all out of ideas. Try closing byond and reconnecting.\nWe could also disable fancy chat and re-enable oldchat", "", "Thanks anyways", "Switch to old chat")
				if (action == "Switch to old chat")
					winset(src, "output", list2params(list("on-show" = "", "is-disabled" = "false", "is-visible" = "true")))
					winset(src, "browseroutput", "is-disabled=true;is-visible=false")
				log_game("GOONCHAT: [key_name(src)] Failed to fix their goonchat window after manually calling start() and forcing a load()")


/client/verb/motd()
	set name = "MOTD"
	set category = "OOC"
	set desc ="Check the Message of the Day"

	var/motd = global.config.motd //it's global! and it's real!
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)
	else
		to_chat(src, "<span class='notice'>The Message of the Day has not been set.</span>")

/client/proc/ooc_wrapper()
	var/message = input("","ooc (text)") as text|null
	if(message)
		ooc(message)

/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(src, "<span class='warning'>Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(!is_preference_enabled(/datum/client_preference/show_ooc))
		to_chat(src, "<span class='warning'>You have OOC muted.</span>")
		return

	if(!holder)
		if(!config_legacy.ooc_allowed)
			to_chat(src, "<span class='danger'>OOC is globally muted.</span>")
			return
		if(!config_legacy.dooc_allowed && (mob.stat == DEAD))
			to_chat(src, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc(msg, src)

	if(msg)
		handle_spam_prevention(MUTE_OOC)

	var/ooc_style = "everyone"
	if(holder && !holder.fakekey)
		ooc_style = "elevated"
		if(holder.rights & R_EVENT)
			ooc_style = "event_manager"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	for(var/client/target in GLOB.clients)
		if(target.is_preference_enabled(/datum/client_preference/show_ooc))
			if(target.is_key_ignored(key)) // If we're ignored by this person, then do nothing.
				continue
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(target.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			if(holder && !holder.fakekey && (holder.rights & R_ADMIN) && config_legacy.allow_admin_ooccolor && (src.prefs.ooccolor != initial(src.prefs.ooccolor))) // keeping this for the badmins
				to_chat(target, "<font color='[src.prefs.ooccolor]'><span class='ooc'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")
			else
				to_chat(target, "<span class='ooc'><span class='[ooc_style]'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></span>")

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(src, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	if(!msg)
		return

	if(!is_preference_enabled(/datum/client_preference/show_looc))
		to_chat(src, "<span class='danger'>You have LOOC muted.</span>")
		return

	if(!holder)
		if(!config_legacy.looc_allowed)
			to_chat(src, "<span class='danger'>LOOC is globally muted.</span>")
			return
		if(!config_legacy.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, "<span class='danger'>OOC for dead mobs has been turned off.</span>")
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, "<span class='danger'>You cannot use OOC (muted).</span>")
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_looc(msg,src)

	if(msg)
		handle_spam_prevention(MUTE_OOC)

	var/mob/source = mob.get_looc_source()
	var/turf/T = get_turf(source)
	if(!T) return
	var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
	var/list/m_viewers = in_range["mobs"]

	var/list/receivers = list() //Clients, not mobs.
	var/list/r_receivers = list()

	var/display_name = key
	if(holder && holder.fakekey)
		display_name = holder.fakekey
	if(mob.stat != DEAD)
		display_name = mob.name
	//VOREStation Add - Resleeving shenanigan prevention
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.original_player && H.original_player != H.ckey) //In a body not their own
			display_name = "[H.mind.name] (as [H.name])"
	//VOREStation Add End

	// Everyone in normal viewing range of the LOOC
	for(var/mob/viewer in m_viewers)
		if(viewer.client && viewer.client.is_preference_enabled(/datum/client_preference/show_looc))
			receivers |= viewer.client
		else if(istype(viewer,/mob/observer/eye)) // For AI eyes and the like
			var/mob/observer/eye/E = viewer
			if(E.owner && E.owner.client)
				receivers |= E.owner.client

	// Admins with RLOOC displayed who weren't already in
	for(var/client/admin in admins)
		if(!(admin in receivers) && admin.is_preference_enabled(/datum/client_preference/holder/show_rlooc))
			r_receivers |= admin

	// Send a message
	for(var/client/target in receivers)
		var/admin_stuff = ""

		if(target in admins)
			admin_stuff += "/([key])"

		to_chat(target, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", target) + " <EM>[display_name][admin_stuff]:</EM> <span class='message'>[msg]</span></span></span>")

	for(var/client/target in r_receivers)
		var/admin_stuff = "/([key])([admin_jump_link(mob, target.holder)])"

		to_chat(target, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", target) + " <span class='prefix'>(R)</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[msg]</span></span></span>")

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src
