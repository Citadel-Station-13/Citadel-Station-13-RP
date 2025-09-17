SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	init_stage = INIT_STAGE_BACKEND
	priority = FIRE_PRIORITY_STATPANELS
	subsystem_flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	//! ticking
	/// current clients we're pushing to
	var/list/currentrun = list()

	//! caching
	/// cached mc data
	var/cache_mc_data
	/// cached server-wide data
	var/cache_server_data
	/// cached tickets data
	var/cache_ticket_data
	/// cached sdql2 data
	var/cache_sdql_data

/datum/controller/subsystem/statpanels/fire(resumed = FALSE, no_tick_check)
	if(!resumed)
		// dispose / rebuild caches
		cache_mc_data = null
		cache_server_data = null
		build_server_data()
		cache_ticket_data = null
		cache_sdql_data = null
		// reset currentrun
		src.currentrun = GLOB.clients.Copy()
	// go through clients
	// cache for sanic speed
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		if(!no_tick_check && MC_TICK_CHECK)
			return
		// grab victim
		var/client/player = currentrun[length(currentrun)]
		--currentrun.len
		// check if ready
		// this is not a client initialized check, it's a "exists and ready" check.
		// we intentionally don't wait for full init
		if(!player.tgui_stat?.ready)
			continue
		// check listed turf, even if we're on JS stat
		if(player.tgui_stat.byond_stat_turf && !player.list_turf_check(player.tgui_stat.byond_stat_turf))
			player.unlist_turf()
		// check if we're even on the js one
		if(player.tgui_stat.byond_stat_active)
			continue
		// are they an admin?
		var/is_admin = !!player.holder
		// grab their mob data
		var/list/additional = player._statpanel_data()
		// server data has priority
		// assert primary status tab
		var/server_data = "%5b%5d" // "[]"
		if(player.statpanel_tab("Status", TRUE))
			server_data = cache_server_data
		// assert admin tabs - these are special and do not check for additional info
		if(player.statpanel_tab("MC", is_admin))
			server_data = fetch_mc_data()
		if(player.statpanel_tab("Tickets", is_admin))
			server_data = fetch_ticket_data()
		if(player.statpanel_tab("SDQL2", is_admin && length(GLOB.sdql2_queries)))
			server_data = fetch_sdql2_data()
		// send additional
		player << output("[server_data];[url_encode(json_encode(additional))]", "statbrowser:byond_update")

//? Cache generator procs
//? Errors will cause JS panel error spam.
//? Thus, we rigidly check references, even for things like GLOB which shouldn't ever be missing.

/datum/controller/subsystem/statpanels/proc/fetch_mc_data()
	if(cache_mc_data)
		return cache_mc_data
	. = list()
	INJECT_STATPANEL_DATA_ENTRY(., "CPU:", num2text(world.cpu))
	INJECT_STATPANEL_DATA_ENTRY(., "Instances:", num2text(world.contents.len, 10))
	INJECT_STATPANEL_DATA_ENTRY(., "World Time:", num2text(world.time))
	if(GLOB)
		INJECT_STATPANEL_DATA_CLICK(., GLOB.stat_key(), GLOB.stat_entry(), "\ref[GLOB]")
	else
		INJECT_STATPANEL_DATA_LINE(., "FATAL - NO GLOB")
	if(config)
		INJECT_STATPANEL_DATA_CLICK(., config.stat_key(), config.stat_entry(), "\ref[config]")
	else
		INJECT_STATPANEL_DATA_LINE(., "FATAL - NO CONFIG")
	if(config)
		INJECT_STATPANEL_DATA_CLICK(., Configuration.stat_key(), Configuration.stat_entry(), "\ref[Configuration]")
	else
		INJECT_STATPANEL_DATA_LINE(., "FATAL - NO CONFIG (NEW)")
	INJECT_STATPANEL_DATA_ENTRY(., "BYOND:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)")
	if(Master)
		INJECT_STATPANEL_DATA_CLICK(., Master.stat_key(), Master.stat_entry(), "\ref[Master]")
	else
		INJECT_STATPANEL_DATA_LINE(., "FATAL - NO MASTER CONTROLLER")
	if(Failsafe)
		INJECT_STATPANEL_DATA_CLICK(., Failsafe.stat_key(), Failsafe.stat_entry(), "\ref[Failsafe]")
	else
		INJECT_STATPANEL_DATA_LINE(., "WARNING - NO FAILSAFE")
	INJECT_STATPANEL_DATA_LINE(., "")
	for(var/datum/controller/subsystem/S as anything in Master.subsystems)
		INJECT_STATPANEL_DATA_CLICK(., S.stat_key(), S.stat_entry(), "\ref[S]")
	. = url_encode(json_encode(.))
	cache_mc_data = .

/datum/controller/subsystem/statpanels/proc/build_server_data()
	if(cache_server_data)
		return cache_server_data
	. = list()
	//L += SSmapping.stat_map_name
	INJECT_STATPANEL_DATA_ENTRY(., "Round ID", "[GLOB?.round_id || "ERROR"]")
	// VIRGO START
	INJECT_STATPANEL_DATA_ENTRY(., "Station Time", stationtime2text())
	INJECT_STATPANEL_DATA_ENTRY(., "Station Date", stationdate2text())
	INJECT_STATPANEL_DATA_ENTRY(., "Round Duration", roundduration2text())
	// VIRGO END
	INJECT_STATPANEL_DATA_ENTRY(., "Time dilation", SStime_track.stat_time_text)
	//L += SSshuttle.emergency_shuttle_stat_text
	var/shuttle_eta = SSemergencyshuttle.get_status_panel_eta()
	if(shuttle_eta)
		INJECT_STATPANEL_DATA_ENTRY(., "Shuttle", shuttle_eta)
	. = url_encode(json_encode(.))
	cache_server_data = .

/datum/controller/subsystem/statpanels/proc/fetch_ticket_data()
	if(cache_ticket_data)
		return cache_ticket_data
	if(!GLOB.ahelp_tickets)
		. = list()
		INJECT_STATPANEL_DATA_LINE(., "FATAL - NO GLOBAL TICKETS HOLDER")
		. = url_encode(json_encode(.))
	else
		. = url_encode(json_encode(GLOB.ahelp_tickets.stat_data()))
	cache_ticket_data = .

/datum/controller/subsystem/statpanels/proc/fetch_sdql2_data()
	if(cache_sdql_data)
		return cache_sdql_data
	. = list()
	INJECT_STATPANEL_DATA_CLICK(., "Global SDQL2 List:", "\[Edit\]", "\ref[GLOB?.sdql2_vv_statobj]")
	for(var/datum/SDQL2_query/Q in GLOB.sdql2_queries)
		. += Q.generate_stat()
	. = url_encode(json_encode(.))
	cache_sdql_data = .
