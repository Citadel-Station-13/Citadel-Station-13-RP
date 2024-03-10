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
	//* Loading *//
	/// loaded?
	var/initialized = FALSE

	//* Preferences *//
	/// preferences by key - key = value
	var/list/entries_by_key
	/// arbitrary key access used by middleware
	var/list/misc_by_key
	// todo: move menu options in here and not from /datum/preferences

	//* Middleware - Keybindings *//
	/// keybindings - key to list of keys
	var/list/keybindings

	//* Middleware - Toggles *//
	/// toggles by key - TRUE or FALSE
	var/list/toggles_by_key

	//* System *//
	/// were we originally sql loaded?
	/// used to determine if sql is authoritative when sql comes back
	///
	/// - if sql was originally loaded and sql comes back, we are still authoritative
	/// - if sql wasn't originally loaded and sql comes back and a sql save exists, we are overwritten
	/// - if a save doesn't exist, we are authoritative and are flushed to sql
	var/authoritatively_loaded_by_sql = FALSE
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
	var/version = GAME_PREFERENCES_VERSION_CURRENT

/datum/game_preferences/New(ckey)
	src.ckey = ckey

//* Init *//

/datum/game_preferences/proc/initialize()
	perform_initial_load()
	initialized = TRUE

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
	// load from sql if we can; SQL is authoritative
	if(load_from_sql())
		return
	// otherwise, save our current changes to SQL
	save_to_sql()

/datum/game_preferences/proc/perform_legacy_migration()
	var/savefile/legacy_savefile = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/preferences.sav")
	var/list/legacy_options
	legacy_savefile["global"] >> legacy_options
	if(isnull(legacy_options))
		legacy_options = list()

	// we are fired after reset, but before save
	// we assume lists are init'd
	for(var/key in GLOB.game_preference_entries)
		var/datum/game_preference_entry/entry = GLOB.game_preference_entries[key]
		var/migrated_value
		if(entry.legacy_global_key)
			migrated_value = legacy_options[entry.legacy_global_key]
		else if(entry.legacy_savefile_key)
			legacy_savefile[entry.legacy_savefile_key] >> migrated_value
		if(!isnull(migrated_value))
			migrated_value = entry.filter_value(active, migrated_value)
			entries_by_key[key] = migrated_value

	var/list/old_toggles
	legacy_savefile["preferences"] >> old_toggles

	for(var/key in GLOB.game_preference_toggles)
		var/datum/game_preference_toggle/toggle = GLOB.game_preference_toggles[key]
		if(!toggle.legacy_key)
			continue
		toggles_by_key[key] = !!old_toggles[toggle.legacy_key]

/datum/game_preferences/proc/perform_initial_load()
	if(SSdbcore.IsConnected())
		// sql mode
		// load
		if(!load_from_sql())
			// if not, load from file
			if(!load_from_file())
				// if not, reset to defaults
				full_reset()
				// perform legacy migration to see if there's data
				if(perform_legacy_migration())
					// something was there, set our version to legacy
					version = GAME_PREFERENCES_VERSION_LEGACY
			// save results to sql, as sql is authoritative
			save_to_sql()
		else
			// synchronize sql to file for backup for when sql is down
			save_to_file()
	else
		// normal mode
		// load
		if(!load_from_file())
			// if not, reset to defaults
			full_reset()
			// perform legacy migration to see if there's data
			if(perform_legacy_migration())
				// something was there, set our version to legacy
				version = GAME_PREFERENCES_VERSION_LEGACY
			// save to file
			save_to_file()

	// do we need to migrate?
	if(version < GAME_PREFERENCES_VERSION_CURRENT)
		// yes
		if(!perform_migration_sequence())
			// reset to defaults if failed
			full_reset()
		// perform save
		if(SSdbcore.IsConnected())
			save_to_sql()
		else
			save_to_file()

	// todo: shouldn't we save after sanitize..?
	sanitize_everything()

/**
 * @return FALSE if failed
 */
/datum/game_preferences/proc/perform_migration_sequence()
	if(version <= GAME_PREFERENCES_VERSION_DROP)
		return FALSE
	perform_migrations(version)
	version = GAME_PREFERENCES_VERSION_CURRENT

/datum/game_preferences/proc/perform_migrations(from_version)
	PRIVATE_PROC(TRUE)

//* Reset *//

/datum/game_preferences/proc/reset(category)
	#warn impl

/datum/game_preferences/proc/full_reset()
	// reset normal categories
	reset()
	// reset middleware
	for(var/id in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
		middleware.handle_reset(src)

//* Set / Get *//

/datum/game_preferences/proc/set_toggle(datum/game_preference_toggle/id_path_instance, value)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	// we don't check is visible, as it's checked on 'get'
	// if(!toggle.is_visible(active))
	// 	return FALSE
	toggles_by_key[toggle.key] = value
	if(active)
		toggle.toggled(active, value)
	return TRUE

/datum/game_preferences/proc/toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	// we don't check is visible, as it's checked on 'get'
	// if(!toggle.is_visible(active))
	// 	return FALSE
	toggles_by_key[toggle.key] = !toggles_by_key[toggle.key]
	if(active)
		toggle.toggled(active, toggles_by_key[toggle.key])
	return TRUE

/datum/game_preferences/proc/get_toggle(datum/game_preference_toggle/id_path_instance)
	var/datum/game_preference_toggle/toggle = fetch_game_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return toggle.default_value
	if(!toggle.is_visible(active))
		return toggle.default_value
	return toggles_by_key[toggle.key]

/datum/game_preferences/proc/set_entry(datum/game_preference_entry/id_path_instance, value)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	if(!entry.is_visible(active))
		return FALSE
	value = entry.filter_value(active, value)
	entries_by_key[entry.key] = value
	if(active)
		entry.on_set(active, value, FALSE)
	return TRUE

/datum/game_preferences/proc/get_entry(datum/game_preference_entry/id_path_instance)
	var/datum/game_preference_entry/entry = fetch_game_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!initialized)
		return entry.default_value
	if(!entry.is_visible(active))
		return entry.default_value
	return entries_by_key[entry.key]

//* Save / Load *//

/**
 * this proc does not sanitize!
 *
 * @return FALSE if we couldn't load
 */
/datum/game_preferences/proc/load_from_sql()
	var/datum/player_data/player_data = resolve_player_data(ckey)
	if(!player_data.block_on_available(10 SECONDS))
		message_admins(SPAN_BOLDANNOUNCE("failed to resolve player data during prefs op for [ckey]. ping maintainers."))
		CRASH("failed to grab player data while loading via sql. something bad has happened!")
	authoritative_player_id = player_data.player_id
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT `toggles`, `entries`, `misc`, `keybinds`, `version` FROM [format_table_name("game_preferences")] \
		WHERE `player` = :player",
		list(
			"player" = authoritative_player_id,
		),
	)
	query.warn_execute(FALSE)
	if(!query.NextRow())
		qdel(query)
		return FALSE
	var/toggles_json = query.item[1]
	var/entries_json = query.item2[]
	var/misc_json = query.items[3]
	var/keybinds_json = query.items[4]
	var/loaded_version = query.items[5]

	toggles_by_key = safe_json_decode(toggles_json)
	entries_by_key = safe_json_decode(entries_json)
	misc_by_key = safe_json_decode(misc_json)
	keybindings = safe_json_decode(keybinds_json)
	version = loaded_version

	qdel(query)
	return TRUE

/datum/game_preferences/proc/save_to_sql()
	var/datum/player_data/player_data = resolve_player_data(ckey)
	if(!player_data.block_on_available(10 SECONDS))
		message_admins(SPAN_BOLDANNOUNCE("failed to resolve player data during prefs op for [ckey]. ping maintainers."))
		CRASH("failed to grab player data while loading via sql. something bad has happened!")
	authoritative_player_id = player_data.player_id
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("game_preferences")] \
		(`player`, `toggles`, `entries`, `misc`, `keybinds`, `version`, `modified`) VALUES \
		(:player, :toggles, :entries, :misc, :keybinds, :version, Now()) ON DUPLICATE KEY UPDATE \
		`player` = VALUES(player), `toggles` = VALUES(toggles), `entries` = VALUES(entries), `misc` = VALUES(misc), \
		`keybinds` = VALUES(keybinds), `version` = VALUES(version), `modified` = Now()",
		list(
			"player" = authoritative_player_id,
			"toggles" = safe_json_encode(toggles_by_key),
			"entries" = safe_json_encode(entries_by_key),
			"misc" = safe_json_encode(misc_by_key),
			"keybinds" = safe_json_encode(keybindings),
			"version" = version,
		)
	)
	query.warn_execute(FALSE)
	qdel(query)
	return TRUE

/datum/game_preferences/proc/file_path()
	return "data/players/[copytext(ckey, 1, 2)]/[ckey]/preferences.json"

/**
 * this proc does not sanitize!
 *
 * @return FALSE if we couldn't load
 */
/datum/game_preferences/proc/load_from_file()
	var/savefile_path = file_path()

	if(!fexists(savefile_path))
		return FALSE

	var/list/deserialized = json_decode(file2text(savefile_path))

	entries_by_key = deserialized["entries"]
	toggles_by_key = deserialized["toggles"]
	keybindings = deserialized["keybindings"]
	hotkey_mode = deserialized["hotkey_mode"]
	misc_by_key = deserialized["misc"]

	return TRUE

/datum/game_preferences/proc/save_to_file()
	var/savefile_path = file_path()

	var/list/serializing = list(
		"entries" = entries_by_key,
		"toggles" = toggles_by_key,
		"keybindings" = keybindings,
		"hotkey_mode" = hotkey_mode,
		"misc" = misc_by_key,
	)

	if(fexists(savefile_path))
		fdel(savefile_path)

	text2file(json_encode(serializing), savefile_path)

	return TRUE

/datum/game_preferences/proc/sanitize_everything()
	// reset middleware
	for(var/id in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
		middleware.handle_sanitize(src)
	for(var/key in GLOB.game_preference_entries)
		var/datum/game_preference_entry/entry = GLOB.game_preference_entries[key]
		var/current_value = entries_by_key[key]
		entries_by_key[key] = entry.filter_value(current_value)

//* UI *//

/datum/game_preferences/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()
	var/list/middleware = list()
	for(var/key in GLOB.game_preference_middleware)
		middleware += key
	.["middleware"] = middleware
	var/list/entries = list()
	for(var/key in GLOB.game_preference_entries)
		var/datum/game_preference_entry/entry = GLOB.game_preference_entries[key]
		entries[++entries.len] = entry.tgui_preference_schema()
	.["entries"] = entries

/datum/game_preferences/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "GamePreferences")
		for(var/key in GLOB.game_preference_middleware)
			var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[key]
			ui.register_module(middleware, key)
		ui.open()

/datum/game_preferences/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
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
