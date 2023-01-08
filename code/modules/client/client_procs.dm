
	////////////
	//SECURITY//
	////////////
///Could probably do with being lower.
///Restricts client uploads to the server to 1MB
#define UPLOAD_LIMIT		1048576
GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "bug causing right-click menus to show too many verbs that's been fixed in version 1429",

	))

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
	//! pre-connect-ish
	// set appadmin for profiling or it might not work (?) (this is old code we just assume it's here for a reason)
	world.SetConfig("APP/admin", ckey, "role=admin")
	// block client.Topic() calls from connect
	TopicData = null
	// kick out invalid connections
	if(connection != "seeker" && connection != "web")
		return null
	// kick out guests
	if(!config_legacy.guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return
	// pre-connect greeting
	to_chat(src, "<font color='red'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</font>")
	// register in globals
	GLOB.clients += src
	GLOB.directory[ckey] = src

	//! Resolve storage datums
	// resolve persistent data
	persistent = resolve_client_data(ckey)
	// todo: move resolve database data up here but above preferences
	// todo: move preferences up here but above persistent

	//! Setup user interface
	// todo: move top level menu here, for now it has to be under prefs.
	// Instantiate statpanel
	statpanel_boot()
	// Instantiate tgui panel
	tgui_panel = new(src, "browseroutput")

	//! Setup admin tooling
	GLOB.ahelp_tickets.ClientLogin(src)
	var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	holder = admin_datums[ckey]
	var/debug_tools_allowed = FALSE
	if(holder)
		GLOB.admins |= src
		holder.owner = src
		connecting_admin = TRUE
		//if(check_rights_for(src, R_DEBUG))
		if(R_DEBUG & holder?.rights) //same wiht this, check_rights when?
			debug_tools_allowed = TRUE
	/*
	else if(GLOB.deadmins[ckey])
		add_verb(src, /client/proc/readmin)
		connecting_admin = TRUE
	if(CONFIG_GET(flag/autoadmin))
		if(!GLOB.admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in GLOB.admin_ranks)
				if(R.name == CONFIG_GET(string/autoadmin_rank))
					autorank = R
					break
			if(!autorank)
				to_chat(world, "Autoadmin rank not found")
			else
				new /datum/admins(autorank, ckey)
	*/
	// if(CONFIG_GET(flag/enable_localhost_rank) && !connecting_admin)
	if(isnull(address) || (address in list("127.0.0.1", "::1")))
		holder = new /datum/admins("!localhost!", ALL, ckey)
		holder.owner = src
		GLOB.admins |= src
		//admins |= src // this makes them not have admin. what the fuck??
		// holder.associate(ckey)
		connecting_admin = TRUE
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

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")
	/*
	var/alert_mob_dupe_login = FALSE
	if(CONFIG_GET(flag/log_access))
		for(var/I in GLOB.clients)
			if(!I || I == src)
				continue
			var/client/C = I
			if(C.key && (C.key != key) )
				var/matches
				if( (C.address == address) )
					matches += "IP ([address])"
				if( (C.computer_id == computer_id) )
					if(matches)
						matches += " and "
					matches += "ID ([computer_id])"
					alert_mob_dupe_login = TRUE
				if(matches)
					if(C)
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)].</span>")
						log_admin_private("Notice: [key_name(src)] has the same [matches] as [key_name(C)].")
					else
						message_admins("<span class='danger'><B>Notice: </B></span><span class='notice'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)] (no longer logged in). </span>")
						log_admin_private("Notice: [key_name(src)] has the same [matches] as [key_name(C)] (no longer logged in).")


	if(GLOB.player_details[ckey])
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
	else
		player_details = new(ckey)
		player_details.byond_version = full_version
		GLOB.player_details[ckey] = player_details
	*/

	//! WARNING: mob.login is always called async, aka immediately returns on sleep.
	//! we cannot enforce nosleep due to SDMM limitations.
	//! therefore, DO NOT PUT ANYTHING YOU WILL RELY ON LATER IN THIS PROC IN LOGIN!
	. = ..()	//calls mob.Login()

	// if(!using_perspective)
	// 	stack_trace("mob login didn't put in perspective")

	if(log_client_to_db() == "BUNKER_DROPPED")
		disconnect_with_message("Disconnected by bunker: [config_legacy.panic_bunker_message]")
		return FALSE

	// resolve database data
	// this is down here because player_lookup won't have an entry for us until log_client_to_db() runs!!
	database = new(ckey)
	database.log_connect()

	if (byond_version >= 512)
		if (!byond_build || byond_build < 1386)
			message_admins("<span class='adminnotice'>[key_name(src)] has been detected as spoofing their byond version. Connection rejected.</span>")
			add_system_note("Spoofed-Byond-Version", "Detected as using a spoofed byond version.")
			log_access("Failed Login: [key] - Spoofed byond version")
			qdel(src)

		if (num2text(byond_build) in GLOB.blacklisted_builds)
			log_access("Failed login: [key] - blacklisted byond version")
			to_chat(src, "<span class='userdanger'>Your version of byond is blacklisted.</span>")
			to_chat(src, "<span class='danger'>Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]].</span>")
			to_chat(src, "<span class='danger'>Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions.</span>")
			if(connecting_admin)
				to_chat(src, "As an admin, you are being allowed to continue using this version, but please consider changing byond versions")
			else
				disconnect_with_message("Your version of BYOND ([byond_version].[byond_build]) is blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]]. Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions.")
				return

	if(SSinput.initialized)
		set_macros()
		update_movement_keys()

	// Initialize stat panel
	// stat_panel.initialize(
	// 	inline_html = file2text('html/statbrowser.html'),
	// 	inline_js = file2text('html/statbrowser.js'),
	// 	inline_css = file2text('html/statbrowser.css'),
	// )

	//! Initialize UI
	// initialize statbrowser
	// (we don't, the JS does it for us. by signalling statpanel_ready().)
	// Initialize tgui panel
	tgui_panel.initialize()

	//if(alert_mob_dupe_login)
	//	spawn()
	//		alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")
	var/cev = CONFIG_GET(number/client_error_version)
	var/ceb = CONFIG_GET(number/client_error_build)
	var/cwv = CONFIG_GET(number/client_warn_version)
	if (byond_version < cev || (byond_version == cev && byond_build < ceb))		//Out of date client.
		to_chat(src, "<span class='danger'><b>Your version of BYOND is too old:</b></span>")
		to_chat(src, CONFIG_GET(string/client_error_message))
		to_chat(src, "Your version: [byond_version].[byond_build]")
		to_chat(src, "Required version: [cev].[ceb] or later")
		to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (connecting_admin)
			to_chat(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			disconnect_with_message("Your BYOND version ([byond_version].[byond_build]) is too old. Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
			return 0
	else if (byond_version < cwv)	//We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>Your version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version]<br>"
			msg += "Required version to remove this message: [cwv] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(msg, "window=warning_popup")
		else
			to_chat(src, "<span class='danger'><b>Your version of byond may be getting out of date:</b></span>")
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version]")
			to_chat(src, "Required version to remove this message: [cwv] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
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
		if(isnum(player_age) && player_age == -1)
			log_and_message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
		if(isnum(account_age) && account_age <= 2)
			log_and_message_admins("PARANOIA: [key_name(src)] has a very new BYOND account ([account_age] days).")

	//? We are done
	// set initialized
	initialized = TRUE
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
	GLOB.clients -= src
	GLOB.directory -= ckey
	log_access("Logout: [key_name(src)]")
	GLOB.ahelp_tickets.ClientLogout(src)
	persistent = null
	database = null
	if(prefs)
		prefs.client = null
		prefs = null
	SSserver_maint.UpdateHubStatus()
	if(holder)
		holder.owner = null
		GLOB.admins -= src //delete them on the managed one too
	if(using_perspective)
		set_perspective(null)

	active_mousedown_item = null
	SSping.currentrun -= src

	//! cleanup UI
	/// cleanup statbrowser
	statpanel_dispose()

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

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	if(!SSdbcore.Connect())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/datum/db_query/query = SSdbcore.RunQuery(
		"SELECT id, datediff(Now(), firstseen) as age FROM [format_table_name("player_lookup")] WHERE ckey = :ckey",
		list(
			"ckey" = sql_ckey
		)
	)
	var/sql_id = 0
	player_age = -1	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	account_join_date = sanitizeSQL(findJoinDate())
	if(account_join_date && SSdbcore.Connect())
		var/datum/db_query/query_datediff = SSdbcore.RunQuery(
			"SELECT DATEDIFF(Now(), :date)",
			list(
				"date" = account_join_date
			)
		)
		if(query_datediff.NextRow())
			account_age = text2num(query_datediff.item[1])

	var/datum/db_query/query_ip = SSdbcore.RunQuery(
		"SELECT ckey FROM [format_table_name("player_lookup")] WHERE ip = :addr",
		list(
			"addr" = address
		)
	)
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/datum/db_query/query_cid = SSdbcore.RunQuery(
		"SELECT ckey FROM [format_table_name("player_lookup")] WHERE computerid = :cid",
		list(
			"cid" = sanitizeSQL(computer_id)
		)
	)
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address) || "0.0.0.0"
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	//Panic bunker code
	if ((player_age == -1) && !(ckey in GLOB.bunker_passthrough)) //first connection
		if (config_legacy.panic_bunker && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, config_legacy.panic_bunker_message)
			return "BUNKER_DROPPED"
	if(player_age == -1)
		player_age = 0		//math requires this to not be -1.

	if(config_legacy.ip_reputation)
		if(config_legacy.ipr_allow_existing && player_age >= config_legacy.ipr_minimum_age)
			log_admin("Skipping IP reputation check on [key] with [address] because of player age")
		else if(update_ip_reputation()) //It is set now
			if(ip_reputation >= config_legacy.ipr_bad_score) //It's bad
				//Log it
				if(config_legacy.paranoia_logging) //We don't block, but we want paranoia log messages
					log_and_message_admins("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")
				else //We just log it
					log_admin("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")

				//Take action if required
				if(config_legacy.ipr_block_bad_ips && config_legacy.ipr_allow_existing) //We allow players of an age, but you don't meet it
					disconnect_with_message("Sorry, we only allow VPN/Proxy/Tor usage for players who have spent at least [config_legacy.ipr_minimum_age] days on the server. If you are unable to use the internet without your VPN/Proxy/Tor, please contact an admin out-of-game to let them know so we can accommodate this.")
					return 0
				else if(config_legacy.ipr_block_bad_ips) //We don't allow players of any particular age
					disconnect_with_message("Sorry, we do not accept connections from users via VPN/Proxy/Tor connections. If you believe this is in error, contact an admin out-of-game.")
					return 0
		else
			log_admin("Couldn't perform IP check on [key] with [address]")

	// Department Hours
	if(config_legacy.time_off)
		var/datum/db_query/query_hours = SSdbcore.RunQuery(
			"SELECT department, hours FROM [format_table_name("vr_player_hours")] WHERE ckey = :ckey",
			list(
				"ckey" = sql_ckey
			)
		)
		while(query_hours.NextRow())
			LAZYINITLIST(department_hours)
			department_hours[query_hours.item[1]] = text2num(query_hours.item[2])

	if(sql_id)
		SSdbcore.RunQuery(
			"UPDATE [format_table_name("player_lookup")] SET lastseen = Now(), ip = :ip, computerid = :computerid, lastadminrank = :lastadminrank WHERE id = :id",
			list(
				"ip" = sql_ip,
				"computerid" = sql_computerid,
				"lastadminrank" = sql_admin_rank,
				"id" = sql_id
			)
		)
	else
		//New player!! Need to insert all the stuff
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("player_lookup")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, :ckey, Now(), Now(), :ip, :cid, :rank)",
			list(
				"ckey" = sql_ckey,
				"ip" = sql_ip,
				"cid" = sql_computerid,
				"rank" = sql_admin_rank
			)
		)

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	SSdbcore.RunQuery(
		"INSERT INTO [format_table_name("connection_log")] (id, datetime, serverip, ckey, ip, computerid) VALUES (null, Now(), :serverip, :ckey, :ip, :computerid)",
		list(
			"serverip" = serverip,
			"ckey" = sql_ckey,
			"ip" = sql_ip,
			"computerid" = sql_computerid
		)
	)

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
			addtimer(CALLBACK(SSassets.transport, /datum/asset_transport.proc/send_assets_slow, src, SSassets.transport.preload), 5 SECONDS)
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

/client/vv_edit_var(var_name, var_value)
	switch (var_name)
		if (NAMEOF(src, holder))
			return FALSE
		if (NAMEOF(src, ckey))
			return FALSE
		if (NAMEOF(src, key))
			return FALSE
		if(NAMEOF(src, view))
			change_view(var_value, TRUE)
			return TRUE
	. = ..()

/client/proc/change_view(new_size, forced, translocate)
	set waitfor = FALSE	// to async temporary view
	// todo: refactor this, client view changes should be ephemeral.
	var/list/L = getviewsize(new_size)
	set_temporary_view(L[1], L[2])

/**
 * directly sets our view
 * you should probably be using perspective datums most of the time instead
 * WARNING: this is verbatim; aka, view = 7 is 15 width 15 height, NOT 7x7!
 *
 * furthermore, this proc is BLOCKING.
 */
/client/proc/set_temporary_view(width, height)
	if(!width || !height || width < 0 || height < 0)
		reset_temporary_view()
		return
	using_temporary_viewsize = TRUE
	temporary_viewsize_width = width
	temporary_viewsize_height = height
	request_viewport_update()

/**
 * resets our temporary view
 * you should probably be using perspective datums most of the time instead
 *
 * furthermore, this proc is BLOCKING
 */
/client/proc/reset_temporary_view()
	using_temporary_viewsize = FALSE
	temporary_viewsize_height = null
	temporary_viewsize_width = null
	request_viewport_update()

/**
 * switch perspective - null will cause us to shunt our eye to nullspace!
 */
/client/proc/set_perspective(datum/perspective/P)
	if(using_perspective)
		using_perspective.RemoveClient(src, TRUE)
		if(using_perspective)
			stack_trace("using perspective didn't clear")
			using_perspective = null
	if(!P)
		eye = null
		lazy_eye = 0
		perspective = EYE_PERSPECTIVE
		return
	P.AddClient(src)
	if(using_perspective != P)
		stack_trace("using perspective didn't set")

/**
 * reset perspective to default - usually to our mob's
 */
/client/proc/reset_perspective()
	set_perspective(mob.get_perspective())

/mob/proc/MayRespawn()
	return 0

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences"
	if(prefs)
		prefs.ShowChoices(usr)

/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond age check for [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

/client/proc/AnnouncePR(announcement)
	//if(prefs && prefs.chat_toggles & CHAT_PULLR)
	to_chat(src, announcement)

//This is for getipintel.net.
//You're welcome to replace this proc with your own that does your own cool stuff.
//Just set the client's ip_reputation var and make sure it makes sense with your config settings (higher numbers are worse results)
/client/proc/update_ip_reputation()
	var/request = "http://check.getipintel.net/check.php?ip=[address]&contact=[config_legacy.ipr_email]"
	var/http[] = world.Export(request)

	/* Debug
	TO_WORLD_log("Requested this: [request]")
	for(var/entry in http)
		TO_WORLD_log("[entry] : [http[entry]]")
	*/

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		log_admin("Couldn't connect to getipintel.net to check [address] for [key]")
		return FALSE

	//429 is rate limit exceeded
	if(text2num(http["STATUS"]) == 429)
		log_and_message_admins("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
		config_legacy.ip_reputation = FALSE
		return FALSE

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return FALSE

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		var/ipr_error = "getipintel.net IP reputation check error while checking [address] for [key]: "
		switch(score)
			if(-1)
				ipr_error += "No input provided"
			if(-2)
				fatal = FALSE
				ipr_error += "Invalid IP provided"
			if(-3)
				fatal = FALSE
				ipr_error += "Unroutable/private IP (spoofing?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Unable to reach database"
			if(-5)
				ipr_error += "Our IP is banned or otherwise forbidden"
			if(-6)
				ipr_error += "Missing contact info"

		log_and_message_admins(ipr_error)
		if(fatal)
			config_legacy.ip_reputation = FALSE
			log_and_message_admins("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
		return FALSE

	//Went fine
	else
		ip_reputation = score
		return TRUE

/client/proc/disconnect_with_message(var/message = "You have been intentionally disconnected by the server.<br>This may be for security or administrative reasons.")
	message = "<head><title>You Have Been Disconnected</title></head><body><hr><center><b>[message]</b></center><hr><br>If you feel this is in error, you can contact an administrator out-of-game (for example, on Discord).</body>"
	window_flash(src)
	src << browse(message,"window=dropmessage;size=480x360;can_close=1")
	qdel(src)
