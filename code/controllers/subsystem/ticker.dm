SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	wait = 20
	init_order = INIT_ORDER_TICKER
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	/// Current state of the game
	var/static/current_state = GAME_STATE_INIT

	/// Did we attempt an automatic gamemode vote?
	var/static/auto_gamemode_vote_attempted = FALSE

	/// What world.time we ended the game, set at round end.
	var/static/round_end_time

	/// Should we immediately start?
	var/start_immediately = FALSE
	/// All roundend preparation done with, all that's left is reboot.
	var/ready_for_reboot = FALSE
	/// Is round end delayed?
	var/delay_end = FALSE
	/// A message to display to anyone who tries to restart the world after a delay.
	var/admin_delay_notice = ""

	/// Boolean to track and check if our subsystem setup is done.
	var/setup_done = FALSE
	/// Force round end
	var/force_ending = FALSE

	/// Pregame timer.
	var/timeLeft
	var/start_at

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/post_game = 0
	var/event_time = null
	var/event = 0

	/// The people in the game. Used for objective tracking.
	var/list/datum/mind/minds = list()

	//! Why is this in Ticker??? @Zandario
	/// icon_state the chaplain has chosen for his bible.
	var/Bible_icon_state
	/// item_state the chaplain has chosen for his bible.
	var/Bible_item_state
	/// Name of the bible.
	var/Bible_name
	var/Bible_deity_name

	/// If set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders.
	var/random_players = 0

	/// List of traitor-compatible factions.
	var/list/syndicate_coalition = list()
	/// List of all factions.
	var/list/factions = list()
	/// List of factions with openings.
	var/list/availablefactions = list()

	var/triai = 0//Global holder for Triumvirate

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/atom/movable/screen/cinematic = null

	var/static/round_start_time
	var/static/list/round_start_events
	var/static/list/round_end_events

/datum/controller/subsystem/ticker/Initialize()
	if(!syndicate_code_phrase)
		syndicate_code_phrase = generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response = generate_code_phrase()

	start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)

	return ..()

/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_INIT)
			// We fire after init finishes
			on_mc_init_finish()

		if(GAME_STATE_PREGAME)
			process_pregame()

		if(GAME_STATE_SETTING_UP)
			setup()
			setup_done = TRUE

		if(GAME_STATE_PLAYING)
			round_process()

			if(!mode.explosion_in_progress && mode.check_finished(force_ending) || force_ending)
				current_state = GAME_STATE_FINISHED
				round_end_time = world.time
				declare_completion()
				Master.SetRunLevel(RUNLEVEL_POSTGAME)

				callHook("roundend")

				if (mode.station_was_nuked)
					feedback_set_details("end_proper","nuke")
				else
					feedback_set_details("end_proper","proper completion")


				if(blackbox)
					blackbox.save_all_data_to_sql()

				send2irc("Server", "A round of [mode.name] just ended.")
				if(CONFIG_GET(string/chat_roundend_notice_tag))
					var/broadcastmessage = "The round has ended."
					if(CONFIG_GET(string/chat_reboot_role))
						broadcastmessage += "\n\n<@&[CONFIG_GET(string/chat_reboot_role)]>, the server will reboot shortly!"
					send2chat(broadcastmessage, CONFIG_GET(string/chat_roundend_notice_tag))

				SSdbcore.SetRoundEnd()
				SSpersistence.SavePersistence()


/datum/controller/subsystem/ticker/proc/on_mc_init_finish()
	send2irc("Server lobby is loaded and open at byond://[config_legacy.serverurl ? config_legacy.serverurl : (config_legacy.server ? config_legacy.server : "[world.address]:[world.port]")]")
	to_chat(world, "<span class='boldnotice'>Welcome to the pregame lobby!</span>")
	to_chat(world, "Please set up your character and select ready. The round will start in [CONFIG_GET(number/lobby_countdown)] seconds.")
	SEND_SOUND(world, sound('sound/misc/server-ready.ogg', volume = 100))
	current_state = GAME_STATE_PREGAME
	if(Master.initializations_finished_with_no_players_logged_in)
		start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
	fire()

/datum/controller/subsystem/ticker/proc/process_pregame()
	if(isnull(timeLeft))
		timeLeft = max(0,start_at - world.time)
	if(start_immediately)
		timeLeft = 0
	if(timeLeft < 0)
		return
	timeLeft -= wait
	if(timeLeft <= 0)
		current_state = GAME_STATE_SETTING_UP
		Master.SetRunLevel(RUNLEVEL_SETUP)
		if(start_immediately)
			fire()
	else if(!auto_gamemode_vote_attempted && (timeLeft <= CONFIG_GET(number/lobby_gamemode_vote_delay) SECONDS))
		auto_gamemode_vote_attempted = TRUE
		// patch this code later
		if(!SSvote.time_remaining)
			SSvote.autogamemode()
		//end

/datum/controller/subsystem/ticker/proc/Reboot(reason, end_string, delay)
	set waitfor = FALSE
	if(usr && !check_rights(R_SERVER, TRUE))
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDANNOUNCE("An admin has delayed the round end."))
		return

	to_chat(world, SPAN_BOLDANNOUNCE("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	var/start_wait = world.time
	//UNTIL(round_end_sound_sent || (world.time - start_wait) > (delay * 2))	//don't wait forever
	while(world.time - start_wait < delay)
		if(delay_end)		//delayed, break loop.
			break
		var/timeleft = delay - (world.time - start_wait)
		// If we have less than 10 seconds left.
		if(timeleft <= 10 SECONDS)
			to_chat(world, SPAN_BOLDANNOUNCE("Rebooting in [DisplayTimeText(timeleft, 1)]"))
			sleep(10)
		//If we have 30 seconds left, announce and sleep for the rest of the time.
		if(timeleft <= 30 SECONDS)
			var/time = timeleft - 10 SECONDS
			to_chat(world, SPAN_BOLDANNOUNCE("Rebooting in [DisplayTimeText(timeleft, 1)]"))
			sleep(time)
		// Otherwise, per minute.
		else
			to_chat(world, SPAN_BOLDANNOUNCE("Rebooting in [DisplayTimeText(timeleft, 1)]"))
			sleep(60 SECONDS)

	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDANNOUNCE("Reboot was cancelled by an admin."))
		return
	// if(end_string)
	// 	end_state = end_string

	log_game(SPAN_BOLDANNOUNCE("Rebooting World. [reason]"))

	world.Reboot()

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.timeLeft))
		return max(0, start_at - world.time)
	return timeLeft

/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(timeLeft))	//remember, negative means delayed
		start_at = world.time + newtime
	else
		timeLeft = newtime

/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, "<span class='boldannounce'>Starting game...</span>")
	var/init_start = world.timeofday

	//Create and announce mode
	if(master_mode=="secret")
		src.hide_mode = 1

	var/list/runnable_modes = config_legacy.get_runnable_modes()
	if((master_mode=="random") || (master_mode=="secret"))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			Master.SetRunLevel(RUNLEVEL_LOBBY)
			to_chat(world, "<B>Unable to choose playable game mode.</B> Reverting to pregame lobby.")
			return 0
		if(secret_force_mode != "secret")
			src.mode = config_legacy.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = config_legacy.probabilities[GM.config_tag]
			src.mode = config_legacy.gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config_legacy.pick_mode(master_mode)

	if(!src.mode)
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		to_chat(world, "<span class='danger'>Serious error in mode setup!</span> Reverting to pregame lobby.") //Uses setup instead of set up due to computational context.
		return 0

	SSjob.reset_occupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	SSjob.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.mode.can_start())
		to_chat(world, "<B>Unable to start [mode.name].</B> Not enough players readied, [config_legacy.player_requirements[mode.config_tag]] players needed. Reverting to pregame lobby.")
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		mode.fail_setup()
		mode = null
		SSjob.reset_occupations()
		return 0

	if(hide_mode)
		to_chat(world, "<B>The current game mode is - Secret!</B>")
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_chat(world, "<B>Possibilities:</B> [english_list(tmpmodes, and_text= "; ", comma_text = "; ")]")
	else
		src.mode.announce()

	setup_economy()
	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them.
	collect_minds()
	equip_characters()

	callHook("roundstart")

	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)

	for(var/obj/landmark/L in GLOB.landmarks_list)
		// type filtered, we cannot risk runtimes
		L.OnRoundstart()

	log_world("Game start took [(world.timeofday - init_start)/10]s")
	round_start_time = world.time
	SSdbcore.SetRoundStart()

	// TODO Dear God Fix This.  Fix all of this. Not just this line, this entire proc. This entire file!
	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		to_chat(world, "<font color=#4F49AF><B>Enjoy the game!</B></FONT>")
		SEND_SOUND(world, sound('sound/AI/welcome.ogg')) // Skie
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2irc("A round has started with no admins online.")

/*	SSsupply.process() 		//Start the supply shuttle regenerating points -- TLE // handled in scheduler
	master_controller.process()		//Start master_controller.process()
	lighting_controller.process()	//Start processing DynamicAreaLighting updates
	*/

	Master.SetRunLevel(RUNLEVEL_GAME)

	if(CONFIG_GET(flag/sql_enabled))
		//THIS REQUIRES THE INVOKE ASYNC.
		INVOKE_ASYNC(GLOBAL_PROC, .proc/statistic_cycle) // Polls population totals regularly and stores them in an SQL DB -- TLE
	return TRUE

//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()

//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
	if( cinematic )	return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 100
	cinematic.plane = PLANE_PLAYER_HUD
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	var/obj/structure/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && (T.z in GLOB.using_map.station_levels))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.set_stat(DEAD)
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.set_stat(DEAD)

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))


		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					SEND_SOUND(world, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in living_mob_list)
				if(M.loc.z in GLOB.using_map.station_levels)
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)	qdel(cinematic)		//end the cinematic
	if(temp_buckle)	qdel(temp_buckle)	//release everybody
	return


/datum/controller/subsystem/ticker/proc/create_characters()
	//! TEMPORARY PATCH: putting people in nullspace results in obscene behavior from BYOND
	//? since we really don't want to kill login ..() without reason, we spawn them at random overflow spawnpoint.
	var/obj/landmark/spawnpoint/S
	for(var/faction in SSjob.overflow_spawnpoints)
		var/list/spawnpoints = SSjob.overflow_spawnpoints[faction]
		S = SAFEPICK(spawnpoints)
	if(!S)
		log_and_message_admins("Unable to get overflow spawnpoint; roundstart is going to lag.")
	//! END
	for(var/mob/new_player/player in GLOB.player_list)
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role=="AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				var/mob/living/carbon/human/new_char = player.create_character(S)
				if(new_char)
					qdel(player)
				if(istype(new_char) && !(new_char.mind.assigned_role=="Cyborg"))
					data_core.manifest_inject(new_char)


/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in GLOB.player_list)
		if(player.mind)
			minds += player.mind


/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Facility Director")
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				SSjob.EquipRank(player, player.mind.assigned_role, 0)
				UpdateFactionList(player)
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!istype(M,/mob/new_player))
				to_chat(M, "Facility Directorship not forced on anyone.")


/datum/controller/subsystem/ticker/proc/round_process()
	if(current_state != GAME_STATE_PLAYING)
		return 0

	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag * 0.1) : (wait * 0.1)
	mode.process(dt)

	var/game_finished = 0
	var/mode_finished = 0
	if (config_legacy.continous_rounds)
		game_finished = (SSemergencyshuttle.returned() || mode.station_was_nuked)
		mode_finished = (!post_game && mode.check_finished())
	else
		game_finished = (mode.check_finished() || (SSemergencyshuttle.returned() && SSemergencyshuttle.evac == 1)) || universe_has_ended
		mode_finished = game_finished

	if (mode_finished)
		post_game = 1

		mode.cleanup()

		//call a transfer shuttle vote
		spawn(50)
			if(!round_end_announced) // Spam Prevention. Now it should announce only once.
				to_chat(world, "<span class='danger'>The round has ended!</span>")
				round_end_announced = 1
		if(!SSemergencyshuttle.departed)
			SSvote.autotransfer()

	return 1

/datum/controller/subsystem/ticker/proc/declare_completion()
	set waitfor = FALSE

	to_chat(world, "<span class='infoplain'><BR><BR><BR><span class='big bold'>The round has ended.</span></span>")
	log_game("The round has ended.")

	for(var/datum/callback/roundend_callbacks as anything in round_end_events)
		roundend_callbacks.InvokeAsync()
	LAZYCLEARLIST(round_end_events)


	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(SSemergencyshuttle.departed && SSemergencyshuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color=#4F49AF><b>You survived the round, but remained on [station_name()] as [Player.real_name].</b></font>")
					else
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color=#4F49AF><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>")
			else
				if(istype(Player,/mob/observer/dead))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
	to_chat(world, "<br>")

	CHECK_TICK

	for (var/mob/living/silicon/ai/aiPlayer in GLOB.mob_list)
		if (aiPlayer.stat != 2)
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b>")
		else
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>")
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			to_chat(world, "[robolist]")

	CHECK_TICK

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in GLOB.mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) survived as an AI-less stationbound synthetic! Its laws were:</b>")
			else
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:</b>")

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	CHECK_TICK

	if(dronecount)
		to_chat(world, "<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>")

	mode.declare_completion()//To declare normal completion.

	CHECK_TICK

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	CHECK_TICK

	ready_for_reboot = TRUE
	sleep(5 SECONDS)
	standard_reboot()

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(mode.station_was_nuked)
			Reboot("Station destroyed by Nuclear Device.", "nuke", 60 SECONDS)
		else
			Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")
