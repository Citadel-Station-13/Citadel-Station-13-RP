// Wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define DIRECT_INPUT(A, B) A >> B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define READ_FILE(file, text) DIRECT_INPUT(file, text)
#ifdef EXTOOLS_LOGGING
// proc hooked, so we can just put in standard TRUE and FALSE
#define WRITE_LOG(log, text) extools_log_write(log,text,TRUE)
#define WRITE_LOG_NO_FORMAT(log, text) extools_log_write(log,text,FALSE)
#else
// This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")
#endif
// Print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

// Not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

// Print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")

GLOBAL_LIST_INIT(testing_global_profiler, list("_PROFILE_NAME" = "Global"))
// We don't really check if a word or name is used twice, be aware of that
#define testing_profile_start(NAME, LIST) LIST[NAME] = world.timeofday
#define testing_profile_current(NAME, LIST) round((world.timeofday - LIST[NAME])/10,0.1)
#define testing_profile_output(NAME, LIST) testing("[LIST["_PROFILE_NAME"]] profile of [NAME] is [testing_profile_current(NAME,LIST)]s")
#define testing_profile_output_all(LIST) { for(var/_NAME in LIST) { testing_profile_current(,_NAME,LIST); }; };
#else
#define testing(msg)
#define testing_profile_start(NAME, LIST)
#define testing_profile_current(NAME, LIST)
#define testing_profile_output(NAME, LIST)
#define testing_profile_output_all(LIST)
#endif

#define testing_profile_global_start(NAME) testing_profile_start(NAME,GLOB.testing_global_profiler)
#define testing_profile_global_current(NAME) testing_profile_current(NAME, GLOB.testing_global_profiler)
#define testing_profile_global_output(NAME) testing_profile_output(NAME, GLOB.testing_global_profiler)
#define testing_profile_global_output_all testing_profile_output_all(GLOB.testing_global_profiler)

#define testing_profile_local_init(PROFILE_NAME) var/list/_timer_system = list( "_PROFILE_NAME" = PROFILE_NAME, "_start_of_proc" = world.timeofday )
#define testing_profile_local_start(NAME) testing_profile_start(NAME, _timer_system)
#define testing_profile_local_current(NAME) testing_profile_current(NAME, _timer_system)
#define testing_profile_local_output(NAME) testing_profile_output(NAME, _timer_system)
#define testing_profile_local_output_all testing_profile_output_all(_timer_system)

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)
#endif

#if defined(REFERENCE_DOING_IT_LIVE)
#define log_reftracker(msg) log_harddel("## REF SEARCH [msg]")

/proc/log_harddel(text)
	WRITE_LOG(GLOB.harddel_log, text)

#elif defined(REFERENCE_TRACKING) // Doing it locally
#define log_reftracker(msg) log_world("## REF SEARCH [msg]")

#else //Not tracking at all
#define log_reftracker(msg)
#endif

/**
 * Items with ADMINPRIVATE prefixed are stripped from public logs.
 */
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
		if(speaker)
			WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: ASAY: [speaker.simple_info_line()]: [text]")
		else
			WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: ASAY: [text]")

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

/**
 * All other items are public.
 */
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
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style='color:#32cd32'>[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style='color:#32cd32'>[text]</span>"

/proc/log_ooc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "OOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>OOC:</u> - <span style='color:blue'><b>[text]</b></span>"

/proc/log_whisper(text, mob/speaker)
	if (config_legacy.log_whisper)
		WRITE_LOG(GLOB.world_game_log, "WHISPER: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style='color:gray'><i>[text]</i></span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style='color:gray'><i>[text]</i></span>"

/proc/log_emote(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "EMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style='color:#CCBADC'>[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style='color:#CCBADC'>[text]</span>"

/proc/log_subtle(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle_anti_ghost(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLER: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_aooc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "AOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>AOOC:</u> - <span style='color:red'><b>[text]</b></span>"

/proc/log_looc(text, client/user)
	if (config_legacy.log_ooc)
		WRITE_LOG(GLOB.world_game_log, "LOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>LOOC:</u> - <span style='color:orange'><b>[text]</b></span>"

/proc/log_vote(text)
	if (config_legacy.log_vote)
		WRITE_LOG(GLOB.world_game_log, "VOTE: [text]")

/proc/log_topic(text)
	WRITE_LOG(GLOB.world_game_log, "TOPIC: [text]")

/proc/log_href(text)
	WRITE_LOG(GLOB.world_href_log, "HREF: [text]")

/proc/log_sql(text)
	WRITE_LOG(GLOB.sql_error_log, "SQL: [text]")

/proc/log_query_debug(text)
	// does nothing right now, sorry

/proc/log_qdel(text)
	WRITE_LOG(GLOB.world_qdel_log, "QDEL: [text]")

/proc/log_subsystem(subsystem, text)
	WRITE_LOG(GLOB.subsystem_log, "[subsystem]: [text]")

/**
 * Log to both DD and the logfile.
 */
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(GLOB.world_runtime_log, text)
#endif
	SEND_TEXT(world.log, text)

/**
 * Log to the logfile only.
 */
/proc/log_runtime(text)
	WRITE_LOG(GLOB.world_runtime_log, text)

/**
 * Rarely gets called; just here in case the config breaks.
 */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)

/proc/log_mapping(text)
	WRITE_LOG(GLOB.world_map_error_log, text)

/**
 * For logging round startup.
 */
/proc/start_log(log)
	WRITE_LOG(log, "Starting up round ID [GLOB.round_id].\n-------------------------")

/**
 * Appends a tgui-related log entry.
 * All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window && window.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	WRITE_LOG(GLOB.tgui_log, entry)

/**
 * Close open log handles.
 * This should be called as late as possible, and no logging should hapen after.
 */
/proc/shutdown_logging()
#ifdef EXTOOLS_LOGGING
	extools_finalize_logging()
#else
	rustg_log_close_all()
#endif

/**
 * Helper procs for building detailed log lines
 */
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

/// VSTATION SPECIFIC LOGGING. ///
/proc/log_debug(text)
	if (config_legacy.log_debug)
		WRITE_LOG(GLOB.world_runtime_log, "DEBUG: [text]")

	for(var/client/C in GLOB.admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			to_chat(C,
				type = MESSAGE_TYPE_DEBUG,
				html = "DEBUG: [text]",
				confidential = TRUE,
			)

/proc/log_ghostsay(text, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style='color:green'>[text]</span>"
	GLOB.round_text_log += "<font size=1><span style='color:#7e668c'><b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"

/proc/log_ghostemote(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_adminwarn(text)
	if (config_legacy.log_adminwarn)
		WRITE_LOG(GLOB.world_game_log, "ADMINWARN: [html_decode(text)]")

/proc/log_pda(text, mob/speaker)
	if (config_legacy.log_pda)
		WRITE_LOG(GLOB.world_game_log, "PDA: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style='color:green'>[text]</span>"
	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style='color:green'>[text]</span>"

/proc/error(msg)
	log_world("## ERROR: [msg]")

/// DEPRICATED. USE log_runtime(text) INSTEAD.
/proc/log_error(text)
	log_runtime(text)
	world.log << text

/proc/log_misc(text)
	WRITE_LOG(GLOB.world_game_log, "MISC: [text]")

/proc/log_unit_test(text)
	log_world("## UNIT_TEST: [text]")

/proc/report_progress(progress_message)
	admin_notice(SPAN_BOLDANNOUNCE("[progress_message]"), R_DEBUG)
	log_world(progress_message)

/proc/log_nsay(text, inside, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_nme(text, inside, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")


/// VSTATION LOGGING HELPERS ///

/**
 * Pretty print a direction bitflag, can be useful for debugging.
 */
/proc/print_dir(dir)
	var/list/comps = list()
	if(dir & NORTH)
		comps += "NORTH"
	if(dir & SOUTH)
		comps += "SOUTH"
	if(dir & EAST)
		comps += "EAST"
	if(dir & WEST)
		comps += "WEST"
	if(dir & UP)
		comps += "UP"
	if(dir & DOWN)
		comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")


/**
 * Helper procs for building detailed log lines.
 */
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

/proc/log_info_line(datum/datum)
	if(!datum)
		return "*null*"
	if(!istype(datum))
		return json_encode(datum)
	return datum.log_info_line()

/mob/proc/simple_info_line()
	return "[key_name(src)] ([AREACOORD(src)])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([AREACOORD(mob)])"

/**
 * Writes to a special log file if the log_suspicious_login config flag is set,
 * which is intended to contain all logins that failed under suspicious circumstances.
 *
 * Mirrors this log entry to log_access when access_log_mirror is TRUE, so this proc
 * doesn't need to be used alongside log_access and can replace it where appropriate.
 */
/proc/log_suspicious_login(text, access_log_mirror = TRUE)
	if (CONFIG_GET(flag/log_suspicious_login))
		WRITE_LOG(GLOB.world_suspicious_login_log, "SUSPICIOUS_ACCESS: [text]")
	if(access_log_mirror)
		log_access(text)
