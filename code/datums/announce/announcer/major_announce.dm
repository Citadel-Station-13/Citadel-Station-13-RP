/datum/announcer/major_announce
	name = "Major Announcement"
	desc = "Legacy command report style announcements."

/datum/announcer/major_announce/SendText(source, name, message, list/affected)
	var/list/assembled = list()



	var/msg = assembled.Join("")
	for(var/mob/M in affected)
		to_chat(M, msg)


#warn old command report/emergency shuttle

/proc/priority_announce(text, title = "", sound, type , sender_override, has_important_message)
	if(!text)
		return

	var/announcement
	if(!sound)
		sound = "attention"

	if(type == "Priority")
		announcement += "<h1 class='alert'>Priority Announcement</h1>"
		if (title && length(title) > 0)
			announcement += "<br><h2 class='alert'>[html_encode(title)]</h2>"
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Captain Announces</h1>"
		GLOB.news_network.SubmitArticle(html_encode(text), "Captain's Announcement", "Station Announcements", null)

	else
		if(!sender_override)
			announcement += "<h1 class='alert'>[command_name()] Update</h1>"
		else
			announcement += "<h1 class='alert'>[sender_override]</h1>"
		if (title && length(title) > 0)
			announcement += "<br><h2 class='alert'>[html_encode(title)]</h2>"

		if(!sender_override)
			if(title == "")
				GLOB.news_network.SubmitArticle(text, "Central Command Update", "Station Announcements", null)
			else
				GLOB.news_network.SubmitArticle(title + "<br><br>" + text, "Central Command", "Station Announcements", null)

	///If the announcer overrides alert messages, use that message.
	// if(SSstation.announcer.custom_alert_message && !has_important_message)
	// 	announcement +=  SSstation.announcer.custom_alert_message
	// else
	announcement += "<br>[span_alert("[html_encode(text)]")]<br>"
	announcement += "<br>"

	var/s = sound(get_announcer_sound(sound))
	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear())
			to_chat(M, announcement)
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				SEND_SOUND(M, s)
