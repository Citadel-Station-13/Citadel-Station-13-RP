//! external - state

/client/proc/statpanel_init()
	src << browse(null, "statbrowser:byond_init")
	#warn send initial data

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
	unlist_turf()
	src << browse(null, "statbrowser:byond_shutdown")
	#warn impl shutdown

/client/proc/statpanel_ready()
	statpanel_tabs = list()
	statpanel_init()
	statpanel_ready = TRUE

/client/proc/statpanel_reload()
	statpanel_create()
	statpanel_init()

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
	. = (statpanel_tab == tab) && (tab in statpanel_tabs)
	if(isnull(status))
		return
	if(tab in statpanel_tabs)
		if(!status)
			src << browse(url_encode(tab), "statbrowser:byond_remove_tab")
	else
		if(status)
			src << browse(url_encode(tab), "statbrowser:byond_add_tab")

/client/proc/list_turf(turf/T)
	if(statpanel_turf)
		unlist_turf()
	if(!T)
		return
	statpanel_turf = T
	#warn icon
	var/list/data = list()
	for(var/atom/movable/AM as anything in T)
		var/list/got = statpanel_encode_atom(AM)
		if(!got)
			continue
		data[++data.len] = got
	src << browse("[url_encode(T.name)];[];[url_encode(REF(T))];[url_encode(json_encode(data))]", "statbrowser:byond_turf_set")

/client/proc/unlist_turf()
	if(!statpanel_turf)
		return
	src << browse(null, "statbrowser:byond_turf_unset")
	UnregisterSignal(statpanel_turf, list(
		COMSIG_ATOM_ENTERED,
		COMSIG_ATOM_EXITED,
	))
	statpanel_turf = null

/**
 * must return list(name, icon, ref).
 */
/client/proc/statpanel_encode_atom(AM)
	RETURN_TYPE(/list)
	#warn look at subsystem

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
	if(IsAdminAdvancedProcCall())
		return
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/AM in mob.contents)
			var/atom/movable/thing = AM
			verbstoprocess += thing.verbs
	panel_tabs.Cut() // panel_tabs get reset in init_verbs on JS side anyway
	for(var/thing in verbstoprocess)
		var/procpath/verb_to_init = thing
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src << output("[url_encode(json_encode(panel_tabs))];[url_encode(json_encode(verblist))]", "statbrowser:init_verbs")

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
	return statobj?.statpanel_data(C) || list()

/**
 * acts on a statpanel action / press
 */
/datum/proc/statpanel_click(client/C)

/**
 * routes actions from statpanel
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
			if(istype(D))
				D.statpanel_click(src)
			return

/**
 * grabs statpanel data to send on tick
 */
/client/proc/_statpanel_data()
	return statpanel_data(src)

//! verb hooks

/client/verb/hook_statpanel_ready()
	set name = ".statpanel_ready"
	set hidden = TRUE

	statpanel_ready()

/client/verb/hook_statpanel_add_tab(tab as text)
	set name = ".statpanel_tab_add"
	set hidden = TRUE

	statpanel_tabs += tab

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
