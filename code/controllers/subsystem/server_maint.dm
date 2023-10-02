#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 6
	subsystem_flags = SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_SERVER_MAINT
	init_order = INIT_ORDER_SERVER_MAINT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/cleanup_SSticker = 0

/datum/controller/subsystem/server_maint/fire(resumed = FALSE)
	if(!resumed)
		if(listclearnulls(GLOB.clients))
			log_world("Found a null in clients list!")
		src.currentrun = GLOB.clients.Copy()
		switch (cleanup_SSticker) // do only one of these at a time, once per 5 fires
			if (0)
				if(listclearnulls(GLOB.player_list))
					log_world("Found a null in GLOB.player_list!")
				cleanup_SSticker++
			if (5)
				if(listclearnulls(GLOB.mob_list))
					log_world("Found a null in GLOB.mob_list!")
				cleanup_SSticker++
			if (10)
				if(listclearnulls(living_mob_list))
					log_world("Found a null in living_mob_list!")
				cleanup_SSticker++
			if (15)
				if(listclearnulls(dead_mob_list))
					log_world("Found a null in dead_mob_list!")
				cleanup_SSticker++
			if (20)
				cleanup_SSticker = 0
			else
				cleanup_SSticker++

	var/list/currentrun = src.currentrun

	/*
	var/round_started = SSticker.HasRoundStarted()

	var/kick_inactive = CONFIG_GET(flag/kick_inactive)
	var/afk_period
	if(kick_inactive)
		afk_period = CONFIG_GET(number/afk_period)
	*/

	for(var/I in currentrun)
		var/client/C = I
		//handle kicking inactive players
		/*
		if(round_started && kick_inactive && C.is_afk(afk_period))
			var/cmob = C.mob
			if(!(isobserver(cmob) || (isdead(cmob) && C.holder)))
				log_access("AFK: [key_name(C)]")
				to_chat(C, "<span class='danger'>You have been inactive for more than [DisplayTimeText(afk_period)] and have been disconnected.</span>")
				qdel(C)
		*/

		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
			winset(C, null, "command=.update_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

/*
/datum/controller/subsystem/server_maint/Shutdown()
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", TRUE) //second parameter ensures only afk clients are kicked
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		var/datum/chatOutput/co = C.chatOutput
		if(co)
			co.ehjax_send(data = "roundrestart")
		if(server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")
	var/tgsversion = world.TgsVersion()
	if(tgsversion)
		SSblackbox.record_feedback("text", "server_tools", 1, tgsversion)
*/

/datum/controller/subsystem/server_maint/proc/UpdateHubStatus()
	if(!CONFIG_GET(flag/hub) || !CONFIG_GET(number/max_hub_pop))
		return FALSE //no point, hub / auto hub controls are disabled

	var/max_pop = CONFIG_GET(number/max_hub_pop)

	if(GLOB.clients.len > max_pop)
		world.update_hub_visibility(FALSE)
	else
		world.update_hub_visibility(TRUE)

#undef PING_BUFFER_TIME
