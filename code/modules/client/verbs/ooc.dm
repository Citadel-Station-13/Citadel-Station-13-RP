// todo: most of the things in here should probably be re-thought category wise;
// verticality for one is more graphics/visuals
// but isn't a preference because it's something you need to actively see at some times but not others..

/client/verb/toggle_verticality_visibility()
	set name = "Toggle Verticality Plane"
	set desc = "Toggle if you see ceiling overlays and similar."
	set category = VERB_CATEGORY_OOC

	var/atom/movable/screen/plane_master/plane = global_planes.by_plane_type(/atom/movable/screen/plane_master/verticality)
	plane.alpha = plane.alpha == 255? 0 : 255
	to_chat(src, SPAN_NOTICE("You now [plane.alpha == 255? "see" : "no longer see"] verticality overlays."))


/client/verb/motd()
	set name = "MOTD"
	set category = VERB_CATEGORY_OOC
	set desc ="Check the Message of the Day"

	var/motd = config.motd
	if(motd)
		to_chat(src, "<blockquote class=\"motd\">[motd]</blockquote>", handle_whitespace=FALSE)
	else
		to_chat(src, "<span class='notice'>The Message of the Day has not been set.</span>")
	to_chat(src, getAlertDesc())

/client/proc/getAlertDesc()
	var/color
	var/desc
	//borrow the same colors from the fire alarms
	switch(get_security_level())
		if("green")
			color = "#00ff00"
			desc = "" //no special description if nothing special is going on
		if("yellow")
			color = "#ffff00"
			desc = CONFIG_GET(string/alert_desc_yellow_upto)
		if("violet")
			color = "#9933ff"
			desc = CONFIG_GET(string/alert_desc_violet_upto)
		if("orange")
			color = "#ff9900"
			desc = CONFIG_GET(string/alert_desc_orange_upto)
		if("blue")
			color = "#1024A9"
			desc = CONFIG_GET(string/alert_desc_blue_upto)
		if("red")
			color = "#ff0000"
			desc = CONFIG_GET(string/alert_desc_red_upto)
		if("delta")
			color = "#FF6633"
			desc = CONFIG_GET(string/alert_desc_delta)
	. = SPAN_NOTICE("<br>The alert level on \the [station_name()] is currently: <font color=[color]>Code [capitalize(get_security_level())]</font>. [desc]")

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

	msg = sanitize(msg)
	var/raw_msg = msg

	if(!msg)
		return

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

/client/proc/looc_wrapper()
	var/message = input("","looc (text)") as text|null
	if(message)
		looc(message)

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = VERB_CATEGORY_OOC

	if(!reject_on_initialization_block())
		return
	if(!reject_age_unverified())
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	if(SSbans.t_is_role_banned_ckey(ckey, role = BAN_ROLE_OOC) && IS_DEAD(mob))
		to_chat(src, SPAN_WARNING("You are banned from typing in LOOC while dead, and deadchat."))
		return

	msg = sanitize(msg)
	if(!msg)
		return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/looc))
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

	if(msg)
		handle_spam_prevention(MUTE_OOC)

	var/mob/source = mob.get_looc_source()
	var/turf/T = get_turf(source)
	if(!T)
		return
	var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
	var/list/m_viewers = in_range["mobs"]

	var/list/receivers = list() //Clients, not mobs.
	var/list/r_receivers = list()

	var/display_name = get_public_key()
	if(mob.stat != DEAD)
		display_name = mob.name
	// Resleeving shenanigan prevention.
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.original_player && H.original_player != H.ckey) //In a body not their own
			display_name = "[H.mind.name] (as [H.name])"

	// Everyone in normal viewing range of the LOOC
	for(var/mob/viewer in m_viewers)
		if(viewer.client && viewer.client.get_preference_toggle(/datum/game_preference_toggle/chat/looc))
			receivers |= viewer.client
		else if(istype(viewer,/mob/observer/eye)) // For AI eyes and the like
			var/mob/observer/eye/E = viewer
			if(E.owner && E.owner.client)
				receivers |= E.owner.client

	// Admins with RLOOC displayed who weren't already in
	for(var/client/admin in GLOB.admins)
		if(!(admin in receivers) && admin.get_preference_toggle(/datum/game_preference_toggle/admin/global_looc))
			r_receivers |= admin

	msg = emoji_parse(msg)

	if(persistent.ligma)
		to_chat(src, "<span class='looc'>" +  "LOOC: " + "<EM>[display_name]: </EM><span class='message'><span class='linkify'>[msg]</span></span></span>")
		log_shadowban("[key_name(src)] LOOC: [msg]")
		return

	log_looc(msg,src)

	// Send a message
	for(var/client/target in receivers)
		var/admin_stuff = ""

		if(target in GLOB.admins)
			admin_stuff += "/([key])"

		to_chat(target, "<span class='looc'>" +  "LOOC: " + "<EM>[display_name][admin_stuff]: </EM><span class='message'><span class='linkify'>[msg]</span></span></span>")

	for(var/client/target in r_receivers)
		var/admin_stuff = "/([key])([admin_jump_link(mob, target.holder)])"

		to_chat(target, "<span class='looc'>" + "LOOC: " + " <span class='prefix'>(R)</span><EM>[display_name][admin_stuff]: </EM> <span class='message'><span class='linkify'>[msg]</span></span></span>")

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src
