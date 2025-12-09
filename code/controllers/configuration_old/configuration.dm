/proc/create_legacy_configuration()
	config_legacy = new /datum/configuration_legacy()

/proc/load_legacy_configuration()
	config_legacy.load("config/legacy/config.txt")
	config_legacy.load("config/legacy/game_options.txt","game_options")

/datum/configuration_legacy
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/allow_vote_restart = 0 			// allow votes to restart
	var/ert_admin_call_only = 0
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autotransfer_initial = 108000 // Length of time before the first autotransfer vote is called
	var/vote_autotransfer_interval = 36000 // length of time before next sequential autotransfer vote
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/fps = 20
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
	var/load_jobs_from_txt = 0
	var/ToRban = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.

	var/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/character_slots = 10				// The number of available character slots

	var/max_maint_drones = 5				//This many drones can spawn,
	var/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/disable_player_mice = 0
	var/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/usealienwhitelist = 0
	var/allow_extra_antags = 0
	var/guests_allowed = 1
	var/paranoia_logging = 0

	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/wikisearchurl
	var/forumurl
	var/rulesurl
	var/mapurl

	//game_options.txt configs

	var/health_threshold_softcrit = 0
	var/health_threshold_crit = 0
	var/health_threshold_dead = -100

	var/allow_headgibs = FALSE

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/welder_vision = 1

	var/footstep_volume = 0

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config_legacy.txt

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.
	var/multi_z_explosion_scalar = 0.5 //Multiplier for how much weaker explosions are on neighboring z levels.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/enter_allowed = 1

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(null, null, list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(6000, 18000, 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(9000, 27000, 42000)

	var/aliens_allowed = 0
	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/list/language_prefixes = list(",","#")//Default language prefixes

	var/comms_key = "default_password"

	var/minute_click_limit = 500		//default: 7+ clicks per second
	var/second_click_limit = 15
	var/minute_topic_limit = 500
	var/second_topic_limit = 10
	var/random_submap_orientation = FALSE // If true, submaps loaded automatically can be rotated.
	var/autostart_solars = FALSE // If true, specifically mapped in solar control computers will set themselves up when the round starts.

	var/list/gamemode_cache = list()

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
				if ("admin_legacy_system")
					config_legacy.admin_legacy_system = 1

				if ("ban_legacy_system")
					config_legacy.ban_legacy_system = 1

				if ("jobs_have_minimal_access")
					config_legacy.jobs_have_minimal_access = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("multi_z_explosion_scalar")
					multi_z_explosion_scalar = text2num(value)

				if ("allow_vote_restart")
					config_legacy.allow_vote_restart = 1

				if ("allow_vote_mode")
					config_legacy.allow_vote_mode = 1

				if ("allow_admin_jump")
					config_legacy.allow_admin_jump = 1

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

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("allow_holidays")
					Holiday = 1

				if("ticklag")
					var/ticklag = text2num(value)
					if(ticklag > 0)
						fps = 10 / ticklag

				if("allow_antag_hud")
					config_legacy.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config_legacy.antag_hud_restricted = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("usealienwhitelist")
					usealienwhitelist = 1

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

				if("allow_cult_ghostwriter")
					config_legacy.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config_legacy.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					config_legacy.character_slots = text2num(value)

				if("allow_drone_spawn")
					config_legacy.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config_legacy.drone_build_time = text2num(value)

				if("max_maint_drones")
					config_legacy.max_maint_drones = text2num(value)

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

				if("law_zero")
					law_zero = value

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("paranoia_logging")
					config_legacy.paranoia_logging = 1

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
				if("revival_pod_plants")
					config_legacy.revival_pod_plants = value
				if("revival_cloning")
					config_legacy.revival_cloning = value
				if("revival_brain_life")
					config_legacy.revival_brain_life = value
				if("allow_headgibs")
					config_legacy.allow_headgibs = TRUE

				if("footstep_volume")
					config_legacy.footstep_volume = text2num(value)

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
