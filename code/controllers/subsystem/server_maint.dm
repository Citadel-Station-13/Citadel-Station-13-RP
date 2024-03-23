#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 6
	flags = SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_SERVER_MAINT
	init_order = INIT_ORDER_SERVER_MAINT
	init_stage = INITSTAGE_EARLY
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/cleanup_SSticker = 0

/datum/controller/subsystem/server_maint/PreInit()
	world.hub_password = "" //quickly! before the hubbies see us.

/datum/controller/subsystem/server_maint/Initialize()
	if (fexists("tmp/"))
		fdel("tmp/")

	if (CONFIG_GET(flag/hub))
		world.update_hub_visibility(TRUE)

	// var/datum/tgs_version/tgsversion = world.TgsVersion()
	// if(tgsversion)
	// 	SSblackbox.record_feedback("text", "server_tools", 1, tgsversion.raw_parameter)

	return SS_INIT_SUCCESS

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

	for(var/I in currentrun)
		var/client/C = I

		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
			winset(C, null, "command=.update_ping+[num2text(world.time+world.tick_lag*TICK_USAGE_REAL/100, 32)]")

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

/datum/controller/subsystem/server_maint/Shutdown()
	if (fexists("tmp/"))
		fdel("tmp/")

	var/server = config_legacy.server
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server) //if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")

/datum/controller/subsystem/server_maint/proc/UpdateHubStatus()
	if(!CONFIG_GET(flag/hub) || !CONFIG_GET(number/max_hub_pop))
		return FALSE //no point, hub / auto hub controls are disabled

	var/max_pop = CONFIG_GET(number/max_hub_pop)

	if(GLOB.clients.len > max_pop)
		world.update_hub_visibility(FALSE)
	else
		world.update_hub_visibility(TRUE)

#undef PING_BUFFER_TIME
