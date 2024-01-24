//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// key value ckey = value
GLOBAL_LIST_EMPTY(game_preferences)

/proc/resolve_game_preferences(ckey)
	if(!istype(GLOB.game_preferences[ckey]))
		var/datum/game_preferences/initializing = new(ckey)
		GLOB.game_preferences[ckey] = initializing
		initializing.initialize()
	return GLOB.game_preferences[ckey]

#warn global list + how to grab them

/world/on_sql_reconnect()
	for(var/ckey in GLOB.game_preferences)
		var/datum/game_preferences/preferences = GLOB.game_preferences[ckey]
		if(!istype(preferences))
			continue
		preferences.oops_sql_came_back_perform_a_reload()
	return ..()

/**
 * Game preferences
 *
 * Game prefs don't need an init order because unlike character setup, there's no dependencies, in theory.
 */
/datum/game_preferences
	/// loaded?
	var/initialized = FALSE
	/// toggles by key - TRUE or FALSE
	var/list/toggles_by_key
	/// preferences by key - key = value
	var/list/entries_by_key
	/// keybindings - key to list of keys
	var/list/keybindings
	/// were we originally sql loaded?
	/// used to determine if sql is authoritative when sql comes back
	///
	/// - if sql was originally loaded and sql comes back, we are still authoritative
	/// - if sql wasn't originally loaded and sql comes back and a sql save exists, we are overwritten
	/// - if a save doesn't exist, we are authoritative and are flushed to sql
	var/authoritatively_loaded_by_sql
	/// something fucky wucky happened and the next time sql comes back,
	/// we need to flush data and assert authoritativeness
	var/sql_state_desynced = FALSE
	/// our player's ckey
	var/ckey
	/// our player's id
	///
	/// set upon successful sql save
	/// we will try to load a sql preferences of a given playerid
	/// when we load from sql
	var/authoritative_player_id

/datum/game_preferences/New(ckey)
	src.ckey = ckey

//* Init *//

/datum/game_preferences/proc/initialize()
	#warn impl

/datum/game_preferences/proc/oops_sql_came_back_perform_a_reload()
	#warn fuck

/datum/game_preferences/proc/perform_legacy_migration()
	#warn FUCK

//* Reset *//

/datum/game_preferences/proc/reset(category)
	#warn impl

//* Set / Get *//

/datum/game_preferences/proc/set_toggle(datum/game_preference_toggle/id_path_instance, value)
	#warn impl

/datum/game_preferences/proc/toggle(datum/game_preference_toggle/id_path_instance)
	#warn impl

/datum/game_preferences/proc/get_toggle(datum/game_preference_toggle/id_path_instance)
	#warn impl

/datum/game_preferences/proc/set_entry(datum/game_preference_entry/id_path_instance, value)
	#warn impl

/datum/game_preferences/proc/get_entry(datum/game_preference_entry/id_path_instance)
	#warn impl

//* Save / Load *//

/datum/game_preferences/proc/load_from_sql()

/datum/game_preferences/proc/save_to_sql()

/datum/game_preferences/proc/load_from_file()

/datum/game_preferences/proc/save_to_file()

#warn impl

//* UI *//

#warn impl

//? Client Wrappers ?//

/client/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(initialized)
		return preferences.toggles[toggle.key]
	return id_path_instance.default_value

/client/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(initialized)
		return preferences.entries[entry.key]
	return id_path_instance.default_value

//? Mob Wrappers ?//

/mob/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(client?.initialized)
		return client.preferences.toggles[toggle.key]
	return id_path_instance.default_value

/mob/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(client?.initialized)
		return client.preferences.entries[entry.key]
	return id_path_instance.default_value
