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
	// todo: move menu options in here and not from /datum/preferences

	//* Handled by middleware-like entries *//
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
	/// our active client
	var/client/active
	/// our player's id
	///
	/// set upon successful sql save
	/// we will try to load a sql preferences of a given playerid
	/// when we load from sql
	var/authoritative_player_id
	/// our prefs version
	var/version

/datum/game_preferences/New(ckey)
	src.ckey = ckey

//* Init *//

/datum/game_preferences/proc/initialize()
	#warn impl

/datum/game_preferences/proc/block_on_initialized(timeout = 10 SECONDS)
	var/wait_until = world.time + timeout
	UNTIL(initialized || (world.time >= wait_until))
	if(!initialized)
		. = FALSE
		CRASH("block_on_initialize timeout")
	return initialized

/datum/game_preferences/proc/on_initial_load()
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
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return toggle.default_value
	if(!toggle.is_visible(GLOB.directory[ckey]))
		return toggle.default_value
	return toggles_by_key[toggle.key]

/datum/game_preferences/proc/set_entry(datum/game_preference_entry/id_path_instance, value)
	#warn impl

/datum/game_preferences/proc/get_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return entry.default_value
	if(!entry.is_visible(GLOB.directory[ckey]))
		return entry.default_value
	return entries_by_key[entry.key]

//* Save / Load *//

/**
 * @return FALSE if we couldn't load
 */
/datum/game_preferences/proc/load_from_sql()

/datum/game_preferences/proc/save_to_sql()

/**
 * @return FALSE if we couldn't load
 */
/datum/game_preferences/proc/load_from_file()

/datum/game_preferences/proc/save_to_file()
	var/savefile_path = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/game_preferences.sav"
	
	

#warn impl

//* UI *//

/datum/game_preferences/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()

/datum/game_preferences/ui_data(mob/user, datum/tgui/ui, is_module)
	. = ..()

/datum/game_preferences/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/game_preferences/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	#warn impl

/datum/game_preferences/ui_status(mob/user, datum/ui_state/state)
	if(user.ckey == ckey)
		return UI_INTERACTIVE
	if(check_rights(C = user, rights_required = R_DEBUG))
		return UI_INTERACTIVE
	return UI_CLOSE

/datum/game_preferences/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

#warn impl

//? Client Wrappers ?//

/client/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized || !preferences.initialized)
		return toggle.default_value
	if(!toggle.is_visible(src))
		return toggle.default_value
	return preferences.toggles_by_key[toggle.key]

/client/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!initialized)
		return entry.default_value
	if(!entry.is_visible(src))
		return entry.default_value
	return preferences.entries_by_key[entry.key]

//? Mob Wrappers ?//

/mob/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!client?.initialized || !client.preferences.initialized)
		return toggle.default_value
	if(!toggle.is_visible(client))
		return toggle.default_value
	return client.preferences.toggles_by_key[toggle.key]

/mob/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!client?.initialized || !client.preferences.initialized)
		return entry.default_value
	if(!entry.is_visible(client))
		return entry.default_value
	return client.preferences.entries_by_key[entry.key]
