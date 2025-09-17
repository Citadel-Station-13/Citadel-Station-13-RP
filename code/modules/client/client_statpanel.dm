/**
 * citadel RP stat system
 *
 * we use a hybrid approach
 * most stat goes to the statpanel, which is default for users;
 * this is a browser system that uses .js and is relatively fast for serialization/whatnot
 * the listed turf, however, gets sent to native Stat() so it supports native mouse
 * handling among other things.
 *
 * todo: use /datum/tgui_window, have a JS bootstrap instead of the current system.
 */
/datum/client_statpanel
	var/client/client
	var/window_id
	// var/datum/tgui_window/window

	//* Browser Stat *//
	/// is the statpanel ready?
	var/ready = FALSE
	/// current tab
	var/current_tab
	/// currently loaded tabs
	var/list/current_tabs
	/// i don't know what this does
	var/list/spell_last

	//* BYOND Stat *//
	/// the turf being listed on byond stat
	var/turf/byond_stat_turf
	/// are we currently tabbed to byond stat?
	var/byond_stat_active = FALSE
	/// did we get autoswitched to byond stat when the player alt clicked?
	/// determines if we switch back when the turf is no longer listed.
	var/byond_stat_ephemeral = FALSE

/datum/client_statpanel/New(client/client, window_id)
	src.client = client
	src.window_id = window_id
	// src.window = new(client, window_id)
	// src.window.subscribe(src, PROC_REF(on_message))

/datum/client_statpanel/Destroy()
	client << output(null, "statbrowser:byond_cleanup")
	client = null
	return ..()

/datum/client_statpanel/proc/initialize()
	if(!client.initialized)
		// todo: this should be a timer, but current MC doesn't really support that until we have
		//       MC init stages
		spawn(1 SECONDS)
			UNTIL(!client || client.initialized)
			if(!client)
				return
			boot()
	else
		spawn(0)
			boot()

/datum/client_statpanel/proc/boot()
	PRIVATE_PROC(TRUE)
	// loads statbrowser if it isn't there
	client << browse(file('html/statbrowser.html'), "window=[window_id]")
	// if it is there and we can't tell because byond is byond, send it a signal to reload
	client << output(null, "statbrowser:byond_reconnect")
	// check for it incase it breaks
	addtimer(CALLBACK(src, PROC_REF(check_initialized)), 5 SECONDS)

/datum/client_statpanel/proc/check_initialized()
	if(ready)
		return
	to_chat(client, SPAN_USERDANGER("Statpanel failed to load, click <a href='?src=[REF(src)];statpanel=reload'>here</a> to reload the panel "))

//* Internal API *//

/**
 * Resends the client's current verbs.
 *
 * @params
 * * reset - if TRUE, we will obliterate all current tabs and entirely redraw the browser. Otherwise, we
 *           only change mutated verbs.
 */
/datum/client_statpanel/proc/init_verbs(reset = FALSE)
	PRIVATE_PROC(TRUE)
	var/list/verblist = list()
	var/list/verbstoprocess = client.verbs.Copy()
	if(client.mob)
		verbstoprocess += client.mob.verbs
		for(var/atom/movable/AM as anything in client.mob)
			verbstoprocess += AM.verbs
	for(var/thing in verbstoprocess)
		var/procpath/verb_to_init = thing
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category) || !verb_to_init.name)
			continue
		if(verb_to_init.name[1] == ".")
			continue
		LAZYINITLIST(verblist[verb_to_init.category])
		verblist[verb_to_init.category] |= verb_to_init.name
	client << output("[url_encode(json_encode(verblist))];[reset]", "statbrowser:byond_init_verbs")

//* External API *//

/datum/client_statpanel/proc/request_verb_update(reset)
	if(!ready)
		return
	init_verbs(reset)

/**
 * resets state and reloads everything
 */
/datum/client_statpanel/proc/request_reload()
	current_tabs = list()
	current_tab = null
	spell_last = list()
	request_verb_update(TRUE)

/**
 * called to set/dispose admin token
 */
/datum/client_statpanel/proc/set_admin_token(token)
	if(!token)
		client << output(null, "statbrowser:byond_dispose_token")
		return
	client << output(token, "statbrowser:byond_grant_token")

/**
 * sent from a client verb called by statbrowser when it's ready
 */
/datum/client_statpanel/proc/ready_received()
	ready = TRUE
	client << output(null, "statbrowser:byond_init")
	request_reload()

//! verb hooks - js stat
//  todo: replace with tgui window messaging

/client/verb/hook_statpanel_ready()
	set name = ".statpanel_ready"
	set hidden = TRUE
	set instant = TRUE

	tgui_stat.ready_received()

/client/verb/hook_statpanel_add_tab(tab as text)
	set name = ".statpanel_tab_add"
	set hidden = TRUE
	set instant = TRUE

	if(length(tgui_stat.current_tabs) > 50)
		return // bail
	tgui_stat.current_tabs |= tab
	if(!tgui_stat.current_tab)
		tgui_stat.current_tab = tgui_stat.current_tabs[1]

/client/verb/hook_statpanel_remove_tab(tab as text)
	set name = ".statpanel_tab_remove"
	set hidden = TRUE
	set instant = TRUE

	tgui_stat.current_tabs -= tab

/client/verb/hook_statpanel_wipe_tabs()
	set name = ".statpanel_tab_reset"
	set hidden = TRUE
	set instant = TRUE

	tgui_stat.current_tabs = list()

/client/verb/hook_statpanel_set_tab(tab as text)
	set name = ".statpanel_tab"
	set hidden = TRUE
	set instant = TRUE

	tgui_stat.current_tab = tab

/**
 * This cleanly and gracefully attempts to go to a specific tab via verbs, for the hyperspecific purpose of interacting with the statpanel from other HTML UI
 */
/client/verb/hook_statpanel_goto_tab(tab as text)
	set name = ".statpanel_goto_tab"
	set hidden = TRUE
	set instant = TRUE
	src << output(tab, "statbrowser:change_tab")

//* verb hooks - tab switcher *//

/client/verb/hook_statswitcher_set_tab(tab as text)
	set name = ".statswitcher"
	set hidden = TRUE
	set instant = TRUE

	tgui_stat.byond_stat_active = (tab == "stat_pane_byond")

// todo: legacy stuff below

/// for legacy shit like rigsuits that didn't get the hint about not using verbs
/client/proc/queue_legacy_verb_update()
	if(HAS_TRAIT(src, "VERB_UPDATE_QUEUED"))
		return
	ADD_TRAIT(src, "VERB_UPDATE_QUEUED", "FUCK")
	addtimer(CALLBACK(src, PROC_REF(legacy_verb_update)), 1 SECONDS)

/// -_-
/client/proc/legacy_verb_update()
	REMOVE_TRAIT(src, "VERB_UPDATE_QUEUED", "FUCK")
	tgui_stat?.request_verb_update()

/**
 * returns TRUE if the tab should exist and we are on the tab
 *
 * @params
 * - status: use to set if the panel should exist
 */
/client/proc/statpanel_tab(tab, status)
	. = (tgui_stat.current_tab == tab)
	if(isnull(status))
		return
	if(tab in tgui_stat.current_tabs)
		if(!status)
			src << output(url_encode(tab), "statbrowser:byond_remove_tab")
			return FALSE	// removing
	else
		if(status)
			src << output(url_encode(tab), "statbrowser:byond_add_tab")
			return FALSE	// don't add yet, this is unfortunate but we'll add one tick of update delay to let it add first

/client/proc/list_turf(turf/T)
	if(tgui_stat.byond_stat_turf)
		unlist_turf()
	if(!T || !list_turf_check(T))
		return
	tgui_stat.byond_stat_turf = T
	// using byond atm
	if(!tgui_stat.byond_stat_active)
		tgui_stat.byond_stat_ephemeral = TRUE
		tgui_stat.byond_stat_active = TRUE
		winset(src, SKIN_TAB_ID_STAT, "current-tab=[SKIN_PANE_ID_BYONDSTAT]")


/client/proc/unlist_turf()
	// using byond atm
	if(tgui_stat.byond_stat_ephemeral)
		tgui_stat.byond_stat_ephemeral = FALSE
		tgui_stat.byond_stat_active = FALSE
		winset(src, SKIN_TAB_ID_STAT, "current-tab=[SKIN_PANE_ID_BROWSERSTAT]")

	tgui_stat.byond_stat_turf = null

/client/proc/list_turf_check(turf/T)
	return mob.snowflake_ai_vision_adjacency(T)

/**
 * must return list(name, icon, ref).
 */
/client/proc/statpanel_encode_atom(atom/movable/AM)
	RETURN_TYPE(/list)
	if(AM.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
		return
	if(AM.invisibility > mob.see_invisible)
		return
	return list(
		"[AM.name]",
		REF(AM),
		ismob(AM) ||(length(AM.overlays) > 2)? costly_icon2html(AM, src, sourceonly = TRUE) : icon2html(AM, src, sourceonly = TRUE)
	)

/client/proc/__stat_hook_turf_enter(datum/source, atom/movable/AM)
	var/list/got = statpanel_encode_atom(AM)
	if(!got)
		return
	src << output("[url_encode(json_encode(got))]", "statbrowser:byond_turf_add")

/client/proc/__stat_hook_turf_exit(datum/source, atom/movable/AM)
	src << output("[url_encode(REF(AM))]", "statbrowser:byond_turf_del")

/**
 * the big, bad, Citadel Station in house stat proc.
 * returns a list of "panel name" : list(entry, ...)
 * where entry is either:
 * 1. a text string
 * 2. a text string associated to a value
 */
/datum/proc/statpanel_data(client/C)
	return list()

/client/statpanel_data(client/C)
	var/datum/D = statobj
	return istype(D)? D.statpanel_data(C) : list()

/**
 * acts on a statpanel action / press
 *
 * @params
 * * C - who pressed us
 * * action - (optional) action; in some cases there is none.
 * * auth - successful admin authentication. obviously, non admins will always fail this.
 */
/datum/proc/statpanel_click(client/C, action, auth)
	return

/**
 * routes actions from statpanel
 *
 * todo: do we move this to /datum/statpanel?
 */
/client/proc/_statpanel_act(action, list/params)
	switch(action)
		if("reload")
			tgui_stat.request_reload()
			return
		if("ready")
			tgui_stat.ready_received()
			return
		if("stat_click")
			var/datum/D = locate(params["ref"])
			if(!istype(D))
				return
			// todo: admin token implementation
			D.statpanel_click(src, null, FALSE)
			return
		if("atom_click")
			var/atom/A = locate(params["ref"])
			if(!istype(A))
				return
			// assert: it's within a *VERY* generous range
			if(get_dist(A, mob) > 5)
				return
			// todo: admin token implementation
			var/clickparams = params["params"]
			mob.click_on(A, null, null, clickparams, CLICKCHAIN_FROM_HREF)
			return
		// todo: mousedrag event

/**
 * grabs statpanel data to send on tick
 */
/client/proc/_statpanel_data()
	. = statpanel_data(src)
	if(!islist(.))
		CRASH("[.] was not list.")
