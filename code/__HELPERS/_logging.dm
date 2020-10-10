//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define WRITE_LOG(log, text) rustg_log_write(log, text)

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#else
#define testing(msg)
#endif

#ifdef UNIT_TESTS
/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)
#endif


/* Items with ADMINPRIVATE prefixed are stripped from public logs. */
/proc/log_admin(text)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMIN: [text]")

/proc/log_admin_private(text)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: [text]")

/proc/log_adminsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_modsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "MODSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_eventsay(text, mob/speaker)
	if (config_legacy.log_adminchat)
		WRITE_LOG(GLOB.world_game_log, "EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_adminpm(text, client/source, client/dest)
	admin_log.Add(text)
	if (config_legacy.log_admin)
		WRITE_LOG(GLOB.world_game_log, "ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)]")

/* All other items are public. */
/proc/log_game(text)
	if (config_legacy.log_game)
		WRITE_LOG(GLOB.world_game_log, "GAME: [text]")

/proc/log_asset(text)
	WRITE_LOG(GLOB.world_asset_log, "ASSET: [text]")

/proc/log_access(text)
	WRITE_LOG(GLOB.world_game_log, "ACCESS: [text]")

/// <VStation_specific>
/proc/log_access_in(client/new_client)
	if (config_legacy.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		WRITE_LOG(GLOB.world_game_log, "ACCESS IN: [message]")

/proc/log_access_out(mob/last_mob)
	if (config_legacy.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:Logged Out - BYOND Logged Out"
		WRITE_LOG(GLOB.world_game_log, "ACCESS OUT: [message]")
/// </VStation_specific>

/proc/log_attack(attacker, defender, message)
	if (config_legacy.log_attack)
		WRITE_LOG(GLOB.world_attack_log, "ATTACK: [attacker] against [defender]: [message]")

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

/proc/log_whisper(text, mob/speaker)
	if (config_legacy.log_whisper)
		WRITE_LOG(GLOB.world_game_log, "WHISPER: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"

/proc/log_emote(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "EMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"

/proc/log_subtle(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle_anti_ghost(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLER: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_aooc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "AOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>AOOC:</u> - <span style=\"color:red\"><b>[text]</b></span>"

/proc/log_looc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "LOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>LOOC:</u> - <span style=\"color:orange\"><b>[text]</b></span>"

/proc/log_vote(text)
	if (config_legacy.log_vote)
		WRITE_LOG(GLOB.world_game_log, "VOTE: [text]")

/proc/log_topic(text)
	WRITE_LOG(GLOB.world_game_log, "TOPIC: [text]")

/proc/log_href(text)
	WRITE_LOG(GLOB.world_href_log, "HREF: [text]")

/proc/log_qdel(text)
	WRITE_LOG(GLOB.world_qdel_log, "QDEL: [text]")

/proc/log_subsystem(subsystem, text)
	WRITE_LOG(GLOB.subsystem_log, "[subsystem]: [text]")

/* Log to both DD and the logfile. */
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(GLOB.world_runtime_log, text)
#endif
	SEND_TEXT(world.log, text)

/* Log to the logfile only. */
/proc/log_runtime(text)
	WRITE_LOG(GLOB.world_runtime_log, text)

/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)

/proc/log_mapping(text)
	WRITE_LOG(GLOB.world_map_error_log, text)

/* For logging round startup. */
/proc/start_log(log)
	WRITE_LOG(log, "Starting up round ID [GLOB.round_id].\n-------------------------")

/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	rustg_log_close_all()

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([AREACOORD(T)])"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"

/* Helper procs for building detailed log lines */
/proc/key_name(whom, include_link = null, include_name = TRUE, highlight_special_characters = TRUE)
	var/mob/M
	var/client/C
	var/key
	var/ckey
	var/fallback_name

	if(!whom)
		return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		C = GLOB.directory[ckey]
		if(C)
			M = C.mob
	else if(istype(whom, /datum/mind))
		var/datum/mind/mind = whom
		key = mind.key
		ckey = ckey(key)
		if(mind.current)
			M = mind.current
			if(M.client)
				C = M.client
		else
			fallback_name = mind.name
	else // Catch-all cases if none of the types above match
		var/swhom = null

		if(istype(whom, /atom))
			var/atom/A = whom
			swhom = "[A.name]"
		else if(istype(whom, /datum))
			swhom = "[whom]"

		if(!swhom)
			swhom = "*invalid*"

		return "\[[swhom]\]"

	. = ""

	if(!ckey)
		include_link = FALSE

	if(key)
		if(C && C.holder && C.holder.fakekey && !include_name)
			if(include_link)
				. += "<a href='?priv_msg=[REF(C)]'>"
			. += "Administrator"
		else
			if(include_link)
				. += "<a href='?priv_msg=[REF(ckey)]'>"
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	if(include_name)
		var/name = "*invalid*"
		if(M)
			if(M.real_name)
				name = M.real_name
			else if(M.name)
				name = M.name
		else if(fallback_name)
			name = fallback_name

		if(include_link && is_special_character(M) && highlight_special_characters)
			name = "<font color='#FFA500'>[name]</font>" //Orange

		. += "/([name])"

	return .

/proc/key_name_admin(whom, include_name = TRUE)
	return key_name(whom, TRUE, include_name)



/// VSTATION SPECIFIC LOGGING. ///
/proc/log_debug(text)
	if (config_legacy.log_debug)
		WRITE_LOG(GLOB.world_runtime_log, "DEBUG: [text]")

	for(var/client/C in admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			to_chat(C, "DEBUG: [text]")

/proc/log_ghostsay(text, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style=\"color:green\">[text]</span>"
	GLOB.round_text_log += "<font size=1><span style=\"color:#7e668c\"><b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"

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

/// DEPRICATED. USE log_runtime(text) INSTEAD.
/proc/log_error(text)
	log_runtime(text)
	world.log << text

/proc/log_misc(text)
	WRITE_LOG(GLOB.world_game_log, "MISC: [text]")

/proc/log_unit_test(text)
	log_world("## UNIT_TEST: [text]")

/proc/report_progress(var/progress_message)
	admin_notice("<span class='boldannounce'>[progress_message]</span>", R_DEBUG)
	log_world(progress_message)

/proc/log_nsay(text, inside, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_nme(text, inside, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")


/// VSTATION LOGGING HELPERS ///

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
	return "[key_name(src)] ([AREACOORD(src)])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([AREACOORD(mob)])"
