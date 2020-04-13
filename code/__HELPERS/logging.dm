
/proc/log_admin(text)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMIN: [text]")

/proc/log_admin_private(text)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: [text]")

/proc/log_adminpm(text, client/source, client/dest)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)]")

/proc/log_debug(text)
	if (config_legacy.log_debug)
		WRITE_LOG(GLOB.world_runtime_log, "DEBUG: [text]")

	for(var/client/C in admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			C << "DEBUG: [text]"

/proc/log_game(text)
	if (config_legacy.log_game)
		WRITE_LOG(GLOB.world_game_log, "GAME: [text]")

/proc/log_vote(text)
	if (config_legacy.log_vote)
		WRITE_LOG(GLOB.world_game_log, "VOTE: [text]")

/proc/log_access_in(client/new_client)
	if (config_legacy.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		WRITE_LOG(GLOB.world_game_log, "ACCESS IN: [message]")

/proc/log_access_out(mob/last_mob)
	if (config_legacy.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:Logged Out - BYOND Logged Out"
		WRITE_LOG(GLOB.world_game_log, "ACCESS OUT: [message]")

/proc/log_say(text, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "SAY: [speaker.simple_info_line()]: [html_decode(text)]")

	//Log the message to in-game dialogue logs, as well.
	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"

/proc/log_ooc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "OOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>OOC:</u> - <span style=\"color:blue\"><b>[text]</b></span>"

/proc/log_aooc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "AOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>AOOC:</u> - <span style=\"color:red\"><b>[text]</b></span>"

/proc/log_looc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "LOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>LOOC:</u> - <span style=\"color:orange\"><b>[text]</b></span>"

/proc/log_whisper(text, mob/speaker)
	if (config_legacy.log_whisper)
		WRITE_LOG(GLOB.world_game_log, "WHISPER: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"

/proc/log_access(text)
	WRITE_LOG(GLOB.world_game_log, "ACCESS: [text]")

/proc/log_emote(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "EMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"

/proc/log_attack(attacker, defender, message)
	if (config_legacy.log_attack)
		WRITE_LOG(GLOB.world_attack_log, "ATTACK: [attacker] against [defender]: [message]")

/proc/log_adminsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_modsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "MODSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_eventsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_ghostsay(text, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style=\"color:green\">[text]</span>"
	GLOB.round_text_log += "<font size=1><span style=\"color:#7e668c\"><b>([time_stamp()])</b> (<b>[src]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"


/proc/log_ghostemote(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_adminwarn(text)
	if (config_legacy.log_adminwarn)
		WRITE_LOG(GLOB.world_game_log, "ADMINWARN: [html_decode(text)]")

/proc/log_pda(text, mob/speaker)
	if (config_legacy.log_pda)
		WRITE_LOG(GLOB.world_game_log, "PDA: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"
	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"

/proc/log_error(text)
	world.log << text
	WRITE_LOG(GLOB.world_runtime_log, "RUNTIME: [text]")

/proc/log_misc(text)
	WRITE_LOG(GLOB.world_game_log, "MISC: [text]")

/proc/log_unit_test(text)
	world.log << "## UNIT_TEST: [text]"

/proc/report_progress(var/progress_message)
	admin_notice("<span class='boldannounce'>[progress_message]</span>", R_DEBUG)
	log_world(progress_message)

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
//Always return "Something/(Something)", even if it's an error message.
/proc/key_name(var/whom, var/include_link = FALSE, var/include_name = TRUE, var/highlight_special_characters = TRUE)
	var/mob/M
	var/client/C
	var/key

	if(!whom)
		return "INVALID/INVALID"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "INVALID/([D.type])"
	else if(istext(whom))
		return "AUTOMATED/[whom]" //Just give them the text back
	else
		return "INVALID/INVALID"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C]'>"

		if(C && C.holder && C.holder.fakekey)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "INVALID"

	if(include_name)
		var/name = "INVALID"
		if(M)
			if(M.real_name)
				name = M.real_name
			else if(M.name)
				name = M.name

			if(include_link && is_special_character(M) && highlight_special_characters)
				name = "<font color='#FFA500'>[name]</font>" //Orange

		. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for building detailed log lines
/datum/proc/log_info_line()
	return "[src] ([type])"

/atom/log_info_line()
	var/turf/t = get_turf(src)
	if(istype(t))
		return "([t]) ([t.x],[t.y],[t.z]) ([t.type])"
	else if(loc)
		return "([loc]) (0,0,0) ([loc.type])"
	else
		return "(NULL) (0,0,0) (NULL)"

/mob/log_info_line()
	return "[..()] ([ckey])"

/proc/log_info_line(var/datum/d)
	if(!d)
		return "*null*"
	if(!istype(d))
		return json_encode(d)
	return d.log_info_line()

/mob/proc/simple_info_line()
	return "[key_name(src)] ([x],[y],[z])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([mob.x],[mob.y],[mob.z])"
