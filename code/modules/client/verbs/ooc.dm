/client/verb/motd()
	set name = "MOTD"
	set category = "OOC"
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
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	if(!is_preference_enabled(/datum/client_preference/show_ooc))
		to_chat(src, "<span class='warning'>You have OOC muted.</span>")
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
	// if(is_banned_from(ckey, "OOC"))
	// 	to_chat(src, "<span class='danger'>You have been banned from OOC.</span>")
	// 	return
	if(QDELETED(src))
		return

	msg = sanitize(msg)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)

	if((msg[1] in list(".",";",":","#") || findtext_char(msg, "say", 1, 5))) //SSticker.HasRoundStarted() &&
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


	if(!is_preference_enabled(/datum/client_preference/show_ooc))
		to_chat(src, "<span class='warning'>You have OOC muted.</span>")
		return

	log_ooc(raw_msg, src)

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
			if(holder && !holder.fakekey && (holder.rights & R_ADMIN) && CONFIG_GET(flag/allow_admin_ooccolor)) // keeping this for the badmins
				to_chat(target, "<span class='prefix [ooc_style]'><span class='ooc'><font color='[prefs.ooccolor]'>" + "OOC: " + "<EM>[display_name]: </EM><span class='linkify'>[msg]</span></span></span></font>")
			else
				to_chat(target, "<span class='ooc'><span class='[ooc_style]'><span class='message'>OOC: <EM>[display_name]: </EM><span class='linkify'>[msg]</span></span></span></span>")

/client/proc/looc_wrapper()
	var/message = input("","looc (text)") as text|null
	if(message)
		looc(message)

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
	// Resleeving shenanigan prevention.
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.original_player && H.original_player != H.ckey) //In a body not their own
			display_name = "[H.mind.name] (as [H.name])"

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

	msg = emoji_parse(msg)

	// Send a message
	for(var/client/target in receivers)
		var/admin_stuff = ""

		if(target in admins)
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

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

	// Fetch the client's aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		return	// You're already good fam.

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculate and apply our best estimate
	// +4 pixels are for the eidth of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			return	// Success!

		// Calculate a probable delta value based on the diff
		else if (isnull(delta))
			delta = 100 * (desired_width - got_width) / split_width

		// If we overshot, halve the delta and reverse direction
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")
