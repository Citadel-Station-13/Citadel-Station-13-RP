	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.

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

	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

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
				message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
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


	//Logs all hrefs, except chat pings
	if(!(href_list["_src_"] == "chat" && href_list["proc"] == "ping" && LAZYLEN(href_list) == 2))
		log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

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

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>")
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		send2adminirc(href_list["irc_msg"])
		return

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		// if("mentor") // CITADEL
		// 	hsrc = mentor_datum // CITADEL END
		if("prefs")
			// if (inprefs)
				// return
			// inprefs = TRUE
			. = prefs.process_link(usr,href_list)
			// inprefs = FALSE
			return
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("chat")
			return chatOutput.Topic(href, href_list)

	if (hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	..()	//redirect to hsrc.Topic()

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return FALSE
	return TRUE


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
GLOBAL_LIST_EMPTY(external_rsc_urls)
#endif

/client/New(TopicData)
	// world.SetConfig("APP/admin", ckey, "role=admin")			//CITADEL EDIT - Allows admins to reboot in OOM situations
	//var/tdata = TopicData //save this for later use
	chatOutput = new /datum/chatOutput(src)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null

	if(!config_legacy.guests_allowed && IsGuestKey(key))
		alert(src, "This server doesn't allow guest accounts to play. Please go to https://secure.byond.com and register for a key.","Guest","OK")
		qdel(src)
		return

	to_chat(src, "<font color='red'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</font>")

	GLOB.clients += src
	GLOB.directory[ckey] = src

	GLOB.ahelp_tickets.ClientLogin(src)
	var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		GLOB.admins |= src //HEY! Go use this soon!
		admins |= src
		holder.owner = src
		connecting_admin = TRUE
	// else if(GLOB.deadmins[ckey])
	// 	verbs += /client/proc/readmin
	// 	connecting_admin = TRUE
	// Localhost connections get full admin rights and a special rank
	else if(isnull(address) || (address in list("127.0.0.1", "::1")))
		holder = new /datum/admins("!localhost!", ALL, ckey)
		holder.associate(ckey)

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]

	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs

	if(SSinput.subsystem_initialized)
		set_macros()
	update_movement_keys(prefs)

	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")

	var/alert_mob_dupe_login = FALSE
	// if(CONFIG_GET(flag/log_access)) log the wizardry
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
					message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)].</font>")
					log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)].")
				else
					message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)] (no longer logged in). </font>")
					log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)] (no longer logged in).")

	. = ..()	//calls mob.Login()

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
				qdel(src)
				return

	chatOutput.start() // Starts the chat

	if(alert_mob_dupe_login)
		spawn()
			alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"") //RTX ON
	prefs.sanitize_preferences()

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")


	if(holder)
		add_admin_verbs()
		admin_memo_show()

	log_client_to_db()

	add_verbs_from_config()

	if(config_legacy.paranoia_logging)
		if(isnum(player_age) && player_age == -1)
			log_and_message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
		if(isnum(account_age) && account_age <= 2)
			log_and_message_admins("PARANOIA: [key_name(src)] has a very new BYOND account ([account_age] days).")

	send_resources()
	generate_clickcatcher()
	apply_clickcatcher()

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		if(config_legacy.aggressive_changelog) //CONFIG_GET(flag/aggressive_changelog))
			changelog()
		else
			winset(src, "infowindow.changelog", "font-style=bold")


	hook_vr("client_new",list(src)) //VOREStation Code

	var/list/topmenus = GLOB.menulist[/datum/verbs/menu]
	for (var/thing in topmenus)
		var/datum/verbs/menu/topmenu = thing
		var/topmenuname = "[topmenu]"
		if (topmenuname == "[topmenu.type]")
			var/list/tree = splittext(topmenuname, "/")
			topmenuname = tree[tree.len]
		winset(src, "[topmenu.type]", "parent=menu;name=[url_encode(topmenuname)]")
		var/list/entries = topmenu.Generate_list(src)
		for (var/child in entries)
			winset(src, "[child]", "[entries[child]]")
			if (!ispath(child, /datum/verbs/menu))
				var/procpath/verbpath = child
				if (verbpath.name[1] != "@")
					new child(src)

	for (var/thing in prefs.menuoptions)
		var/datum/verbs/menu/menuitem = GLOB.menulist[thing]
		if (menuitem)
			menuitem.Load_checked(src)

	// Master.UpdateTickRate()

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	log_access("Logout: [key_name(src)]")
	if(holder)
		holder.owner = null
		GLOB.admins -= src
		admins -= src //old admin arry

	GLOB.ahelp_tickets.ClientLogout(src)
	GLOB.directory -= ckey
	GLOB.clients -= src
	return ..()

/client/Destroy()
	return QDEL_HINT_HARDDEL_NOW

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
					message_admins("[ADMIN_LOOKUPFLW(src)] [ADMIN_KICK(usr)] is using the middle click aimbot exploit</span>")
					add_system_note("aimbot", "Is using the middle click aimbot exploit")
				//	log_click(object, location, control, params, src, "lockout (spam - minute ab c [ab] s [middragtime])", TRUE)
				//else
				//	log_click(object, location, control, params, src, "lockout (spam - minute)", TRUE)
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
		//log_click(object, location, control, params, src, "dropped (ab c [ab] s [middragtime])", TRUE)
		return

	//if(prefs.log_clicks)
	//	log_click(object, location, control, params, src)

	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, null, "input.background-color=[COLOR_INPUT_DISABLED]")

	return ..()

/client/proc/add_verbs_from_config()
	//if(CONFIG_GET(flag/see_own_notes))
	//	verbs += /client/proc/self_notes
	//if(CONFIG_GET(flag/use_exp_tracking))
	//	verbs += /client/proc/self_playtime

#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration = 3000) //CONFIG_GET(number/inactivity_period)
	if(inactivity > duration)
		return inactivity
	return FALSE

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	if(GLOB.external_rsc_urls && GLOB.external_rsc_urls.len)
		next_external_rsc = WRAP(next_external_rsc+1, 1, GLOB.external_rsc_urls.len+1)
		preload_rsc = GLOB.external_rsc_urls[next_external_rsc]
#endif
	//get the common files. There is a reason on why this is not using the asset system
	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/browser/common.css',
		'html/browser/scannernew.css'
		// 'html/browser/playeroptions.css',
		)
	spawn (10) //removing this spawn causes all clients to not get verbs.

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		getFilesSlow(src, SSassets.preload, register_asset = FALSE)
		addtimer(CALLBACK(GLOBAL_PROC, /proc/getFilesSlow, src, SSassets.preload, FALSE), 5 SECONDS)

		//#if (PRELOAD_RSC == 0)
		// for (var/name in GLOB.vox_sounds)
		// 	var/file = GLOB.vox_sounds[name]
		// 	Export("##action=load_rsc", file)
		// 	stoplag()
		// for (var/name in GLOB.vox_sounds_male)
		// 	var/file = GLOB.vox_sounds_male[name]
		// 	Export("##action=load_rsc", file)
		// 	stoplag()
		//#endif

/client/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("holder")
			return FALSE
		if ("ckey")
			return FALSE
		if ("key")
			return FALSE
		if("view")
			change_view(var_value)
			return TRUE
	. = ..()

/client/proc/rescale_view(change, min, max)
	var/viewscale = getviewsize(view)
	var/x = viewscale[1]
	var/y = viewscale[2]
	x = clamp(x+change, min, max)
	y = clamp(y+change, min,max)
	change_view("[x]x[y]")

/client/proc/change_view(new_size) //yes, this does work!
	if (isnull(new_size))
		CRASH("change_view called without argument.")

//CIT CHANGES START HERE - makes change_view change DEFAULT_VIEW to 15x15 depending on preferences
//	if(prefs && CONFIG_GET(string/default_view))
//		if(!prefs.widescreenpref && new_size == CONFIG_GET(string/default_view))
	if(!new_size)
		new_size = "15x15"
//END OF CIT CHANGES

	//var/list/old_view = getviewsize(view)
	view = new_size
	var/list/actualview = getviewsize(view)
	apply_clickcatcher(actualview)
	mob.reload_fullscreen()
	//if (isliving(mob))
	//	var/mob/living/M = mob
	//	M.update_damage_hud()
	if (prefs.auto_fit_viewport)
		fit_viewport()
	//SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_CHANGE_VIEW, src, old_view, actualview)

/client/proc/generate_clickcatcher()
	if(!void)
		void = new()
		screen += void

/client/proc/apply_clickcatcher(list/actualview)
	generate_clickcatcher()
	if(!actualview)
		actualview = getviewsize(view)
	void.UpdateGreed(actualview[1],actualview[2])

/client/proc/AnnouncePR(announcement)
	//if(prefs && prefs.chat_toggles & CHAT_PULLR)
	to_chat(src, announcement)

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

/proc/get_player_age(key)
	establish_db_connection()
	if(!dbcon.IsConnected())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/DBQuery/query = dbcon.NewQuery("SELECT datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1


/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = -1	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	account_join_date = sanitizeSQL(findJoinDate())
	if(account_join_date && dbcon.IsConnected())
		var/DBQuery/query_datediff = dbcon.NewQuery("SELECT DATEDIFF(Now(),'[account_join_date]')")
		if(query_datediff.Execute() && query_datediff.NextRow())
			account_age = text2num(query_datediff.item[1])

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
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

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	//Panic bunker code
	if ((player_age == -1) && !(ckey in GLOB.bunker_passthrough)) //first connection
		if (config_legacy.panic_bunker && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, config_legacy.panic_bunker_message)
			qdel(src)
			return 0
	if(player_age == -1)
		player_age = 0		//math requires this to not be -1.

	// VOREStation Edit Start - Department Hours
	if(config_legacy.time_off)
		var/DBQuery/query_hours = dbcon.NewQuery("SELECT department, hours FROM vr_player_hours WHERE ckey = '[sql_ckey]'")
		query_hours.Execute()
		while(query_hours.NextRow())
			LAZYINITLIST(department_hours)
			department_hours[query_hours.item[1]] = text2num(query_hours.item[2])
	// VOREStation Edit End - Department Hours

	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
	else
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `erro_connection_log`(`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()




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

/client/proc/last_activity_seconds()
	return inactivity / 10

/mob/proc/MayRespawn()
	return FALSE

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return FALSE

/client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences"
	if(prefs)
		prefs.ShowChoices(usr)

/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")
