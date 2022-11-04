/proc/load_configuration()
	config_legacy = new /datum/configuration_legacy()
	config_legacy.load("config/legacy/config.txt")
	config_legacy.load("config/legacy/game_options.txt","game_options")

/datum/configuration_legacy
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/nudge_script_path = "nudge.py"  // where the nudge.py script is located

	var/hub_visibility = FALSE				//CITADEL CHANGE - HUB CONFIG

	var/log_ooc = 0						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 0						// log client say
	var/log_admin = 0					// log admin actions
	var/log_debug = 1					// log debug output
	var/log_game = 0					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 0					// log client whisper
	var/log_emote = 0					// log emotes
	var/log_attack = 0					// log attack messages
	var/log_adminchat = 0				// log admin chat messages
	var/log_adminwarn = 0				// log warnings admins get about bomb construction and such
	var/log_pda = 0						// log pda messages
	var/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/log_runtime = 0					// logs world.log to a file
	var/log_world_output = 0			// log world.log << messages
	var/log_topic = TRUE
	var/allow_vote_restart = 0 			// allow votes to restart
	var/ert_admin_call_only = 0
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/allow_admin_rev = 1				// allows admin revives
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autotransfer_initial = 108000 // Length of time before the first autotransfer vote is called
	var/vote_autotransfer_interval = 36000 // length of time before next sequential autotransfer vote
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
//	var/enable_authentication = 0		// goon authentication
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/allow_Metadata = 0				// Metadata is supported.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/fps = 20
	var/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT	//SSinitialization throttling
	var/Tickcomp = 0
	var/socket_talk	= 0					// use socket_talk to communicate with other processes
	var/list/resource_urls = null
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/list/player_requirements = list() // Overrides for how many players readied up a gamemode needs to start.
	var/list/player_requirements_secret = list() // Same as above, but for the secret gamemode.
	var/humans_need_surnames = 0
	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/enable_game_master = 0			// enables the 'smart' event system.
	var/allow_ai = 1					// allow ai job
	var/allow_ai_shells = FALSE			// allow AIs to enter and leave special borg shells at will, and for those shells to be buildable.
	var/give_free_ai_shell = FALSE		// allows a specific spawner object to instantiate a premade AI Shell
	var/hostedby = null

	var/respawn = 1
	var/static/respawn_time = 3000		// time before a dead player is allowed to respawn (in ds, though the config file asks for minutes, and it's converted below)
	var/static/respawn_message = "<span class='notice'><B>Make sure to play a different character, and please roleplay correctly!</B></span>"

	var/guest_jobban = 1
	var/usewhitelist = 0
	var/kick_inactive = 0				//force disconnect for inactive players after this many minutes, if non-0
	var/show_mods = 0
	var/show_devs = 0
	var/show_event_managers = 0
	var/mods_can_tempban = 0
	var/mods_can_job_tempban = 0
	var/mod_tempban_max = 1440
	var/mod_job_tempban_max = 1440
	var/load_jobs_from_txt = 0
	var/ToRban = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.

	var/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/character_slots = 10				// The number of available character slots
	var/loadout_slots = 3					// The number of loadout slots per character

	var/max_maint_drones = 5				//This many drones can spawn,
	var/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/disable_player_mice = 0
	var/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/usealienwhitelist = 0
	var/limitalienplayers = 0
	var/alien_to_human_ratio = 0.5
	var/allow_extra_antags = 0
	var/guests_allowed = 1
	var/debugparanoid = 0
	var/panic_bunker = 0
	var/panic_bunker_message = "Sorry, this server is not accepting connections from never seen before players."
	var/paranoia_logging = 0

	var/ip_reputation = FALSE		//Should we query IPs to get scores? Generates HTTP traffic to an API service.
	var/ipr_email					//Left null because you MUST specify one otherwise you're making the internet worse.
	var/ipr_block_bad_ips = FALSE	//Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).
	var/ipr_bad_score = 1			//The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
	var/ipr_allow_existing = FALSE 	//Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.
	var/ipr_minimum_age = 5
	var/ipqualityscore_apikey //API key for ipqualityscore.com

	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/wikisearchurl
	var/forumurl
	var/rulesurl
	var/mapurl

	var/forbid_singulo_possession = 0

	//game_options.txt configs

	var/health_threshold_softcrit = 0
	var/health_threshold_crit = 0
	var/health_threshold_dead = -100

	var/organ_health_multiplier = 1
	var/organ_regeneration_multiplier = 1
	var/default_brain_health = 400
	var/allow_headgibs = FALSE

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = 0
	var/limbs_can_break = 0

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/use_loyalty_implants = 0

	var/welder_vision = 1
	var/generate_map = 1
	var/no_click_cooldown = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_speed = 0
	var/walk_speed = 0

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0

	var/footstep_volume = 0

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config_legacy.txt
	var/use_age_restriction_for_jobs = 0 //Do jobs use account age restrictions? --requires database
	var/use_age_restriction_for_antags = 0 //Do antags use account age restrictions? --requires database

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.
	var/multi_z_explosion_scalar = 0.5 //Multiplier for how much weaker explosions are on neighboring z levels.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/enter_allowed = 1

	var/use_irc_bot = 0
	var/use_node_bot = 0
	var/irc_bot_port = 0
	var/irc_bot_host = ""
	var/irc_bot_export = 0 // whether the IRC bot in use is a Bot32 (or similar) instance; Bot32 uses world.Export() instead of nudge.py/libnudge
	var/main_irc = ""
	var/admin_irc = ""
	var/python_path = "" //Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/use_lib_nudge = 0 //Use the C library nudge instead of the python nudge.
	var/use_overmap = 0

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/aliens_allowed = 0
	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1

	var/static/starlight = 0	// Whether space turfs have ambient light or not

	var/list/ert_species = list(SPECIES_HUMAN)

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	var/list/language_prefixes = list(",","#")//Default language prefixes

	var/show_human_death_message = 1

	var/radiation_decay_rate = 1 //How much radiation is reduced by each tick
	var/radiation_resistance_multiplier = 8.5
	var/radiation_lower_limit = 0.35 //If the radiation level for a turf would be below this, ignore it.

	var/comms_key = "default_password"

	var/minute_click_limit = 500		//default: 7+ clicks per second
	var/second_click_limit = 15
	var/minute_topic_limit = 500
	var/second_topic_limit = 10
	var/random_submap_orientation = FALSE // If true, submaps loaded automatically can be rotated.
	var/autostart_solars = FALSE // If true, specifically mapped in solar control computers will set themselves up when the round starts.

	var/list/gamemode_cache = list()

	var/lock_client_view_x
	var/lock_client_view_y
	var/max_client_view_x
	var/max_client_view_y


/datum/configuration_legacy/New()
	var/list/L = subtypesof(/datum/game_mode)
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				player_requirements[M.config_tag] = M.required_players
				player_requirements_secret[M.config_tag] = M.required_players_secret
				if (M.votable)
					src.votable_modes += M.config_tag
	src.votable_modes += "secret"

/datum/configuration_legacy/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = world.file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("resource_urls")
					config_legacy.resource_urls = splittext(value, " ")

				if ("admin_legacy_system")
					config_legacy.admin_legacy_system = 1

				if ("ban_legacy_system")
					config_legacy.ban_legacy_system = 1

				if ("hub_visibility")					//CITADEL CHANGE - ADDS HUB CONFIG
					config_legacy.hub_visibility = 1

				if ("use_age_restriction_for_jobs")
					config_legacy.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					config_legacy.use_age_restriction_for_antags = 1

				if ("jobs_have_minimal_access")
					config_legacy.jobs_have_minimal_access = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("multi_z_explosion_scalar")
					multi_z_explosion_scalar = text2num(value)

				if ("log_ooc")
					config_legacy.log_ooc = 1

				if ("log_access")
					config_legacy.log_access = 1

				if ("log_say")
					config_legacy.log_say = 1

				if ("debug_paranoid")
					config_legacy.debugparanoid = 1

				if ("log_admin")
					config_legacy.log_admin = 1

				if ("log_debug")
					config_legacy.log_debug = text2num(value)

				if ("log_game")
					config_legacy.log_game = 1

				if ("log_vote")
					config_legacy.log_vote = 1

				if ("log_whisper")
					config_legacy.log_whisper = 1

				if ("log_attack")
					config_legacy.log_attack = 1

				if ("log_emote")
					config_legacy.log_emote = 1

				if ("log_adminchat")
					config_legacy.log_adminchat = 1

				if ("log_adminwarn")
					config_legacy.log_adminwarn = 1

				if ("log_pda")
					config_legacy.log_pda = 1

				if ("log_world_output")
					config_legacy.log_world_output = 1

				if ("log_hrefs")
					config_legacy.log_hrefs = 1

				if ("log_runtime")
					config_legacy.log_runtime = 1

				if ("log_topic")
					config_legacy.log_topic = text2num(value)

				if ("generate_map")
					config_legacy.generate_map = 1

				if ("no_click_cooldown")
					config_legacy.no_click_cooldown = 1

				if ("allow_vote_restart")
					config_legacy.allow_vote_restart = 1

				if ("allow_vote_mode")
					config_legacy.allow_vote_mode = 1

				if ("allow_admin_jump")
					config_legacy.allow_admin_jump = 1

				if("allow_admin_rev")
					config_legacy.allow_admin_rev = 1

				if ("allow_admin_spawning")
					config_legacy.allow_admin_spawning = 1

				if ("no_dead_vote")
					config_legacy.vote_no_dead = 1

				if ("default_no_vote")
					config_legacy.vote_no_default = 1

				if ("vote_delay")
					config_legacy.vote_delay = text2num(value)

				if("comms_key")
					config_legacy.comms_key = value

				if ("vote_period")
					config_legacy.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					config_legacy.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					config_legacy.vote_autotransfer_interval = text2num(value)

				if ("vote_autogamemode_timeleft")
					config_legacy.vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					config_legacy.ert_admin_call_only = 1

				if ("allow_ai")
					config_legacy.allow_ai = 1

				if ("allow_ai_shells")
					config_legacy.allow_ai_shells = TRUE

				if("give_free_ai_shell")
					config_legacy.give_free_ai_shell = TRUE

//				if ("authentication")
//					config_legacy.enable_authentication = 1

				if ("norespawn")
					config_legacy.respawn = 0

				if ("respawn_time")
					var/raw_minutes = text2num(value)
					config_legacy.respawn_time = raw_minutes MINUTES

				if ("respawn_message")
					config_legacy.respawn_message = value

				if ("servername")
					config_legacy.server_name = value

				if ("serversuffix")
					config_legacy.server_suffix = 1

				if ("nudge_script_path")
					config_legacy.nudge_script_path = value

				if ("hostedby")
					config_legacy.hostedby = value

				if ("serverurl")
					config_legacy.serverurl = value

				if ("server")
					config_legacy.server = value

				if ("banappeals")
					config_legacy.banappeals = value

				if ("wikiurl")
					config_legacy.wikiurl = value

				if ("wikisearchurl")
					config_legacy.wikisearchurl = value

				if ("forumurl")
					config_legacy.forumurl = value

				if ("rulesurl")
					config_legacy.rulesurl = value

				if ("mapurl")
					config_legacy.mapurl = value

				if ("guest_jobban")
					config_legacy.guest_jobban = 1

				if ("guest_ban")
					config_legacy.guests_allowed = 0

				if ("disable_ooc")
					config_legacy.ooc_allowed = 0
					config_legacy.looc_allowed = 0

				if ("disable_entry")
					config_legacy.enter_allowed = 0

				if ("disable_dead_ooc")
					config_legacy.dooc_allowed = 0

				if ("disable_dsay")
					config_legacy.dsay_allowed = 0

				if ("disable_respawn")
					config_legacy.abandon_allowed = 0

				if ("usewhitelist")
					config_legacy.usewhitelist = 1

				if ("feature_object_spell_system")
					config_legacy.feature_object_spell_system = 1

				if ("allow_metadata")
					config_legacy.allow_Metadata = 1

				if ("traitor_scaling")
					config_legacy.traitor_scaling = 1

				if ("aliens_allowed")
					config_legacy.aliens_allowed = 1

				if ("ninjas_allowed")
					config_legacy.ninjas_allowed = 1

				if ("objectives_disabled")
					config_legacy.objectives_disabled = 1

				if("protect_roles_from_antagonist")
					config_legacy.protect_roles_from_antagonist = 1

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config_legacy.modes)
							config_legacy.probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if ("required_players", "required_players_secret")
					var/req_pos = findtext(value, " ")
					var/req_name = null
					var/req_value = null
					var/is_secret_override = findtext(name, "required_players_secret") // Being extra sure we're not picking up an override for Secret by accident.

					if(req_pos)
						req_name = lowertext(copytext(value, 1, req_pos))
						req_value = copytext(value, req_pos + 1)
						if(req_name in config_legacy.modes)
							if(is_secret_override)
								config_legacy.player_requirements_secret[req_name] = text2num(req_value)
							else
								config_legacy.player_requirements[req_name] = text2num(req_value)
						else
							log_misc("Unknown game mode player requirement configuration definition: [req_name].")
					else
						log_misc("Incorrect player requirement configuration definition: [req_name]  [req_value].")

				if("allow_random_events")
					config_legacy.allow_random_events = 1

				if("enable_game_master")
					config_legacy.enable_game_master = 1

				if("kick_inactive")
					config_legacy.kick_inactive = text2num(value)

				if("show_mods")
					config_legacy.show_mods = 1

				if("show_devs")
					config_legacy.show_devs = 1

				if("show_event_managers")
					config_legacy.show_event_managers = 1

				if("mods_can_tempban")
					config_legacy.mods_can_tempban = 1

				if("mods_can_job_tempban")
					config_legacy.mods_can_job_tempban = 1

				if("mod_tempban_max")
					config_legacy.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config_legacy.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config_legacy.popup_admin_pm = 1

				if("allow_holidays")
					Holiday = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("use_node_bot")
					use_node_bot = 1

				if("irc_bot_port")
					config_legacy.irc_bot_port = value

				if("irc_bot_export")
					irc_bot_export = 1

				if("ticklag")
					var/ticklag = text2num(value)
					if(ticklag > 0)
						fps = 10 / ticklag

				if("tick_limit_mc_init")
					tick_limit_mc_init = text2num(value)

				if("allow_antag_hud")
					config_legacy.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config_legacy.antag_hud_restricted = 1

				if("socket_talk")
					socket_talk = text2num(value)

				if("tickcomp")
					Tickcomp = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("usealienwhitelist")
					usealienwhitelist = 1

				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					config_legacy.assistant_maint = 1

				if("gateway_delay")
					config_legacy.gateway_delay = text2num(value)

				if("continuous_rounds")
					config_legacy.continous_rounds = 1

				if("ghost_interaction")
					config_legacy.ghost_interaction = 1

				if("disable_player_mice")
					config_legacy.disable_player_mice = 1

				if("uneducated_mice")
					config_legacy.uneducated_mice = 1

				if("irc_bot_host")
					config_legacy.irc_bot_host = value

				if("main_irc")
					config_legacy.main_irc = value

				if("admin_irc")
					config_legacy.admin_irc = value

				if("python_path")
					if(value)
						config_legacy.python_path = value

				if("use_lib_nudge")
					config_legacy.use_lib_nudge = 1

				if("allow_cult_ghostwriter")
					config_legacy.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config_legacy.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					config_legacy.character_slots = text2num(value)

				if("loadout_slots")
					config_legacy.loadout_slots = text2num(value)

				if("allow_drone_spawn")
					config_legacy.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config_legacy.drone_build_time = text2num(value)

				if("max_maint_drones")
					config_legacy.max_maint_drones = text2num(value)

				if("use_overmap")
					config_legacy.use_overmap = 1
/*
				if("station_levels")
					GLOB.using_map.station_levels = text2numlist(value, ";")

				if("admin_levels")
					GLOB.using_map.admin_levels = text2numlist(value, ";")

				if("contact_levels")
					GLOB.using_map.contact_levels = text2numlist(value, ";")

				if("player_levels")
					GLOB.using_map.player_levels = text2numlist(value, ";")
*/
				if("expected_round_length")
					config_legacy.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config_legacy.welder_vision = 0

				if("allow_extra_antags")
					config_legacy.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config_legacy.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config_legacy.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config_legacy.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config_legacy.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config_legacy.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config_legacy.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("ert_species")
					config_legacy.ert_species = splittext(value, ";")
					if(!config_legacy.ert_species.len)
						config_legacy.ert_species += SPECIES_HUMAN

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config_legacy.aggressive_changelog = 1

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("radiation_lower_limit")
					radiation_lower_limit = text2num(value)

				if ("panic_bunker")
					config_legacy.panic_bunker = 1

				if ("panic_bunker_message")
					config_legacy.panic_bunker_message = value

				if ("paranoia_logging")
					config_legacy.paranoia_logging = 1

				if("ip_reputation")
					config_legacy.ip_reputation = 1

				if("ipr_email")
					config_legacy.ipr_email = value

				if("ipr_block_bad_ips")
					config_legacy.ipr_block_bad_ips = 1

				if("ipr_bad_score")
					config_legacy.ipr_bad_score = text2num(value)

				if("ipr_allow_existing")
					config_legacy.ipr_allow_existing = 1

				if("ipr_minimum_age")
					config_legacy.ipr_minimum_age = text2num(value)

				if("minute_click_limit")
					config_legacy.minute_click_limit = text2num(value)

				if("second_click_limit")
					config_legacy.second_click_limit = text2num(value)

				if("minute_topic_limit")
					config_legacy.minute_topic_limit = text2num(value)
				if("random_submap_orientation")
					config_legacy.random_submap_orientation = 1

				if("second_topic_limit")
					config_legacy.second_topic_limit = text2num(value)
				if("autostart_solars")
					config_legacy.autostart_solars = TRUE

				if("second_topic_limit")
					config_legacy.second_topic_limit = text2num(value)

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					config_legacy.health_threshold_crit = value
				if("health_threshold_softcrit")
					config_legacy.health_threshold_softcrit = value
				if("health_threshold_dead")
					config_legacy.health_threshold_dead = value
				if("show_human_death_message")
					config_legacy.show_human_death_message = 1
				if("revival_pod_plants")
					config_legacy.revival_pod_plants = value
				if("revival_cloning")
					config_legacy.revival_cloning = value
				if("revival_brain_life")
					config_legacy.revival_brain_life = value
				if("organ_health_multiplier")
					config_legacy.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config_legacy.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config_legacy.organ_damage_spillover_multiplier = value / 100
				if("default_brain_health")
					config_legacy.default_brain_health = text2num(value)
					if(!config_legacy.default_brain_health || config_legacy.default_brain_health < 1)
						config_legacy.default_brain_health = initial(config_legacy.default_brain_health)
				if("bones_can_break")
					config_legacy.bones_can_break = value
				if("limbs_can_break")
					config_legacy.limbs_can_break = value
				if("allow_headgibs")
					config_legacy.allow_headgibs = TRUE

				if("run_speed")
					config_legacy.run_speed = value
				if("walk_speed")
					config_legacy.walk_speed = value

				if("human_delay")
					config_legacy.human_delay = value
				if("robot_delay")
					config_legacy.robot_delay = value
				if("monkey_delay")
					config_legacy.monkey_delay = value
				if("alien_delay")
					config_legacy.alien_delay = value
				if("slime_delay")
					config_legacy.slime_delay = value
				if("animal_delay")
					config_legacy.animal_delay = value

				if("footstep_volume")
					config_legacy.footstep_volume = text2num(value)

				if("use_loyalty_implants")
					config_legacy.use_loyalty_implants = 1

				else
					log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration_legacy/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return gamemode_cache["extended"]

/datum/configuration_legacy/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(M && M.can_start() && !isnull(config_legacy.probabilities[M.config_tag]) && config_legacy.probabilities[M.config_tag] > 0)
			runnable_modes |= M
	return runnable_modes

/datum/configuration_legacy/proc/post_load()
	//apply a default value to config_legacy.python_path, if needed
	if (!config_legacy.python_path)
		if(world.system_type == UNIX)
			config_legacy.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config_legacy.python_path = "python"
	world.update_hub_visibility(hub_visibility)			//CITADEL CHANGE - HUB CONFIG
