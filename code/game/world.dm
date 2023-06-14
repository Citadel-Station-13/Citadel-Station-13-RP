#define RESTART_COUNTER_PATH "data/round_counter.txt"

GLOBAL_VAR(restart_counter)

GLOBAL_VAR(topic_status_lastcache)
GLOBAL_LIST(topic_status_cache)

/**
 * World creation
 *
 * Here is where a round itself is actually begun and setup.
 * * db connection setup
 * * config loaded from files
 * * loads admins
 * * Sets up the dynamic menu system
 * * and most importantly, calls initialize on the master subsystem, starting the game loop that causes the rest of the game to begin processing and setting up
 *
 *
 * Nothing happens until something moves. ~Albert Einstein
 *
 * For clarity, this proc gets triggered later in the initialization pipeline, it is not the first thing to happen, as it might seem.
 *
 * Initialization Pipeline:
 * Global vars are new()'ed, (including config, glob, and the master controller will also new and preinit all subsystems when it gets new()ed)
 * Compiled in maps are loaded (mainly centcom). all areas/turfs/objs/mobs(ATOMs) in these maps will be new()ed
 * world/New() (You are here)
 * Once world/New() returns, client's can connect.
 * 1 second sleep
 * Master Controller initialization.
 * Subsystem initialization.
 * Non-compiled-in maps are maploaded, all atoms are new()ed
 * All atoms in both compiled and uncompiled maps are initialized()
 */
/world/New()
#ifdef USE_BYOND_TRACY
	#warn USE_BYOND_TRACY is enabled
	init_byond_tracy()
#endif
	log_world("World loaded at [TIME_STAMP("hh:mm:ss", FALSE)]!")

	var/tempfile = "data/logs/config_error.[GUID()].log"	//temporary file used to record errors with loading config, moved to log directory once logging is set
	// citadel edit: world runtime log removed due to world.log shunt doing that for us
	GLOB.config_error_log = GLOB.world_href_log = GLOB.world_map_error_log = GLOB.world_attack_log = GLOB.world_game_log = tempfile

	world.Profile(PROFILE_START)
	make_datum_reference_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)
	setupgenetics()

	GLOB.revdata = new

	InitTgs()

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])
	config.update_world_viewsize()	//! Since world.view is immutable, we load it here.

	//SetupLogs depends on the RoundID, so lets check
	//DB schema and set RoundID if we can
	SSdbcore.CheckSchemaVersion()
	SSdbcore.SetRoundID()
	SetupLogs()

// #ifndef USE_CUSTOM_ERROR_HANDLER
// 	world.log = file("[GLOB.log_directory]/dd.log")
// #else
// 	if (TgsAvailable())
// 		world.log = file("[GLOB.log_directory]/dd.log") //not all runtimes trigger world/Error, so this is the only way to ensure we can see all of them.
// #endif

	// shunt redirected world log from Master's init back into world log proper, now that logging has been set up.
	shunt_redirected_log()

	config_legacy.post_load()

	if(config && config_legacy.server_name != null && config_legacy.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config_legacy.server_name += " #[(world.port % 1000) / 100]"

	// TODO - Figure out what this is. Can you assign to world.log?
	// if(config && config_legacy.log_runtime)
	// 	log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	GLOB.timezoneOffset = get_timezone_offset()

	callHook("startup")
	//Emergency Fix
	load_mods()
	//end-emergency fix

	src.update_status()

	. = ..()

	// Create frame types.
	populate_frame_types()

	// Create floor types.
	populate_flooring_types()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	//Must be done now, otherwise ZAS zones and lighting overlays need to be recreated.
	createRandomZlevel()

	if(fexists(RESTART_COUNTER_PATH))
		GLOB.restart_counter = text2num(trim(file2text(RESTART_COUNTER_PATH)))
		fdel(RESTART_COUNTER_PATH)

	if(NO_INIT_PARAMETER in params)
		return

	Master.Initialize(10, FALSE, TRUE)

	#ifdef UNIT_TESTS
	HandleTestRun()
	#endif

	if(config_legacy.ToRban)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/ToRban_autoupdate), 5 MINUTES)

/world/proc/InitTgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()

/world/proc/HandleTestRun()
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
	SSticker.start_immediately = TRUE
	CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(RunUnitTests))
#else
	cb = VARSET_CALLBACK(SSticker, force_ending, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), cb, 10 SECONDS))

/world/proc/SetupLogs()
	var/override_dir = params[OVERRIDE_LOG_DIRECTORY_PARAMETER]
	if(!override_dir)
		var/realtime = world.realtime
		var/texttime = time2text(realtime, "YYYY/MM/DD")
		GLOB.log_directory = "data/logs/[texttime]/round-"
		if(GLOB.round_id)
			GLOB.log_directory += "[GLOB.round_id]"
		else
			var/timestamp = replacetext(TIME_STAMP("hh:mm:ss", FALSE), ":", ".")
			GLOB.log_directory += "[timestamp]"
	else
		GLOB.log_directory = "data/logs/[override_dir]"

	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_asset_log = "[GLOB.log_directory]/asset.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.world_qdel_log = "[GLOB.log_directory]/qdel.log"
	GLOB.sql_error_log = "[GLOB.log_directory]/sql.log"
	GLOB.world_map_error_log = "[GLOB.log_directory]/map_errors.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.tgui_log = "[GLOB.log_directory]/tgui.log"
	GLOB.world_reagent_log = "[GLOB.log_directory]/reagents.log"
	GLOB.subsystem_log = "[GLOB.log_directory]/subsystem.log"

#ifdef UNIT_TESTS
	GLOB.test_log = file("[GLOB.log_directory]/tests.log")
	start_log(GLOB.test_log)
#endif
	_setup_logs_boilerplate()
	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.sql_error_log)
	start_log(GLOB.world_qdel_log)
	start_log(GLOB.world_map_error_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.tgui_log)
	start_log(GLOB.subsystem_log)

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently
	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	// This was printed early in startup to the world log and config_error.log,
	// but those are both private, so let's put the commit info in the runtime
	// log which is ultimately public.
	log_runtime(GLOB.revdata.get_log_message())

/world/proc/_setup_logs_boilerplate()

/world/Topic(T, addr, master, key)
	TGS_TOPIC	//redirect to server tools if necessary

	if(!SSfail2topic)
		return "Server not initialized."
	else if(SSfail2topic.IsRateLimited(addr))
		return "Rate limited."

	if(length(T) > CONFIG_GET(number/topic_max_size))
		return "Payload too large!"

	var/static/list/topic_handlers = TopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if(!handler || initial(handler.log))
		log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(GLOB)
		if(GLOB.total_runtimes != 0)
			fail_reasons = list("Total runtimes: [GLOB.total_runtimes]")
#ifdef UNIT_TESTS
		if(GLOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
		if(!GLOB.log_directory)
			LAZYADD(fail_reasons, "Missing GLOB.log_directory!")
	else
		fail_reasons = list("Missing GLOB!")
	if(!fail_reasons)
		text2file("Success!", "[GLOB.log_directory]/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src) //shut it down

/world/Reboot(reason = 0, fast_track = FALSE)
	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr && Master && GLOB) // why && Master / GLOB? if OOM, MC gets erased :D
			message_admins("Blocked reboot request from [key_name_admin(usr)]. Please use the Reboot World verb.")
			return // no thank you
			// log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			// message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, SPAN_BOLDANNOUNCE("Rebooting World immediately due to host request."))
	else
		to_chat(world, SPAN_BOLDANNOUNCE("Rebooting world..."))
		if(blackbox)
			blackbox.save_all_data_to_sql()
		Master.Shutdown() //run SS shutdowns

	#ifdef UNIT_TESTS
	FinishTestRun()
	return
	#endif

	if(TgsAvailable())
		var/do_hard_reboot
		// check the hard reboot counter
		var/ruhr = CONFIG_GET(number/rounds_until_hard_restart)
		switch(ruhr)
			if(-1)
				do_hard_reboot = FALSE
			if(0)
				do_hard_reboot = TRUE
			else
				if(GLOB.restart_counter >= ruhr)
					do_hard_reboot = TRUE
				else
					text2file("[++GLOB.restart_counter]", RESTART_COUNTER_PATH)
					do_hard_reboot = FALSE

		if(do_hard_reboot)
			log_world("World hard rebooted at [time_stamp()]")
			shutdown_logging() // See comment below.
			TgsEndProcess()

	log_world("World rebooted at [time_stamp()]")

	TgsReboot()
	shutdown_logging() // Past this point, no logging procs can be used, at risk of data loss.

	//! Shutdown Auxtools
	// AUXTOOLS_SHUTDOWN(AUXTOOLS_YAML)

	//! Finale
	// hmmm let's sleep for one (1) second incase rust_g threads are running for whatever reason
	sleep(1 SECONDS)
	..()

/world/Del()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_shutdown")()
	. = ..()

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	if(!fexists("data/mode.txt"))
		return


	var/list/Lines = world.file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return 1

/world/proc/load_mods()
	if(config_legacy.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			log_world("Failed to load config/moderators.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(GLOB.directory[ckey])

/world/proc/load_mentors()
	if(config_legacy.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			log_world("Failed to load config/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(GLOB.directory[ckey])

/world/proc/update_status()
	. = ""
	if(!config)
		status = "<b>SERVER LOADING OR BROKEN.</b> (18+)"
		return

	// ---Hub title---
	var/servername = config_legacy?.server_name
	var/stationname = station_name()
	var/defaultstation = LEGACY_MAP_DATUM ? LEGACY_MAP_DATUM.station_name : stationname
	if(servername || stationname != defaultstation)
		. += (servername ? "<b>[servername]" : "<b>")
		. += (stationname != defaultstation ? "[servername ? " - " : ""][stationname]</b>\] " : "</b>\] ")

	var/communityname = CONFIG_GET(string/community_shortname)
	var/communitylink = CONFIG_GET(string/community_link)
	if(communityname)
		. += (communitylink ? "(<a href=\"[communitylink]\">[communityname]</a>) " : "([communityname]) ")

	. += "(18+)<br>" //This is obligatory for obvious reasons.

	// ---Hub body---
	var/tagline = (CONFIG_GET(flag/usetaglinestrings) ? pick(GLOB.server_taglines) : CONFIG_GET(string/tagline))
	if(tagline)
		. += "[tagline]<br>"

	// ---Hub footer---
	. += "\["
	if(LEGACY_MAP_DATUM)
		. += "[LEGACY_MAP_DATUM.station_short], "

	. += "[get_security_level()] alert, "

	. += "[GLOB.clients.len] players"

	status = .

/world/proc/update_hub_visibility(new_value)					//CITADEL PROC: TG's method of changing visibility
	if(new_value)				//I'm lazy so this is how I wrap it to a bool number
		new_value = TRUE
	else
		new_value = FALSE
	if(new_value == visibility)
		return

	visibility = new_value
	if(visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"

// Things to do when a new z-level was just made.
/world/proc/max_z_changed(old_z_count, new_z_count)
	assert_players_by_zlevel_list()
	assert_gps_level_list()
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.on_max_z_changed(old_z_count, new_z_count)

/proc/assert_players_by_zlevel_list()
	if(!islist(GLOB.players_by_zlevel))
		GLOB.players_by_zlevel = list()
	while(GLOB.players_by_zlevel.len < world.maxz)
		GLOB.players_by_zlevel[++GLOB.players_by_zlevel.len] = list()

// Call this to make a new blank z-level, don't modify maxz directly.
/world/proc/increment_max_z()
	. = ++maxz
	max_z_changed(. - 1, .)

//! LOG SHUNTER STUFF, LEAVE THIS ALONE
/**
 * so it turns out that if GLOB init or something before world.log redirect runtimes we have no way of catching it in CI
 * which is really bad?? because we kind of need it??
 * therefore
 */
/world/proc/ensure_logging_active()
// if we're unit testing do not ever redirect world.log or the test won't show output.
#ifndef UNIT_TESTS
	// we already know, we don't care
	if(global.world_log_redirected)
		return
	global.world_log_redirected = TRUE
	if(fexists("data/logs/world_init_temporary.log"))
		fdel("data/logs/world_init_temporary.log")
	world.log = file("data/logs/world_init_temporary.log")
	SEND_TEXT(world.log, "Shunting preinit logs as following...")
#endif

/**
 * world/New is running, shunt all of the output back.
 */
/world/proc/shunt_redirected_log()
// if we're unit testing do not ever redirect world.log or the test won't show output.
#ifndef UNIT_TESTS
	if(!(OVERRIDE_LOG_DIRECTORY_PARAMETER in params))
		world.log = file("[GLOB.log_directory]/dd.log")
	if(!world_log_redirected)
		log_world("World log shunt never happened. Something has gone wrong!")
		return
	else if(!fexists("data/logs/world_init_temporary.log"))
		log_world("No preinit logs detected, shunt skipped. Something has gone wrong!")
		return
	for(var/line in world.file2list("data/logs/world_init_temporary.log"))
		line = trim(line)
		if(!length(line))
			continue
		log_world(line)
	fdel("data/logs/world_init_temporary.log")
#endif
//! END


/world/proc/init_byond_tracy()
	var/library

	switch (system_type)
		if (MS_WINDOWS)
			library = "prof.dll"
		if (UNIX)
			library = "libprof.so"
		else
			CRASH("Unsupported platform: [system_type]")

	var/init_result = call(library, "init")()
	if (init_result != "0")
		CRASH("Error initializing byond-tracy: [init_result]")
