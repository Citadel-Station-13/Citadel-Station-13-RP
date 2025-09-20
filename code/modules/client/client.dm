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
	 * This line is widely considdered black fucking magic, and the fact it works is a puzzle to everyone
	 * involved, including the current engine developer, lummox
	 *
	 * If you are a future developer and the engine source is now available and you can explain why this
	 * is the way it is, please do update this comment
	 */
	parent_type = /datum
	show_verb_panel = FALSE

	//? Intrinsics
	/// did New() finish?
	var/initialized = FALSE
	/// Persistent round-by-round data holder
	var/datum/client_data/persistent
	/// Database data
	var/datum/player_data/player

	//? Connection
	/// queued client security kick
	var/queued_security_kick
	/// currently age gate blocked
	var/age_verification_open = FALSE
	/// panic bunker is still resolving
	var/panic_bunker_pending = FALSE

	//* Actions *//
	/// our action holder
	var/datum/action_holder/action_holder

	//* Context Menus *//
	/// open context menu
	var/datum/radial_menu/context_menu/context_menu

	//* HUDs *//
	/// active atom HUD providers associated to a list of ids or paths of atom huds that's providing it.
	var/list/datum/atom_hud_provider/atom_hud_providers

	//? Rendering
	/// Click catcher
	var/atom/movable/screen/click_catcher/click_catcher
	/// Parallax holder
	var/datum/parallax_holder/parallax_holder
	/// the perspective we're currently using
	var/datum/perspective/using_perspective
	/// Client global planes
	var/datum/plane_holder/client_global/global_planes

	//? Viewport
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
	var/viewport_rwlock = TRUE	//? default block so we can release it during init_viewport
	/// viewport update queued?
	var/viewport_queued = FALSE
	/// forced temporary view
	var/temporary_viewsize_width
	/// forced temporary view
	var/temporary_viewsize_height
	/// temporary view active?
	var/using_temporary_viewsize = FALSE

	//? Datum Menus
	/// menu button statuses
	var/list/menu_buttons_checked = list()
	/// menu group statuses
	var/list/menu_group_status = list()

	//? Preferences
	/// client preferences
	var/datum/game_preferences/preferences

	//? Throttling
	/// block re-execution of expensive verbs
	var/verb_throttle = 0

	//? Cutscenes
	/// active cutscene
	var/datum/cutscene/cutscene
	/// is the cutscene browser in use?
	var/cutscene_browser = FALSE
	/// is the cutscene system init'd?
	var/cutscene_init = FALSE
	/// is the cutscene browser ready?
	var/cutscene_ready = FALSE
	/// cutscene lockout: set after a browser synchronization command to delay the next one
	/// since byond is deranged and will send winsets and browse calls out of order sometimes.
	var/cutscene_lockout = FALSE

	//* UI - Client *//
	/// our tooltips system
	var/datum/tooltip/tooltips
	/// statpanel
	var/datum/client_statpanel/tgui_stat
	// todo: just have a client panel, don't make this separate
	var/datum/client_view_playtime/legacy_playtime_viewer

	//* UI - Map *//
	/// Our action drawer
	var/datum/action_drawer/action_drawer
	/// Our actor HUD holder
	var/datum/actor_hud_holder/actor_huds

	//* Upload *//
	/// currently prompting for upload
	VAR_PRIVATE/upload_mutex = FALSE
	/// current upload prompt's max file size
	VAR_PRIVATE/upload_current_sizelimit

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
	///when the client last died as a mouse
	var/time_died_as_mouse = null

		///////////////
		//SOUND STUFF//
		///////////////
	/// world.time when ambience was played to this client, to space out ambience sounds.
	var/time_last_ambience_played = 0

		////////////
		//SECURITY//
		////////////

	var/received_irc_pm = -99999
	///IRC admin that spoke with them last.
	var/irc_admin
	var/mute_irc = 0

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////

	preload_rsc = PRELOAD_RSC

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0

	///Used for limiting the rate of topic sends by the client to avoid abuse
	var/list/topiclimiter
	///Used for limiting the rate of clicks sends by the client to avoid abuse
	var/list/clicklimiter

 	///world.time they connected
	var/connection_time
 	///world.realtime they connected
	var/connection_realtime
 	///world.timeofday they connected
	var/connection_timeofday

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
	return ..()


//* Is-rank helpers *//

/**
 * are we a guest account?
 */
/client/proc/is_guest()
	return IsGuestKey(key)

/**
 * are we localhost?
 */
/client/proc/is_localhost()
	return isnull(address) || (address in list("127.0.0.1", "::1"))

/**
 * are we any sort of staff rank?
 */
/client/proc/is_staff()
	return !isnull(holder)

//* Atom HUDs *//

/client/proc/add_atom_hud(datum/atom_hud/hud, source)
	ASSERT(istext(source))
	if(isnull(atom_hud_providers))
		atom_hud_providers = list()
	var/list/datum/atom_hud_provider/providers = hud.resolve_providers()
	for(var/datum/atom_hud_provider/provider as anything in providers)
		var/already_there = atom_hud_providers[provider]
		if(already_there)
			atom_hud_providers[provider] |= source
		else
			atom_hud_providers[provider] = list(source)
			provider.add_client(src)

/client/proc/remove_atom_hud(datum/atom_hud/hud, source)
	ASSERT(istext(source))
	if(!length(atom_hud_providers))
		return
	if(!hud)
		// remove all of source
		for(var/datum/atom_hud_provider/provider as anything in atom_hud_providers)
			if(!(source in atom_hud_providers[provider]))
				continue
			atom_hud_providers[provider] -= source
			if(!length(atom_hud_providers[provider]))
				atom_hud_providers -= provider
				provider.remove_client(src)
		return
	hud = fetch_atom_hud(hud)
	var/list/datum/atom_hud_provider/providers = hud.resolve_providers()
	for(var/datum/atom_hud_provider/provider as anything in providers)
		if(!length(atom_hud_providers[provider]))
			continue
		atom_hud_providers[provider] -= source
		if(!length(atom_hud_providers[provider]))
			atom_hud_providers -= provider
			provider.remove_client(src)

// todo: add_atom_hud_provider, remove_atom_hud_provider

/client/proc/clear_atom_hud_providers()
	for(var/datum/atom_hud_provider/provider as anything in atom_hud_providers)
		provider.remove_client(src)
	atom_hud_providers = null

//* Transfer *//

/**
 * transfers us to a mob
 *
 * **never directly set ckey on a client or mob!**
 */
/client/proc/transfer_to(mob/moving_to)
	var/mob/moving_from = mob
	return moving_from.transfer_client_to(moving_to)
