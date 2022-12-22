//! external - state

/client/proc/statpanel_init()
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
	#warn listed turf
	src << browse(null, "statbrowser:byond_shutdown")
	#warn impl shutdown

/client/proc/statpanel_ready()
	statpanel_tabs = list()
	statpanel_init()
	statpanel_ready = TRUE

/client/proc/statpanel_reload()
	statpanel_create()
	statpanel_init()

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

/client/statpanel_data()
	return statobj?.statpanel_data(src) || list()

/client/statpanel_static()
	return statobj?.statpanel_static(src) || list()


/**
 * routes actions from statpanel
 */
/client/proc/_statpanel_act(action, list/params)
	switch(action)
		if("reload")
			statpanel_reload()
		if("ready")
			statpanel_ready()

/**
 * grabs statpanel data to send on tick
 */
/client/proc/_statpanel_data()

/**
 * grabs initial statpanel data
 */
/client/proc/_statpanel_static()

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
