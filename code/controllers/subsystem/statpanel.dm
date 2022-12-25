SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	priority = FIRE_PRIORITY_STATPANEL
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

	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if(!resumed)
		// dispose / rebuild caches
		cache_mc_data = null
		cache_server_data = build_server_data()
		cache_ticket_data = null
		cache_sdql_data = null
		// reset currentrun
		src.currentrun = GLOB.clients.Copy()
	// go through clients
	// cache for sanic speed
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		// grab victim
		var/client/player = currentrun[length(currentrun)]
		--currentrun.len
		// check if ready
		if(!player.statpanel_ready)
			continue
		// are they an admin?
		var/is_admin = !!player.holder
		// grab their mob data
		var/list/additional = player._statpanel_data()
		// assert primary status tab
		if(player.statpanel_tab("Status", TRUE))
			// server data has priority
			player << output(cache_server_data, "statpanel:byond_update")
			// send additional
			if(length(additional))
				player << output(url_encode(json_encode(additional)), "statpanel:byond_append")
		// assert admin tabs - these are special and do not check for additional info
		if(player.statpanel_tab("MC", is_admin))
			player << output(fetch_mc_data(), "statpanel:byond_update")
		if(player.statpanel_tab("Tickets", is_admin))
			player << output(fetch_ticket_data(), "statpanel:byond_update")
		if(player.statpanel_tab("SDQL2", is_admin && length(GLOB.sdql2_queries)))
			player << output(fetch_sdql2_data(), "statpanel:byond_update")


	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/target = currentrun[length(currentrun)]
		currentrun.len--
		if(M?.listed_turf)
			var/mob/target_mob = M
			if(!target_mob.TurfAdjacent(target_mob.listed_turf))
				target << output("", "statbrowser:remove_listedturf")
				target_mob.listed_turf = null
			else if(target.stat_tab == M?.listed_turf.name || !(M?.listed_turf.name in target.panel_tabs))
				var/list/overrides = list()
				var/list/turfitems = list()
				for(var/img in target.images)
					var/image/target_image = img
					if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
						continue
					overrides += target_image.loc
				turfitems[++turfitems.len] = list("[target_mob.listed_turf]", REF(target_mob.listed_turf), icon2html(target_mob.listed_turf, target, sourceonly=TRUE))
				for(var/tc in target_mob.listed_turf)
					var/atom/movable/turf_content = tc
					if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
						continue
					if(turf_content.invisibility > target_mob.see_invisible)
						continue
					if(turf_content in overrides)
						continue
					if(turf_content.IsObscured())
						continue
					if(length(turfitems) < 30) // only create images for the first 30 items on the turf, for performance reasons
						if(!(REF(turf_content) in cached_images))
							cached_images += REF(turf_content)
							turf_content.RegisterSignal(turf_content, COMSIG_PARENT_QDELETING, /atom/.proc/remove_from_cache) // we reset cache if anything in it gets deleted
							if(ismob(turf_content) || length(turf_content.overlays) > 2)
								turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), costly_icon2html(turf_content, target, sourceonly=TRUE))
							else
								turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content), icon2html(turf_content, target, sourceonly=TRUE))
						else
							turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
					else
						turfitems[++turfitems.len] = list("[turf_content.name]", REF(turf_content))
				turfitems = url_encode(json_encode(turfitems))
				target << output("[turfitems];", "statbrowser:update_listedturf")
		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/statpanels/proc/generate_mc_data()
	for(var/ss in Master.subsystems)
		var/datum/controller/subsystem/sub_system = ss
		#warn move to subsystem + check them for stat entry stuff
		mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")

/datum/controller/subsystem/statpanels/proc/fetch_mc_data()
	if(cache_mc_data)
		return cache_mc_data
	. = list()
	STATPANEL_DATA_ENTRY("CPU:", num2text(world.cpu))
	STATPANEL_DATA_ENTRY("Instances:", num2text(world.contents.len, 10))
	STATPANEL_DATA_ENTRY("World Time:", num2text(world.time))
	STATPANEL_DATA_CLICK(GLOB.stat_key(), GLOB.stat_entry(), "\ref[GLOB]")
	STATPANEL_DATA_CLICK(config.stat_key(), config.stat_entry(), "\ref[config]")
	STATPANEL_DATA_ENTRY("BYOND:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)")
	STATPANEL_DATA_CLICK(Master.stat_key(), Master.stat_entry(), "\ref[Master]")
	STATPANEL_DATA_CLICK(Failsafe.stat_key(), Failsafe.stat_entry(), "\ref[Failsafe]")
	STATPANEL_DATA_LINE("")
	for(var/datum/controller/subsystem/S as anything in Master.subsystems)
		STATPANEL_DATA_CLICK(S.stat_key(), S.stat_entry(), "\ref[S]")
	cache_mc_data = url_encode(json_encode(.))

/datum/controller/subsystem/statpanels/proc/build_server_data()
	if(cache_server_data)
		return cache_server_data
	. = list()
	STATPANEL_DATA_ENTRY("Ping", "[round(client.lastping,1)]ms (Avg: [round(client.avgping,1)]ms)")
	//L += SSmapping.stat_map_name
	STATPANEL_DATA_ENTRY("Round ID", "[GLOB.round_id || "ERROR"]")
	// VIRGO START
	STATPANEL_DATA_ENTRY("Station Time", stationtime2text())
	STATPANEL_DATA_ENTRY("Station Date", stationdate2text())
	STATPANEL_DATA_ENTRY("Round Duration", roundduration2text())
	// VIRGO END
	STATPANEL_DATA_ENTRY("Time dilation", SStime_track.stat_time_text)
	//L += SSshuttle.emergency_shuttle_stat_text
	var/shuttle_eta = SSemergencyshuttle.get_status_panel_eta()
	if(shuttle_eta)
		STATPANEL_DATA_ENTRY("Shuttle", shuttle_eta)
	cache_server_data = url_encode(json_encode(.))

/datum/controller/subsystem/statpanels/proc/fetch_ticket_data()
	if(cache_ticket_data)
		return cache_ticket_data
	cache_ticket_data = url_encode(json_encode(GLOB.ahelp_tickets.stat_data()))
	#warn impl

/datum/controller/subsystem/statpanels/proc/fetch_sdql2_data()
	if(cache_sdql2_data)
		return cache_sdql2_data
	. = list()
	STATPANEL_DATA_CLICK("Global SDQL2 List:", "\[Edit\]", "\ref[GLOB.sdql2_vv_statobj]")
	for(var/datum/SDQL2_query/Q in GLOB.sdql2_queries)
		. += Q.generate_stat()
	cache_sdql_data = url_encode(json_encode(.))

 	#warn impl

/atom/proc/remove_from_cache()
	SSstatpanels.cached_images -= REF(src)
