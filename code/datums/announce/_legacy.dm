/**
 * old shitcode
 * you are not allowed to use this for new
 */


// Most of this file has been changed to use the Eris-style PA announcements.
// You'll need to compare externally, or use your best judgement when merging.
/var/datum/legacy_announcement/priority/priority_announcement = new(do_log = 0)
/var/datum/legacy_announcement/priority/command/command_announcement = new(do_log = 0, do_newscast = 1)

/datum/legacy_announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Station Announcements"
	var/announcement_type = "Announcement"

/datum/legacy_announcement/New(var/do_log = 0, var/new_sound = null, var/do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/legacy_announcement/priority/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/legacy_announcement/priority/command/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "[command_name()] Update"
	announcement_type = "[command_name()] Update"

/datum/legacy_announcement/priority/security/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/legacy_announcement/proc/Announce(var/message as text, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0, zlevel)
	if(!message)
		return
	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
	message_title = sanitizeSafe(message_title)

	var/list/zlevels
	if(zlevel)
		zlevels = GLOB.using_map.get_map_levels(zlevel, TRUE)

	Message(message, message_title, zlevels)
	if(do_newscast)
		NewsCast(message, message_title)
	Sound(message_sound, zlevels)
	Log(message, message_title)

/datum/legacy_announcement/proc/Message(message as text, message_title as text, var/list/zlevels)
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, "<h2 class='alert'>[title]</h2>")
			to_chat(M, "<span class='alert'>[message]</span>")
			if (announcer)
				to_chat(M, "<span class='alert'> -[html_encode(announcer)]</span>")

/datum/legacy_announcement/minor/Message(message as text, message_title as text, var/list/zlevels)
	GLOB.global_announcer.autosay(message, announcer ? announcer : ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/legacy_announcement/priority/Message(var/message as text, var/message_title as text, var/list/zlevels)
	GLOB.global_announcer.autosay("<span class='alert'>[message_title]:</span> [message]", announcer ? announcer : ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/legacy_announcement/priority/command/Message(var/message as text, var/message_title as text, var/list/zlevels)
	GLOB.global_announcer.autosay("<span class='alert'>[command_name()] - [message_title]:</span> [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/legacy_announcement/priority/security/Message(var/message as text, var/message_title as text, var/list/zlevels)
	GLOB.global_announcer.autosay("<span class='alert'>[message_title]:</span> [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

datum/legacy_announcement/proc/NewsCast(message as text, message_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/legacy_announcement/proc/PlaySound(var/message_sound, var/list/zlevels)
	for(var/mob/M in player_list)
		if(zlevels && !(M.z in zlevels))
			continue
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			SEND_SOUND(M, 'sound/soundbytes/announcer/preamble.ogg')

	if(!message_sound)
		return

	spawn(22) // based on length of preamble.ogg + arbitrary delay
		for(var/mob/M in player_list)
			if(zlevels && !(M.z in zlevels))
				continue
			if(!istype(M,/mob/new_player) && !isdeaf(M))
				SEND_SOUND(M, message_sound)

/datum/legacy_announcement/proc/Sound(var/message_sound, var/list/zlevels)
	PlaySound(message_sound, zlevels)

datum/legacy_announcement/priority/Sound(var/message_sound)
	if(message_sound)
		SEND_SOUND(world, message_sound)

datum/legacy_announcement/priority/command/Sound(var/message_sound)
	PlaySound(message_sound)

datum/legacy_announcement/proc/Log(message as text, message_title as text)
	if(log)
		log_game("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/proc/GetNameAndAssignmentFromId(var/obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard \the [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/proc/ion_storm_announcement()
	command_announcement.Announce("It has come to our attention that \the [station_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")

/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message)
	if (SSticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		AnnounceArrivalSimple(character.real_name, rank, join_message)

/proc/AnnounceArrivalSimple(var/name, var/rank = "visitor", var/join_message = "will arrive at the station shortly")
	GLOB.global_announcer.autosay(join_message, "Arrivals Announcement Computer")
