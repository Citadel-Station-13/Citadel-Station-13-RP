SUBSYSTEM_DEF(preferences)
	name = "Preferences"
	init_order = INIT_ORDER_PREFERENCES
	subsystem_flags = SS_NO_FIRE

	var/static/list/datum/game_preferences/preferences_by_key = list()

/datum/controller/subsystem/preferences/Initialize()
	#warn impl
	return ..()

/datum/controller/subsystem/preferences/proc/resolve_preference_entry(datum/game_preference_entry/entrylike)

/datum/controller/subsystem/preferences/proc/resolve_preference_toggle(datum/game_preference_toggle/togglelike)

/datum/controller/subsystem/preferences/proc/resolve_game_preferences(ckey)
	if(!istype(preferences_by_key[ckey], /datum/game_preferences))
		var/datum/game_preferences/initializing = new(ckey)
		preferences_by_key[ckey] = initializing
		initializing.initialize()
	return preferences_by_key[ckey]

/datum/controller/subsystem/preferences/on_sql_reconnect()
	for(var/ckey in SSpreferences.preferences_by_key)
		var/datum/game_preferences/preferences = SSpreferences.preferences_by_key[ckey]
		if(!istype(preferences))
			continue
		preferences.oops_sql_came_back_perform_a_reload()
	return ..()

#warn sigh

