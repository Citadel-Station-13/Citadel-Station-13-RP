//Byond is a shit. That's why this is here.
/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameSSticker is created.

*/

GLOBAL_VAR_INIT(tgs_initialized, FALSE)

GLOBAL_VAR(topic_status_lastcache)
GLOBAL_LIST(topic_status_cache)

/world/New()
	var/extools = world.GetConfig("env", "EXTOOLS_DLL") || (world.system_type == MS_WINDOWS ? "./byond-extools.dll" : "./libbyond-extools.so")
	if (fexists(extools))
		call(extools, "maptick_initialize")()
	enable_debugger()

	make_datum_reference_lists()

	log_world("World loaded at [TIME_STAMP("hh:mm:ss", FALSE)]!")

	SetupExternalRsc()

	var/tempfile = "data/logs/config_error.[GUID()].log"	//temporary file used to record errors with loading config, moved to log directory once logging is set
	GLOB.config_error_log = GLOB.world_href_log = GLOB.world_runtime_log = GLOB.world_map_error_log = GLOB.world_attack_log = GLOB.world_game_log = tempfile

	GLOB.revdata = new

	InitTgs()

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	SetupLogs()

#ifndef USE_CUSTOM_ERROR_HANDLER
	world.log = file("[GLOB.log_directory]/dd.log")
#else
	if (TgsAvailable())
		world.log = file("[GLOB.log_directory]/dd.log") //not all runtimes trigger world/Error, so this is the only way to ensure we can see all of them.
#endif

	config_legacy.post_load()

	if(config && config_legacy.server_name != null && config_legacy.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config_legacy.server_name += " #[(world.port % 1000) / 100]"

	// TODO - Figure out what this is. Can you assign to world.log?
	// if(config && config_legacy.log_runtime)
	// 	log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	callHook("startup")
	init_vchat()
	//Emergency Fix
	load_mods()
	//end-emergency fix

	src.update_status()

	. = ..()

#if UNIT_TEST
	log_unit_test("Unit Tests Enabled.  This will destroy the world when testing is complete.")
	log_unit_test("If you did not intend to enable this please check code/__defines/unit_testing.dm")
#endif

	// Set up roundstart seed list.
	plant_controller = new()

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	// Loads all the pre-made submap templates.
	load_map_templates()

	if(config_legacy.generate_map)
		if(GLOB.using_map.perform_map_generation())
			GLOB.using_map.refresh_mining_turfs()

	// Create frame types.
	populate_frame_types()

	// Create floor types.
	populate_flooring_types()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	//Must be done now, otherwise ZAS zones and lighting overlays need to be recreated.
	createRandomZlevel()

	Master.Initialize(10, FALSE)

#if UNIT_TEST
	spawn(1)
		initialize_unit_tests()
#endif

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config_legacy.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

/world/proc/InitTgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()
	GLOB.tgs_initialized = TRUE

/world/proc/SetupExternalRsc()
#if (PRELOAD_RSC == 0)
	GLOB.external_rsc_urls = world.file2list("[global.config_legacy.directory]/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=GLOB.external_rsc_urls.len)
		if(GLOB.external_rsc_urls[i])
			i++
		else
			GLOB.external_rsc_urls.Cut(i,i+1)
#endif

/world/proc/SetupLogs()
	var/override_dir = params[OVERRIDE_LOG_DIRECTORY_PARAMETER]
	if(!override_dir)
		var/realtime = world.realtime
		var/texttime = time2text(realtime, "YYYY/MM/DD")
		GLOB.log_directory = "data/logs/[texttime]/round-"
		GLOB.picture_logging_prefix = "L_[time2text(realtime, "YYYYMMDD")]_"
		GLOB.picture_log_directory = "data/picture_logs/[texttime]/round-"
		if(GLOB.round_id)
			GLOB.log_directory += "[GLOB.round_id]"
			GLOB.picture_logging_prefix += "R_[GLOB.round_id]_"
			GLOB.picture_log_directory += "[GLOB.round_id]"
		else
			var/timestamp = replacetext(TIME_STAMP("hh:mm:ss", FALSE), ":", ".")
			GLOB.log_directory += "[timestamp]"
			GLOB.picture_log_directory += "[timestamp]"
			GLOB.picture_logging_prefix += "T_[timestamp]_"
	else
		GLOB.log_directory = "data/logs/[override_dir]"
		GLOB.picture_logging_prefix = "O_[override_dir]_"
		GLOB.picture_log_directory = "data/picture_logs/[override_dir]"

	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.world_qdel_log = "[GLOB.log_directory]/qdel.log"
	GLOB.world_map_error_log = "[GLOB.log_directory]/map_errors.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.subsystem_log = "[GLOB.log_directory]/subsystem.log"

	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.world_qdel_log)
	start_log(GLOB.world_map_error_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.subsystem_log)

	GLOB.changelog_hash = md5('html/changelog.html') //for telling if the changelog has changed recently
	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	// This was printed early in startup to the world log and config_error.log,
	// but those are both private, so let's put the commit info in the runtime
	// log which is ultimately public.
	log_runtime(GLOB.revdata.get_log_message())

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
		log_topic("\"[T]\", from:[addr], aster:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)

/world/Reboot(reason = 0, fast_track = FALSE)
	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, "<span class='boldannounce'>Rebooting World immediately due to host request</span>")
	else
		to_chat(world, "<span class='boldannounce'>Rebooting world...</span>")
		//POLARIS START
		if(blackbox)
			blackbox.save_all_data_to_sql()
		//END
		Master.Shutdown()	//run SS shutdowns

	TgsReboot()

/*
	if(TEST_RUN_PARAMETER in params)
		FinishTestRun()
		return
*/

/*
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
*/

	log_world("World rebooted at [time_stamp()]")
	shutdown_logging() // Past this point, no logging procs can be used, at risk of data loss.
	..()

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	if(!fexists("data/mode.txt"))
		return


	var/list/Lines = file2list("data/mode.txt")
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
			log_world("Failed to load config/mods.txt")
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
	var/s = ""

	if (config_legacy?.server_name)
		s += "<b>[config_legacy.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Citadel"  //Replace this with something else. Or ever better, delete it and uncomment the game version.	CITADEL CHANGE - modifies hub entry to match main
	s += "</a>"
	s += ")\]" //CITADEL CHANGE - encloses the server title in brackets to make the hub entry fancier
	s += "<br><small><a href='https://discord.gg/citadelstation'>Roleplay focused 18+ server with extensive species choices.</a></small></br>" //CITADEL CHANGE - adds an educational fact to the hub entry!

	s += ")"

	var/list/features = list()

	if(SSticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	/*if (!config_legacy.enter_allowed)	CITADEL CHANGE - removes useless info from hub entry
		features += "closed"

	features += config_legacy.abandon_allowed ? "respawn" : "no respawn"

	if (config && config_legacy.allow_vote_mode)
		features += "vote"

	if (config && config_legacy.allow_ai)
		features += "AI allowed"*/

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"


	if (config && config_legacy.hostedby)
		features += "hosted by <b>[config_legacy.hostedby]</b>"

	if (features)
		s += "\[[jointext(features, ", ")]"	//CITADEL CHANGE - replaces colon with left bracket to make the hub entry a little fancier

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!config_legacy.sql_enabled)
		log_world("SQL connection disabled in config_legacy.")
	else if(!setup_database_connection())
		log_world("Your server failed to establish a connection with the feedback database.")
	else
		log_world("Feedback database connection established.")
	return 1

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1


/hook/startup/proc/connectOldDB()
	if(!config_legacy.sql_enabled)
		log_world("SQL connection disabled in config_legacy.")
	else if(!setup_old_database_connection())
		log_world("Your server failed to establish a connection with the SQL database.")
	else
		log_world("SQL database connection established.")
	return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
proc/setup_old_database_connection()

	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon_old)
		dbcon_old = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon_old.IsConnected()
	if ( . )
		failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_old_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_old_db_connection()
	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon_old || !dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF

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
/world/proc/max_z_changed()
	if(!istype(GLOB.players_by_zlevel, /list))
		GLOB.players_by_zlevel = new /list(world.maxz, 0)
	while(GLOB.players_by_zlevel.len < world.maxz)
		GLOB.players_by_zlevel.len++
		GLOB.players_by_zlevel[GLOB.players_by_zlevel.len] = list()

// Call this to make a new blank z-level, don't modify maxz directly.
/world/proc/increment_max_z()
	maxz++
	max_z_changed()
