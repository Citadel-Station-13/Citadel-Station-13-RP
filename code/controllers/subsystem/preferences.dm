SUBSYSTEM_DEF(preferences)
	name = "Preferences"
	init_order = INIT_ORDER_PREFERENCES
	init_stage = INIT_STAGE_EARLY
	subsystem_flags = SS_NO_FIRE

	var/list/datum/game_preference_entry/entries_by_key
	var/list/datum/game_preference_toggle/toggles_by_key
	var/static/list/datum/game_preferences/preferences_by_key = list()

/datum/controller/subsystem/preferences/Initialize()
	init_preference_entries()
	init_preference_toggles()
	for(var/key in preferences_by_key)
		var/datum/game_preferences/prefs = preferences_by_key[key]
		prefs.initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/preferences/proc/resolve_preference_entry(datum/game_preference_entry/entrylike)
	if(ispath(entrylike))
		entrylike = initial(entrylike.key)
		entrylike = entries_by_key[entrylike]
	else if(istype(entrylike))
	else
		entrylike = entries_by_key[entrylike]
	return entrylike

/datum/controller/subsystem/preferences/proc/resolve_preference_toggle(datum/game_preference_toggle/togglelike)
	if(ispath(togglelike))
		togglelike = initial(togglelike.key)
		togglelike = toggles_by_key[togglelike]
	else if(istype(togglelike))
	else
		togglelike = toggles_by_key[togglelike]
	return togglelike

/datum/controller/subsystem/preferences/proc/init_preference_entries()
	. = list()
	for(var/datum/game_preference_entry/casted as anything in subtypesof(/datum/game_preference_entry))
		if(initial(casted.abstract_type) == casted)
			continue
		casted = new casted
		if(!casted.key || !istext(casted.key))
			STACK_TRACE("bad key: [casted.key]")
			continue
		if(!isnull(.[casted.key]))
			STACK_TRACE("dupe key between [casted.type] and [.[casted.key]:type]")
			continue
		.[casted.key] = casted
	entries_by_key = .

/datum/controller/subsystem/preferences/proc/init_preference_toggles()
	. = list()
	for(var/datum/game_preference_toggle/casted as anything in subtypesof(/datum/game_preference_toggle))
		if(initial(casted.abstract_type) == casted)
			continue
		casted = new casted
		if(!casted.key || !istext(casted.key))
			STACK_TRACE("bad key: [casted.key]")
			continue
		if(!isnull(.[casted.key]))
			STACK_TRACE("dupe key between [casted.type] and [.[casted.key]:type]")
			continue
		.[casted.key] = casted
	toggles_by_key = .

/datum/controller/subsystem/preferences/proc/resolve_game_preferences(key, ckey)
	if(!istype(preferences_by_key[ckey], /datum/game_preferences))
		var/datum/game_preferences/initializing = new(key, ckey)
		preferences_by_key[ckey] = initializing
		if(initialized)
			initializing.initialize()
	var/datum/game_preferences/found = preferences_by_key[ckey]
	if(initialized && !found.initialized)
		found.initialize()
	return found

/datum/controller/subsystem/preferences/on_sql_reconnect()
	for(var/ckey in SSpreferences.preferences_by_key)
		var/datum/game_preferences/preferences = SSpreferences.preferences_by_key[ckey]
		if(!istype(preferences))
			continue
		preferences.oops_sql_came_back_perform_a_reload()
	return ..()
