//Byond is a shit. That's why this is here.
/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameticker is created.

*/


#define RECOMMENDED_VERSION 501
#define TOPIC_LENGTH_LIMIT 1024 //The reason why this is so large is to allow TGS topic calls to function without issue.
#define TOPIC_COOLDOWN 1 //90% sure there isnt anything that does multiple topic calls in a single decisecond.

/world/New()
	world.log << "Map Loading Complete"
	//logs
	log_path += time2text(world.realtime, "YYYY/MM-Month/DD-Day/round-hh-mm-ss")
	diary = start_log("[log_path].log")
	href_logfile = start_log("[log_path]-hrefs.htm")
	error_log = start_log("[log_path]-error.log")
	debug_log = start_log("[log_path]-debug.log")

	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	TgsNew(minimum_required_security_level = TGS_SECURITY_TRUSTED)

	config_legacy.post_load()

	if(config && config_legacy.server_name != null && config_legacy.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config_legacy.server_name += " #[(world.port % 1000) / 100]"

	// TODO - Figure out what this is. Can you assign to world.log?
	// if(config && config_legacy.log_runtime)
	// 	log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	callHook("startup")
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
		if(using_map.perform_map_generation())
			using_map.refresh_mining_turfs()

	// Create frame types.
	populate_frame_types()

	// Create floor types.
	populate_flooring_types()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	//Must be done now, otherwise ZAS zones and lighting overlays need to be recreated.
	createRandomZlevel()

	processScheduler = new
	master_controller = new /datum/controller/game_controller()

	processScheduler.deferSetupFor(/datum/controller/process/ticker)
	processScheduler.setup()
	Master.Initialize(10, FALSE)

	spawn(1)
		master_controller.setup()
#if UNIT_TEST
		initialize_unit_tests()
#endif

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config_legacy.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	var/static/list/bannedsourceaddrs = list()
	var/static/list/lasttimeaddr = list()

	if(addr in bannedsourceaddrs)
		return

	if(length(T) >= TOPIC_LENGTH_LIMIT)
		log_topic("Oversized topic, banning address. from:[addr]")
		bannedsourceaddrs |= addr
		return

	if(addr in lasttimeaddr && world.time < (lasttimeaddr["[addr]"] + TOPIC_COOLDOWN))
		log_topic("Too many topic calls from address in [TOPIC_COOLDOWN] ds, banning address. from:[addr]")
		bannedsourceaddrs |= addr
		return

	lasttimeaddr["[addr]"] = world.time

	TGS_TOPIC

	log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

/*		for when we have handlers replacing all of our stuff.
	var/static/list/topic_handlers = TopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if((!handler || initial(handler.log)) && config && CONFIG_GET(flag/log_world_topic))
		log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)
*/

//temporary compatibility patch start
	var/static/list/topic_handlers = TopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if(handler)
		handler = new handler
		. = handler.TryRun(input)

//END

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

/*

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (copytext(T,1,7) == "status")
		var/input[] = params2list(T)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config_legacy.abandon_allowed
		s["enter"] = config_legacy.enter_allowed
		s["vote"] = config_legacy.allow_vote_mode
		s["ai"] = config_legacy.allow_ai
		s["host"] = host ? host : null

		// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
		s["players"] = 0
		s["stationtime"] = stationtime2text()
		s["roundduration"] = roundduration2text()

		if(input["status"] == "2")
			var/list/players = list()
			var/list/admins = list()

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue
					admins[C.key] = C.holder.rank
				players += C.key

			s["players"] = players.len
			s["playerlist"] = list2params(players)
			var/list/adm = get_admin_counts()
			var/list/presentmins = adm["present"]
			var/list/afkmins = adm["afk"]
			s["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
			s["adminlist"] = list2params(admins)
		else
			var/n = 0
			var/admins = 0

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue	//so stealthmins aren't revealed by the hub
					admins++
				s["player[n]"] = C.key
				n++

			s["players"] = n
			s["admins"] = admins

		return list2params(s)

	else if(T == "manifest")
		var/list/positions = list()
		var/list/set_names = list(
				"heads" = command_positions,
				"sec" = security_positions,
				"eng" = engineering_positions,
				"med" = medical_positions,
				"sci" = science_positions,
				"car" = cargo_positions,
				"civ" = civilian_positions,
				"bot" = nonhuman_positions
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		// Synthetics don't have actual records, so we will pull them from here.
		for(var/mob/living/silicon/ai/ai in mob_list)
			if(!positions["bot"])
				positions["bot"] = list()
			positions["bot"][ai.name] = "Artificial Intelligence"
		for(var/mob/living/silicon/robot/robot in mob_list)
			// No combat/syndicate cyborgs, no drones.
			if(robot.module && robot.module.hide_on_manifest)
				continue
			if(!positions["bot"])
				positions["bot"] = list()
			positions["bot"][robot.name] = "[robot.modtype] [robot.braintype]"

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

		return list2params(positions)

	else if(T == "revision")
		if(revdata.revision)
			return list2params(list(branch = revdata.branch, date = revdata.date, revision = revdata.revision))
		else
			return "unknown"

	else if(copytext(T,1,5) == "info")
		var/input[] = params2list(T)
		if(input["key"] != config_legacy.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/list/search = params2list(input["info"])
		var/list/ckeysearch = list()
		for(var/text in search)
			ckeysearch += ckey(text)

		var/list/match = list()

		for(var/mob/M in mob_list)
			var/strings = list(M.name, M.ckey)
			if(M.mind)
				strings += M.mind.assigned_role
				strings += M.mind.special_role
			for(var/text in strings)
				if(ckey(text) in ckeysearch)
					match[M] += 10 // an exact match is far better than a partial one
				else
					for(var/searchstr in search)
						if(findtext(text, searchstr))
							match[M] += 1

		var/maxstrength = 0
		for(var/mob/M in match)
			maxstrength = max(match[M], maxstrength)
		for(var/mob/M in match)
			if(match[M] < maxstrength)
				match -= M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(isliving(M))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			var/list/ret = list()
			for(var/mob/M in match)
				ret[M.key] = M.name
			return list2params(ret)

	else if(copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		if(input["key"] != config_legacy.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/client/C
		var/req_ckey = ckey(input["adminmsg"])

		for(var/client/K in clients)
			if(K.ckey == req_ckey)
				C = K
				break
		if(!C)
			return "No client with that name on server"

		var/rank = input["rank"]
		if(!rank)
			rank = "Admin"

		var/message =	"<font color='red'>IRC-[rank] PM from <b><a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>IRC-[rank] PM from <a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_irc_pm = world.time
		C.irc_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		C << message


		for(var/client/A in admins)
			if(A != C)
				A << amessage

		return "Message Successful"

	else if(copytext(T,1,6) == "notes")
		/*
			We got a request for notes from the IRC Bot
			expected output:
				1. notes = ckey of person the notes lookup is for
				2. validationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
		*/
		var/input[] = params2list(T)
		if(input["key"] != config_legacy.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		return show_player_info_irc(ckey(input["notes"]))

	else if(copytext(T,1,4) == "age")
		var/input[] = params2list(T)
		if(input["key"] != config_legacy.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		var/age = get_player_age(input["age"])
		if(isnum(age))
			if(age >= 0)
				return "[age]"
			else
				return "Ckey not found"
		else
			return "Database connection failed or not set up"
*/

/world/Reboot(reason = 0, fast_track = FALSE)
	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, "<span class='boldannounce'>Rebooting World immediately due to host request</span>")
	else
		to_chat(world, "<span class='boldannounce'>Rebooting world...</span>")
		//POLARIS START
		processScheduler.stop()
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

GLOBAL_VAR_INIT(join_motd, "ERROR: MOTD MISSING")
/hook/startup/proc/loadMOTD()
	load_motd()
	return 1

/proc/load_motd()
	GLOB.join_motd = file2text("config/motd.txt")

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return 1

/world/proc/load_mods()
	if(config_legacy.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
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
				D.associate(directory[ckey])

/world/proc/load_mentors()
	if(config_legacy.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
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
				D.associate(directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && config_legacy.server_name)
		s += "<b>[config_legacy.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Citadel"  //Replace this with something else. Or ever better, delete it and uncomment the game version.	CITADEL CHANGE - modifies hub entry to match main
	s += "</a>"
	s += ")\]" //CITADEL CHANGE - encloses the server title in brackets to make the hub entry fancier
	s += "<br><small>Roleplay focused 18+ server featuring furries and more. Based on heavily modified VOREstation code.</small><br>" //CITADEL CHANGE - adds an educational fact to the hub entry!

	s += ")"

	var/list/features = list()

	if(ticker)
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
		world.log << "SQL connection disabled in config_legacy."
	else if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
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
		world.log << "SQL connection disabled in config_legacy."
	else if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the SQL database."
	else
		world.log << "SQL database connection established."
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
