
	////////////
	//SECURITY//
	////////////
///Could probably do with being lower.
///Restricts client uploads to the server to 1MB
#define UPLOAD_LIMIT		1048576

#define LIMITER_SIZE	5
#define CURRENT_SECOND	1
#define SECOND_COUNT	2
#define CURRENT_MINUTE	3
#define MINUTE_COUNT	4
#define ADMINSWARNED_AT	5
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	// Rate limiting
	var/mtl = config_legacy.minute_topic_limit		//CONFIG_GET(number/minute_topic_limit)
	if (!holder && mtl)
		var/minute = round(world.time, 600)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (minute != topiclimiter[CURRENT_MINUTE])
			topiclimiter[CURRENT_MINUTE] = minute
			topiclimiter[MINUTE_COUNT] = 0
		topiclimiter[MINUTE_COUNT] += 1
		if (topiclimiter[MINUTE_COUNT] > mtl)
			var/msg = "Your previous action was ignored because you've done too many in a minute."
			if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				topiclimiter[ADMINSWARNED_AT] = minute
				msg += " Administrators have been informed."
				log_game("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
				message_admins("[ADMIN_LOOKUPFLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/stl = config_legacy.second_topic_limit		//CONFIG_GET(number/second_topic_limit)
	if (!holder && stl)
		var/second = round(world.time, 10)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (second != topiclimiter[CURRENT_SECOND])
			topiclimiter[CURRENT_SECOND] = second
			topiclimiter[SECOND_COUNT] = 0
		topiclimiter[SECOND_COUNT] += 1
		if (topiclimiter[SECOND_COUNT] > stl)
			to_chat(src, "<span class='danger'>Your previous action was ignored because you've done too many in a second</span>")
			return


	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		if(CONFIG_GET(flag/emergency_tgui_logging))
			log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")
		return

	//? Normal HREF handling go below

	// Log
	log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

	// Route statpanel
	if(href_list["statpanel"])
		_statpanel_act(href_list["statpanel"], href_list)
		return

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class='danger'>An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		src << browse("...", "window=asset_cache_browser")
		return
	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C,null)
		return

	// Depricated. go use TGS
	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>")
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		send2irc("AHELP", href_list["irc_msg"])
		return

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr,href_list)
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("stat")
			return _statpanel_act(href_list["act"], href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])
	if (hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	..()	//redirect to hsrc.Topic()


//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
	return 1



	///////////
	//CONNECT//
	///////////

/client/New(TopicData)
	//* pre-connect-ish
	// set appadmin for profiling or it might not work (?) (this is old code we just assume it's here for a reason)
	world.SetConfig("APP/admin", ckey, "role=admin")
	// block client.Topic() calls from connect
	TopicData = null
	// kick out invalid connections
	if(connection != "seeker" && connection != "web")
		return null
	// kick out guests
	if(!config_legacy.guests_allowed && is_guest() && !is_localhost())
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return
	// pre-connect greeting
	to_chat(src, "<font color='red'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</font>")
	// register in globals
	GLOB.clients += src
	GLOB.directory[ckey] = src

	//* record their existence (tm)
	// log & lookup updates
	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	// log connection in text file
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")
	// log to db
	log_connection_to_db()
	// log to player lookup
	update_lookup_in_db()

	//* Resolve storage datums
	// resolve persistent data
	persistent = resolve_client_data(ckey)
	//* Resolve database data
	player = new(key)
	player.log_connect()
	// todo: move preferences up here but above persistent

	//* Setup user interface
	// todo: move top level menu here, for now it has to be under prefs.
	// Instantiate statpanel
	statpanel_boot()
	// Instantiate tgui panel
	tgui_panel = new(src, "browseroutput")
	// Instantiate cutscene system
	init_cutscene_system()

	//* Setup admin tooling
	GLOB.ahelp_tickets.ClientLogin(src)
	// var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	holder = admin_datums[ckey]
	var/debug_tools_allowed = FALSE
	if(holder)
		GLOB.admins |= src
		holder.owner = src
		// connecting_admin = TRUE
		//if(check_rights_for(src, R_DEBUG))
		if(R_DEBUG & holder?.rights) //same wiht this, check_rights when?
			debug_tools_allowed = TRUE
	/*
	else if(GLOB.deadmins[ckey])
		add_verb(src, TYPE_PROC_REF(/client, readmin))
		connecting_admin = TRUE
	*/
	// if(CONFIG_GET(flag/enable_localhost_rank) && !connecting_admin)
	if(is_localhost() && CONFIG_GET(flag/enable_localhost_rank))
		holder = new /datum/admins("!localhost!", ALL, ckey)
		holder.owner = src
		GLOB.admins |= src
		//admins |= src // this makes them not have admin. what the fuck??
		// holder.associate(ckey)
		// connecting_admin = TRUE
	//CITADEL EDIT
	//if(check_rights_for(src, R_DEBUG))	//check if autoadmin gave us it
	if(R_DEBUG & holder?.rights) //this is absolutely horrid
		debug_tools_allowed = TRUE
	if(!debug_tools_allowed)
		world.SetConfig("APP/admin", ckey, null)
	//END CITADEL EDIT
	// todo: refactor and hoist
	//preferences datum - also holds some persistent data for the client (because we may as well keep these datums to a minimum)
	prefs = GLOB.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		GLOB.preferences_datums[ckey] = prefs

	prefs.client = src
	// todo: refactor
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	//fps = prefs.clientfps //(prefs.clientfps < 0) ? RECOMMENDED_FPS : prefs.clientfps

	// todo: hoist
	// build top level menu
	GLOB.main_window_menu.setup(src)

	//* WARNING: mob.login is always called async, aka immediately returns on sleep.
	//* we cannot enforce nosleep due to SDMM limitations.
	//* therefore, DO NOT PUT ANYTHING YOU WILL RELY ON LATER IN THIS PROC IN LOGIN!
	. = ..()	//calls mob.Login()

	handle_legacy_connection_whatevers()

	//* Connection Security
	// start caching it immediately
	INVOKE_ASYNC(SSipintel, TYPE_PROC_REF(/datum/controller/subsystem/ipintel, vpn_connection_check), address, ckey)
	// run onboarding gauntlet
	if(!onboarding())
		if(!queued_security_kick)
			security_kick("Unknown error during client init. Contact staff on Discord.", TRUE)
		return FALSE

	//* Initialize Input
	if(SSinput.initialized)
		set_macros()
		update_movement_keys()

	//* Initialize UI
	// initialize statbrowser
	// (we don't, the JS does it for us. by signalling statpanel_ready().)
	// Initialize tgui panel
	tgui_panel.initialize()
	// initialize cutscene browser
	// (we don't, the JS does it for us.)

	//if(alert_mob_dupe_login)
	//	spawn()
	//		alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")
	/*
	if (connection == "web" && !connecting_admin)
		if (!CONFIG_GET(flag/allow_webclient))
			to_chat(src, "Web client is disabled")
			qdel(src)
			return 0
		if (CONFIG_GET(flag/webclient_only_byond_members) && !IsByondMember())
			to_chat(src, "Sorry, but the web client is restricted to byond members only.")
			qdel(src)
			return 0

	if( (world.address == address || !address) && !GLOB.host )
		GLOB.host = key
		world.update_status()
	*/
	if(holder)
		add_admin_verbs()
		admin_memo_show()
		// to_chat(src, get_message_output("memo"))
		// adminGreet()

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")

	send_resources()

	//? Startup rendering
	pre_init_viewport()
	mob.reload_rendering()

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		winset(src, "infowindow.changelog", "background-color=#eaeaea;font-style=bold")
		if(config_legacy.aggressive_changelog)
			changelog()

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

	hook_vr("client_new",list(src))

	if(config_legacy.paranoia_logging)
		if(isnum(player.player_age) && player.player_age == -1)
			log_and_message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
		if(isnum(persistent.account_age) && persistent.account_age <= 2)
			log_and_message_admins("PARANOIA: [key_name(src)] has a very new BYOND account ([persistent.account_age] days).")

	//? We are done
	// set initialized if we're not queued for a security kick
	if(!queued_security_kick || panic_bunker_pending)
		initialized = TRUE
	else
		addtimer(CALLBACK(src, PROC_REF(deferred_initialization_block)), 0)
	// show any migration errors
	prefs.auto_flush_errors()
	// update our hub label
	SSserver_maint.UpdateHubStatus()

	//////////////
	//DISCONNECT//
	//////////////

/client/Del()
	if(!gc_destroyed)
		Destroy() //Clean up signals and timers.
	return ..()

/client/Destroy()
	// Unregister globals
	GLOB.clients -= src
	GLOB.directory -= ckey
	// log
	log_access("Logout: [key_name(src)]")
	// unreference storage datums
	prefs = null
	persistent = null
	player = null

	//* unsorted
	GLOB.ahelp_tickets.ClientLogout(src)
	if(prefs)
		prefs.client = null
		prefs = null
	SSserver_maint.UpdateHubStatus()
	if(holder)
		holder.owner = null
		GLOB.admins -= src //delete them on the managed one too

	active_mousedown_item = null
	SSping.currentrun -= src

	//* cleanup mob-side stuff
	// clear perspective
	if(using_perspective)
		set_perspective(null)

	//* cleanup UI
	// cleanup statbrowser
	statpanel_dispose()
	// cleanup cutscene system
	cleanup_cutscene_system()
	// cleanup tgui panel
	QDEL_NULL(tgui_panel)

	. = ..() //Even though we're going to be hard deleted there are still some things that want to know the destroy is happening
	return QDEL_HINT_HARDDEL_NOW

// here because it's similar to below

/client/proc/add_system_note(system_ckey, message)
	notes_add(ckey, message)
/*
	var/sql_system_ckey = sanitizeSQL(system_ckey)
	var/sql_ckey = sanitizeSQL(ckey)
	//check to see if we noted them in the last day.
	var/datum/DBQuery/query_get_notes = SSdbcore.NewQuery("SELECT id FROM [format_table_name("messages")] WHERE type = 'note' AND targetckey = '[sql_ckey]' AND adminckey = '[sql_system_ckey]' AND timestamp + INTERVAL 1 DAY < NOW() AND deleted = 0 AND expire_timestamp > NOW()")
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		qdel(query_get_notes)
		return
	qdel(query_get_notes)
	//regardless of above, make sure their last note is not from us, as no point in repeating the same note over and over.
	query_get_notes = SSdbcore.NewQuery("SELECT adminckey FROM [format_table_name("messages")] WHERE targetckey = '[sql_ckey]' AND deleted = 0 AND expire_timestamp > NOW() ORDER BY timestamp DESC LIMIT 1")
	if(!query_get_notes.Execute())
		qdel(query_get_notes)
		return
	if(query_get_notes.NextRow())
		if (query_get_notes.item[1] == system_ckey)
			qdel(query_get_notes)
			return
	qdel(query_get_notes)
	create_message("note", key, system_ckey, message, null, null, 0, 0, null, 0, 0)
*/

#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)
		return inactivity
	return 0

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	if (holder)
		sleep(1)
	else
		stoplag(5)

/client/Click(atom/object, atom/location, control, params)
	var/ab = FALSE
	var/list/L = params2list(params)
	if (object && object == middragatom && L["left"])
		ab = max(0, 5 SECONDS-(world.time-middragtime)*0.1)
	var/mcl = config_legacy.minute_click_limit		//CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0
		clicklimiter[MINUTE_COUNT] += 1+(ab)
		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				if (ab)
					log_game("[key_name(src)] is using the middle click aimbot exploit")
					message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] is using the middle click aimbot exploit")
					add_system_note("aimbot", "Is using the middle click aimbot exploit")
					log_click("DROPPED: [ckey] middle click aimbot on [middragatom]:[object]")

				log_game("[key_name(src)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
				message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/scl = config_legacy.second_click_limit		//CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0
		clicklimiter[SECOND_COUNT] += 1+(!!ab)
		if (clicklimiter[SECOND_COUNT] > scl)
			to_chat(src, "<span class='danger'>Your previous click was ignored because you've done too many in a second</span>")
			return

	if(ab) //Citadel edit, things with stuff.
		return

	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, null, "input.background-color=[COLOR_INPUT_DISABLED]")

	if(GLOB.log_clicks)
		log_click("CLICK: [ckey] [object]~[location]~[control]~[params]")

	return ..()

GLOBAL_VAR_INIT(log_clicks, FALSE)

/client/proc/last_activity_seconds()
	return inactivity / 10

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	spawn (10) //removing this spawn causes all clients to not get verbs.

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)
/*	// We don't have vox_sounds atm
		#if (PRELOAD_RSC == 0)
		for (var/name in GLOB.vox_sounds)
			var/file = GLOB.vox_sounds[name]
			Export("##action=load_rsc", file)
			stoplag()
		#endif
*/
//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir


/mob/proc/MayRespawn()
	return 0

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/client/proc/AnnouncePR(announcement)
	to_chat(src, announcement)

