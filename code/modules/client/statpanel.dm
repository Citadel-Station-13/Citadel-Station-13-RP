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
	src << browse(null, "statbrowser:byond_init")
	init_verbs()

/client/proc/statpanel_check()
	if(statpanel_ready)
		return
	to_chat(src, SPAN_USERDANGER("Statpanel failed to load, click <a href='?src=[REF(src)];statpanel=reload'>here</a> to reload the panel "))

/client/proc/statpanel_create()
	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	addtimer(CALLBACK(src, /client/proc/statpanel_check), 30 SECONDS)

/client/proc/statpanel_dispose()
	statpanel_ready = FALSE
	statpanel_tab = null
	statpanel_tabs = null
	statpanel_spell_last = null
	unlist_turf()
	src << browse(null, "statbrowser:byond_shutdown")

/client/proc/statpanel_ready()
	statpanel_tabs = list()
	statpanel_init()
	statpanel_ready = TRUE

/client/proc/statpanel_reload()
	statpanel_create()
	statpanel_init()

/client/proc/statpanel_reset()
	init_verbs()
	src << browse(null, "statbrowser:byond_clear_tabs")

/client/proc/statpanel_token(token)
	if(!token)
		src << browse(null, "statbrowser:byond_dispose_token")
		return
	src << browse(token, "statbrowser:byond_grant_token")

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
			src << browse(url_encode(tab), "statbrowser:byond_remove_tab")
			return FALSE	// removing
	else
		if(status)
			src << browse(url_encode(tab), "statbrowser:byond_add_tab")
			return FALSE	// don't add yet, this is unfortunate but we'll add one tick of update delay to let it add first

#warn kick turfs to native no seriously kick the tab TO NATIVE

/client/proc/list_turf(turf/T)
	if(statpanel_turf)
		unlist_turf()
	if(!T || !list_turf_check(T))
		return
	statpanel_turf = T
	var/list/data = list()
	for(var/atom/movable/AM as anything in T)
		var/list/got = statpanel_encode_atom(AM)
		if(!got)
			continue
		data[++data.len] = got
	src << browse("[url_encode(T.name)];[url_encode(REF(T))];[icon2html(T, src, sourceonly = TRUE)];[url_encode(json_encode(data))]", "statbrowser:byond_turf_set")

/client/proc/unlist_turf()
	if(!statpanel_turf)
		return
	src << browse(null, "statbrowser:byond_turf_unset")
	UnregisterSignal(statpanel_turf, list(
		COMSIG_ATOM_ENTERED,
		COMSIG_ATOM_EXITED,
	))
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
	src << browse("[url_encode(json_encode(got))]", "statbrowser:byond_turf_add")

/client/proc/__stat_hook_turf_exit(datum/source, atom/movable/AM)
	src << browse("[url_encode(REF(AM))]", "statbrowser:byond_turf_del")

//! external - load
/// compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs()
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
	for(var/thing in verbstoprocess)
		var/procpath/verb_to_init = thing
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		LAZYINITLIST(verblist[verb_to_init.category])
		verblist[verb_to_init.category] += verb_to_init.name
	src << output("[url_encode(json_encode(verblist))]", "statbrowser:byond_init_verbs")

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
	return (istype(D) && D?.statpanel_data(C)) || list()

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
		if("act")
			var/datum/D = locate(params["ref"])
			if(!istype(D))
				return
			// todo: admin token implementation
			D.statpanel_click(src, null, FALSE)
			return
		if("click")
			var/atom/A = locate(params["ref"])
			if(!istype(A))
				return
			// assert: it's within a *VERY* generous range
			if(get_dist(A, mob) > 5)
				return
			// todo: admin token implementation
			var/params = params["params"]
			mob.ClickOn(A, params, CLICKCHAIN_FROM_HREF)
			return
		// todo: mousedrag event

/**
 * grabs statpanel data to send on tick
 */
/client/proc/_statpanel_data()
	return statpanel_data(src)

//! verb hooks - js stat

/client/verb/hook_statpanel_ready()
	set name = ".statpanel_ready"
	set hidden = TRUE

	statpanel_ready()

/client/verb/hook_statpanel_add_tab(tab as text)
	set name = ".statpanel_tab_add"
	set hidden = TRUE

	statpanel_tabs |= tab

/client/verb/hook_statpanel_remove_tab(tab as text)
	set name = ".statpanel_tab_remove"
	set hidden = TRUE

	statpanel_tabs -= tab

/client/verb/hook_statpanel_wipe_tabs()
	set name = ".statpanel_tab_wipe"
	set hidden = TRUE

	statpanel_tabs = list()

/client/verb/hook_statpanel_set_tab(tab as text)
	set name = ".statpanel_tab"
	set hidden = TRUE

	statpanel_tab = tab

//! verb hooks - byond stat

//! verb hooks - tab switcher

#warn hook for detecting where we are so we don't unnecessarily stat
