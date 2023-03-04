// todo: either tgui window
// or make it an inhouse lightweight datum
// probably the latter for minimal points of failure
// we need to send all init & reload/reset-on-mob-login data in one
// go, because byond does not ensure function call order
// race conditions can cause problems where verbs get removed
// after they get added by a remove-add turning into an add-remove.

/**
 * citadel RP stat system
 *
 * we use a hybrid approach
 * most stat goes to the statpanel, which is default for users;
 * this is a browser system that uses .js and is relatively fast for serialization/whatnot
 * the listed turf, however, gets sent to native Stat() so it supports native mouse
 * handling among other things.
 */
//! external - state

/client/proc/statpanel_init()
	src << output(null, "statbrowser:byond_init")
	init_verbs()

/client/proc/statpanel_check()
	if(statpanel_ready)
		return
	to_chat(src, SPAN_USERDANGER("Statpanel failed to load, click <a href='?src=[REF(src)];statpanel=reload'>here</a> to reload the panel "))

/**
 * boots statpanel up during connect
 */
/client/proc/statpanel_boot()
	// loads statbrowser if it isn't there
	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	// if it is there and we can't tell because byond is byond, send it a signal to reload
	src << output(null, "statbrowser:byond_reconnect")
	// check for it incase it breaks
	addtimer(CALLBACK(src, /client/proc/statpanel_check), 30 SECONDS)

/**
 * cleans up statpanel stuff during disconnect
 */
/client/proc/statpanel_dispose()
	statpanel_ready = FALSE
	statpanel_tab = null
	statpanel_tabs = null
	statpanel_spell_last = null
	unlist_turf()
	src << output(null, "statbrowser:byond_cleanup")

/**
 * instructs statpanel to reload
 */
/client/proc/statpanel_reload()
	// this is janky as shit tbh - init_verbs shouldn't be our reset call too.
	init_verbs(TRUE)

/**
 * only called for debug; fully reset statbrowser.
 */
/client/proc/statpanel_reset()
	statpanel_dispose()
	sleep(1)
	src << browse("RELOADING", "window=statbrowser")
	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	sleep(1)
	statpanel_boot()

/**
 * called by statbrowser when it's ready
 */
/client/proc/statpanel_ready()
	statpanel_tabs = list()
	statpanel_init()
	statpanel_ready = TRUE

/**
 * called to set/dispose admin token
 */
/client/proc/statpanel_token(token)
	if(!token)
		src << output(null, "statbrowser:byond_dispose_token")
		return
	src << output(token, "statbrowser:byond_grant_token")

/**
 * returns TRUE if the tab should exist and we are on the tab
 *
 * @params
 * - status: use to set if the panel should exist
 */
/client/proc/statpanel_tab(tab, status)
	. = (statpanel_tab == tab)
	if(isnull(status))
		return
	if(tab in statpanel_tabs)
		if(!status)
			src << output(url_encode(tab), "statbrowser:byond_remove_tab")
			return FALSE	// removing
	else
		if(status)
			src << output(url_encode(tab), "statbrowser:byond_add_tab")
			return FALSE	// don't add yet, this is unfortunate but we'll add one tick of update delay to let it add first

/client/proc/list_turf(turf/T)
	if(statpanel_turf)
		unlist_turf()
	if(!T || !list_turf_check(T))
		return
	statpanel_turf = T
	// using byond atm
	if(!statpanel_on_byond)
		statpanel_for_turf = TRUE
		statpanel_on_byond = TRUE
		winset(src, SKIN_TAB_ID_STAT, "current-tab=[SKIN_PANE_ID_BYONDSTAT]")
/* not using js
	var/list/data = list()
	for(var/atom/movable/AM as anything in T)
		var/list/got = statpanel_encode_atom(AM)
		if(!got)
			continue
		data[++data.len] = got
	src << output("[url_encode(T.name)];[url_encode(REF(T))];[icon2html(T, src, sourceonly = TRUE)];[url_encode(json_encode(data))]", "statbrowser:byond_turf_set")
*/

/client/proc/unlist_turf()
	// using byond atm
	if(statpanel_for_turf)
		statpanel_for_turf = FALSE
		statpanel_on_byond = FALSE
		winset(src, SKIN_TAB_ID_STAT, "current-tab=[SKIN_PANE_ID_BROWSERSTAT]")
/* not using js
	src << output(null, "statbrowser:byond_turf_unset")
	UnregisterSignal(statpanel_turf, list(
		COMSIG_ATOM_ENTERED,
		COMSIG_ATOM_EXITED,
	))
*/
	statpanel_turf = null

/client/proc/list_turf_check(turf/T)
	return mob.TurfAdjacent(T)

/**
 * must return list(name, icon, ref).
 */
/client/proc/statpanel_encode_atom(atom/movable/AM)
	RETURN_TYPE(/list)
	if(AM.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
		return
	if(AM.invisibility > mob.see_invisible)
		return
	// not gonna bother for now - this is to prevent alt clicking to see past override image
	// if(AM in overrides)
	// 	return
	// meanwhile this is just a shit check in a proc because it's N^2, need proper turf obscure flags.
	// if(AM.IsObscued())
	// 	return
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

//! external - load
/// for legacy shit like rigsuits that didn't get the hint about not using verbs
/client/proc/queue_legacy_verb_update()
	if(HAS_TRAIT(src, "VERB_UPDATE_QUEUED"))
		return
	ADD_TRAIT(src, "VERB_UPDATE_QUEUED", "FUCK")
	addtimer(CALLBACK(src, .proc/legacy_verb_update), 1 SECONDS)

/// -_-
/client/proc/legacy_verb_update()
	REMOVE_TRAIT(src, "VERB_UPDATE_QUEUED", "FUCK")
	init_verbs(FALSE)

/// compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs(reset = FALSE)
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/atom/movable/AM as anything in mob)
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
	pass()
	src << output("[url_encode(json_encode(verblist))];[reset]", "statbrowser:byond_init_verbs")

//! native

/client/Stat()
	if(!statpanel_on_byond)
		return
	..()	// hit mob.Stat()
	if(!statpanel("Turf"))
		return
	if(!statpanel_turf)
		stat("No turf listed ; Alt click on an adjacent turf to view contents.")
		return
	stat(statpanel_turf.name, statpanel_turf)
/*
	var/list/overrides = list()
	for(var/image/I in client.images)
		if(I.loc && I.loc.loc == listed_turf && I.override)
			overrides += I.loc
*/
	for(var/atom/movable/AM as anything in statpanel_turf)
		if(!AM.mouse_opacity)
			continue
		if(AM.invisibility > using_perspective.see_invisible)
			continue
// too expensive rn
/*
		if(overrides.len && (A in overrides))
			continue
*/
// not needed rn
/*
		if(A.IsObscured())
			continue
*/
		stat(null, AM)

//! data

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
			statpanel_reload()
			return
		if("ready")
			statpanel_ready()
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
			mob.ClickOn(A, clickparams, CLICKCHAIN_FROM_HREF)
			return
		// todo: mousedrag event

/**
 * grabs statpanel data to send on tick
 */
/client/proc/_statpanel_data()
	. = statpanel_data(src)
	if(!islist(.))
		CRASH("[.] was not list.")

//! verb hooks - js stat

/client/verb/hook_statpanel_ready()
	set name = ".statpanel_ready"
	set hidden = TRUE
	set instant = TRUE

	statpanel_ready()

/client/verb/hook_statpanel_add_tab(tab as text)
	set name = ".statpanel_tab_add"
	set hidden = TRUE
	set instant = TRUE

	if(length(statpanel_tabs) > 50)
		return // bail
	statpanel_tabs |= tab

/client/verb/hook_statpanel_remove_tab(tab as text)
	set name = ".statpanel_tab_remove"
	set hidden = TRUE
	set instant = TRUE

	statpanel_tabs -= tab

/client/verb/hook_statpanel_wipe_tabs()
	set name = ".statpanel_tab_reset"
	set hidden = TRUE
	set instant = TRUE

	statpanel_tabs = list()

/client/verb/hook_statpanel_set_tab(tab as text)
	set name = ".statpanel_tab"
	set hidden = TRUE
	set instant = TRUE

	statpanel_tab = tab

//! verb hooks - byond stat

//! verb hooks - tab switcher

/client/verb/hook_statswitcher_set_tab(tab as text)
	set name = ".statswitcher"
	set hidden = TRUE
	set instant = TRUE

	statpanel_on_byond = (tab == "stat_pane_byond")

//? Verbs - For Players

/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set category = "OOC"

	statpanel_reset()
