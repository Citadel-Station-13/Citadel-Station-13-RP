/**
 * Client datum
 *
 * A datum that is created whenever a user joins a BYOND world, one will exist for every active connected
 * player
 *
 * when they first connect, this client object is created and [/client/New] is called
 *
 * When they disconnect, this client object is deleted and [/client/Del] is called
 *
 * All client topic calls go through [/client/Topic] first, so a lot of our specialised
 * topic handling starts here
 */
/client

	/**
	 * This line makes clients parent type be a datum
	 *
	 * By default in byond if you define a proc on datums, that proc will exist on nearly every single type
	 * from icons to images to atoms to mobs to objs to turfs to areas, it won't however, appear on client
	 *
	 * instead by default they act like their own independent type so while you can do istype(icon, /datum)
	 * and have it return true, you can't do istype(client, /datum), it will always return false.
	 *
	 * This makes writing oo code hard, when you have to consider this extra special case
	 *
	 * This line prevents that, and has never appeared to cause any ill effects, while saving us an extra
	 * pain to think about
	 *
	 * This line is widely considered black fucking magic, and the fact it works is a puzzle to everyone
	 * involved, including the current engine developer, lummox
	 *
	 * If you are a future developer and the engine source is now available and you can explain why this
	 * is the way it is, please do update this comment
	 */
	parent_type = /datum
	show_verb_panel = FALSE

	//! Intrinsics
	/// did New() finish?
	var/initialized = FALSE
	/// Persistent round-by-round data holder
	var/datum/client_data/persistent
	/// Database data
	var/datum/player_data/player

	//! Rendering
	/// Click catcher
	var/atom/movable/screen/click_catcher/click_catcher
	/// Parallax holder
	var/datum/parallax_holder/parallax_holder

	//! Perspectives
	/// the perspective we're currently using
	var/datum/perspective/using_perspective

	//! Viewport
	/// what we *think* their current viewport size is in pixels
	var/assumed_viewport_spx
	/// what we *think* their current viewport size is in pixels
	var/assumed_viewport_spy
	/// what we *think* their current viewport zoom is
	var/assumed_viewport_zoom
	/// what we *think* their current viewport letterboxing setting is
	var/assumed_viewport_box
	/// current view x - for fast access
	var/current_viewport_width
	/// current view y - for fast access
	var/current_viewport_height
	/// if things are manipulating the viewport we don't want other things to touch it
	var/viewport_rwlock = TRUE	//! default block so we can release it during init_viewport
	/// viewport update queued?
	var/viewport_queued = FALSE
	/// forced temporary view
	var/temporary_viewsize_width
	/// forced temporary view
	var/temporary_viewsize_height
	/// temporary view active?
	var/using_temporary_viewsize = FALSE

	//! Datum Menus
	/// menu button statuses
	var/list/menu_buttons_checked = list()
	/// menu group statuses
	var/list/menu_group_status = list()

	//! Statpanel
	/// statpanel tab ; can be null (e.g. we're looking at verb tabs)
	var/statpanel_tab
	/// statpanel initialized
	var/statpanel_ready = FALSE
	/// turf being listed
	var/turf/statpanel_turf
	/// tabs the panel has
	var/list/statpanel_tabs
	/// statpanel variable tabs: spells / other "simple" action button frameworks
	var/list/statpanel_spell_last
	/// are we on byond stat? if so we can just skip the js one in data transmit (and vice versa)
	var/statpanel_on_byond = FALSE
	/// did we get autoswitched to byond stat for turf? if so we'll switch back when we un-list
	var/statpanel_for_turf = FALSE

	//! throttling
	/// block re-execution of expensive verbs
	var/verb_throttle = 0

		////////////////
		//ADMIN THINGS//
		////////////////
	///Contains admin info. Null if client is not an admin.
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null
	var/buildmode = 0
	///Used for admin AI interaction
	var/AI_Interact = FALSE

	///Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message = ""
	///contins a number of how many times a message identical to last_message was sent.
	var/last_message_count = 0
	///Internal counter for clients sending irc relay messages via ahelp to prevent spamming. Set to a number every time an admin reply is sent, decremented for every client send.
	var/ircreplyamount = 0

		/////////
		//OTHER//
		/////////
	// todo: rename to `preferences` & put it next to `persistent` to sate my OCD ~silicons
	///Player preferences datum for the client
	var/datum/preferences/prefs = null
	///Current area of the controlled mob
	var/area = null
	///when the client last died as a mouse
	var/time_died_as_mouse = null
	var/datum/tooltip/tooltips 	= null

	var/adminhelped = 0

		///////////////
		//SOUND STUFF//
		///////////////
	/// world.time when ambience was played to this client, to space out ambience sounds.
	var/time_last_ambience_played = 0

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	///IRC admin that spoke with them last.
	var/irc_admin
	var/mute_irc = 0
	///Do we think they're using a proxy/vpn? Only if IP Reputation checking is enabled in config.
	var/ip_reputation = 0


		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	///So admins know why it isn't working - Used to determine how old the account is - in days.
	var/player_age = "(Requires database)"
	///So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_ip = "(Requires database)"
	///So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/related_accounts_cid = "(Requires database)"
 	///Date that this account was first seen in the server
	var/account_join_date = "(Requires database)"
	///Age of byond account in days
	var/account_age = "(Requires database)"
	///Track hours of leave accured for each department.
	var/list/department_hours = list()

	preload_rsc = PRELOAD_RSC

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0

	///Used for limiting the rate of topic sends by the client to avoid abuse
	var/list/topiclimiter
	///Used for limiting the rate of clicks sends by the client to avoid abuse
	var/list/clicklimiter

	///List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	///List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	///Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

 	///world.time they connected
	var/connection_time
 	///world.realtime they connected
	var/connection_realtime
 	///world.timeofday they connected
	var/connection_timeofday

	/// If this client has been fully initialized or not
	var/fully_created = FALSE
