//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/hook/client_stability_check/check_game_preferences/invoke(client/joining)
	. = TRUE
	// preferences are critical; if they can't load, kick them
	if(!joining.preferences.block_on_initialized(5 SECONDS))
		joining.disconnection_message("A fatal error occurred while attempting to load: preferences not initialized. Please notify a coder.")
		stack_trace("we just kicked a client due to prefs not loading; something is horribly wrong!")
		qdel(src)
	// it's fine to sleep
	sleep(5 SECONDS)
	// heuristically check if their keybindings are okay
	// this doesn't actually check if WASD is set but if they have less than 10
	// something probably exploded
	if(length(joining.preferences.keybindings) < 10)
		stack_trace("client detected with no keybindings in stability checks after 5 seconds; fixing this automatically")
		var/datum/game_preference_middleware/keybindings/bindings_middleware = GLOB.game_preference_middleware[/datum/game_preference_middleware/keybindings::key]
		if(!bindings_middleware)
			stack_trace("couldn't find bindings middleware?")
		else
			bindings_middleware.handle_reset(joining.preferences)
			to_chat(joining, SPAN_BOLDANNOUNCE("BUG: Your keybindings were forcefully reset due to not being detected as initialized 5 seconds after connection. Report this to a coder."))
			message_admins("[joining]'s keybindings were forcefully reset due to not being initialized 5 seconds after connection. Yell at coders.")

/**
 * Game preferences
 *
 * Game prefs don't need an init order because unlike character setup, there's no dependencies, in theory.
 *
 * todo: rework this a bit, the way i did tgui is pretty atrocious;
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
	/// keybindings - key to list of keybind ids
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
	/// we are a guest
	var/is_guest = FALSE
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
	/// are we saved? if TRUE, we have modified vars
	var/is_dirty = FALSE

/datum/game_preferences/New(key, ckey)
	src.ckey = ckey
	src.is_guest = IsGuestKey(key)

//* Init *//

/datum/game_preferences/proc/initialize()
	// do not mess with client init; start a new call chain
	spawn(0)
		perform_initial_load()
		initialized = TRUE

/datum/game_preferences/proc/on_reconnect()
	// do not mess with client init; start a new call chain
	spawn(0)
		block_on_initialized()
		initialize_client()

/datum/game_preferences/proc/block_on_initialized(timeout = 10 SECONDS)
	var/wait_until = world.time + timeout
	UNTIL(initialized || (world.time >= wait_until))
	if(!initialized)
		. = FALSE
		CRASH("block_on_initialize timeout")
	return initialized

/datum/game_preferences/proc/initialize_client()
	if(isnull(active))
		return
	for(var/key in SSpreferences.entries_by_key)
		var/datum/game_preference_entry/entry = SSpreferences.entries_by_key[key]
		var/value = entries_by_key[entry.key]
		entry.on_set(active, value, TRUE)
	for(var/key in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[key]
		middleware.on_initial_load(src)

/datum/game_preferences/proc/oops_sql_came_back_perform_a_reload()
	// if we were sql loaded, don't desync from sql
	if(authoritatively_loaded_by_sql)
		if(!sql_state_desynced)
			return
		if(active)
			to_chat(active, SPAN_BOLDANNOUNCE("The server's SQL database has reconnected and your preferences were changed during the lapse. Your preferences has been automatically flushed to database."))
		save_to_sql()
		return
	// load from sql if we can; SQL is authoritative
	if(load_from_sql())
		if(active)
			to_chat(active, SPAN_BOLDANNOUNCE("The server's SQL database has reconnected and your preferences were found to be fully desynced from the copy in the database. Your preferences has been automatically reloaded from the database. Please ensure all settings are workable."))
		return
	// otherwise, save our current changes to SQL
	save_to_sql()
	if(active)
		to_chat(active, SPAN_BOLDANNOUNCE("The server's SQL database has reconnected and your preferences were not found in them. Your preferences have been automatically saved to database."))

/datum/game_preferences/proc/perform_legacy_migration()
	if(is_guest)
		return FALSE
	if(!fexists("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/preferences.sav"))
		return FALSE
	var/savefile/legacy_savefile = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/preferences.sav")
	var/list/legacy_options
	legacy_savefile["global"] >> legacy_options
	if(isnull(legacy_options))
		legacy_options = list()

	// we are fired after reset, but before save
	// we assume lists are init'd
	for(var/key in SSpreferences.entries_by_key)
		var/datum/game_preference_entry/entry = SSpreferences.entries_by_key[key]
		var/migrated_value
		if(entry.legacy_global_key)
			migrated_value = legacy_options[entry.legacy_global_key]
		else if(entry.legacy_savefile_key)
			legacy_savefile[entry.legacy_savefile_key] >> migrated_value
		if(!isnull(migrated_value))
			migrated_value = entry.filter_value(migrated_value)
			entries_by_key[key] = migrated_value

	var/list/old_toggles
	legacy_savefile["preferences"] >> old_toggles
	if(islist(old_toggles))
		for(var/key in SSpreferences.toggles_by_key)
			var/datum/game_preference_toggle/toggle = SSpreferences.toggles_by_key[key]
			if(!toggle.legacy_key)
				continue
			toggles_by_key[key] = (toggle.legacy_key in old_toggles)

	var/list/old_keybinds
	legacy_savefile["key_bindings"] >> old_keybinds
	keybindings = sanitize_islist(old_keybinds)

	var/old_hotkeys
	legacy_savefile["hotkeys"] >> old_hotkeys
	misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = !!old_hotkeys

	return TRUE

/datum/game_preferences/proc/perform_initial_load()
	sleep(2 SECONDS)
	if(!is_guest)
		// only if not guest
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
				// synchronize sql to file for backup for when sql is down
				save_to_file()
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
	else
		// if guest, just reset lmao
		full_reset()

	// todo: shouldn't we save after sanitize..?
	sanitize_everything()
	// loaded; push initial update triggers.
	initialize_client()
	// initialized!
	initialized = TRUE

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
	if(!category)
		entries_by_key = list()
	for(var/key in SSpreferences.entries_by_key)
		var/datum/game_preference_entry/entry = SSpreferences.entries_by_key[key]
		if(category && entry.category != category)
			continue
		var/value = entry.default_value(active)
		entries_by_key[entry.key] = value
		if(!isnull(active))
			entry.on_set(active, value, TRUE)
	mark_dirty()
	push_ui_data(data = list("values" = entries_by_key))

/datum/game_preferences/proc/full_reset()
	// reset misc stuff first as everything potentially uses it
	misc_by_key = list()
	// reset normal categories
	reset()
	// reset middleware
	for(var/id in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
		middleware.handle_reset(src)

//* Set / Get *//

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/datum/game_preferences/proc/set_toggle(datum/game_preference_toggle/id_path_instance, value)
	if(!SSpreferences.initialized)
		return FALSE
	var/datum/game_preference_toggle/toggle = SSpreferences.resolve_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	toggles_by_key[toggle.key] = value
	if(active)
		toggle.toggled(active, value)
	mark_dirty()
	return TRUE

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/datum/game_preferences/proc/toggle(datum/game_preference_toggle/id_path_instance)
	if(!SSpreferences.initialized)
		return FALSE
	var/datum/game_preference_toggle/toggle = SSpreferences.resolve_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	toggles_by_key[toggle.key] = !toggles_by_key[toggle.key]
	if(active)
		toggle.toggled(active, toggles_by_key[toggle.key])
	mark_dirty()
	return TRUE

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/datum/game_preferences/proc/get_toggle(datum/game_preference_toggle/id_path_instance)
	if(ispath(id_path_instance) && !SSpreferences.initialized)
		return id_path_instance.default_value
	var/datum/game_preference_toggle/toggle = SSpreferences.resolve_preference_toggle(id_path_instance)
	if(isnull(toggle))
		CRASH("invalid fetch")
	if(!initialized)
		return toggle.default_value
	if(!toggle.is_visible(active, TRUE))
		return toggle.default_value
	return toggles_by_key[toggle.key]

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/datum/game_preferences/proc/set_entry(datum/game_preference_entry/id_path_instance, value)
	if(!SSpreferences.initialized)
		return FALSE
	var/datum/game_preference_entry/entry = SSpreferences.resolve_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!initialized)
		return FALSE
	if(!entry.is_visible(active, TRUE))
		return FALSE
	value = entry.filter_value(value)
	entries_by_key[entry.key] = value
	if(active)
		entry.on_set(active, value, FALSE)
	mark_dirty()
	push_ui_data(data = list("values" = entries_by_key))
	return TRUE

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/datum/game_preferences/proc/get_entry(datum/game_preference_entry/id_path_instance)
	if(ispath(id_path_instance) && !SSpreferences.initialized)
		return id_path_instance.default_value
	var/datum/game_preference_entry/entry = SSpreferences.resolve_preference_entry(id_path_instance)
	if(isnull(entry))
		CRASH("invalid fetch")
	if(!initialized)
		return entry.default_value(active)
	if(!entry.is_visible(active, TRUE))
		return entry.default_value(active)
	return entries_by_key[entry.key]

//* Save / Load *//

/datum/game_preferences/proc/auto_save()
	if(!is_dirty)
		return
	sanitize_everything()
	save()

/datum/game_preferences/proc/mark_dirty()
	is_dirty = TRUE
	push_ui_data(data = list("dirty" = TRUE))

/datum/game_preferences/proc/mark_saved()
	is_dirty = FALSE
	push_ui_data(data = list("dirty" = FALSE))

/datum/game_preferences/proc/save()
	if(!initialized)
		return FALSE
	if(SSdbcore.Connect())
		return save_to_sql()
	else
		return save_to_file()

/datum/game_preferences/proc/load()
	if(!initialized)
		return FALSE
	if(SSdbcore.Connect())
		. = load_from_sql()
	else
		. = load_from_file()
	sanitize_everything()
	initialize_client()

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

	var/mob/allow_admin_proccalls = usr
	usr = null

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT `toggles`, `entries`, `misc`, `keybinds`, `version` FROM [DB_PREFIX_TABLE_NAME("game_preferences")] \
		WHERE `player` = :player",
		list(
			"player" = authoritative_player_id,
		),
	)

	usr = allow_admin_proccalls

	query.warn_execute(FALSE)
	if(!query.NextRow())
		qdel(query)
		return FALSE
	var/toggles_json = query.item[1]
	var/entries_json = query.item[2]
	var/misc_json = query.item[3]
	var/keybinds_json = query.item[4]
	var/loaded_version = query.item[5]

	toggles_by_key = sanitize_islist(safe_json_decode(toggles_json))
	entries_by_key = sanitize_islist(safe_json_decode(entries_json))
	misc_by_key = sanitize_islist(safe_json_decode(misc_json))
	keybindings = sanitize_islist(safe_json_decode(keybinds_json))
	version = loaded_version

	qdel(query)

	authoritatively_loaded_by_sql = TRUE
	mark_saved()
	update_static_data()

	return TRUE

/datum/game_preferences/proc/save_to_sql()
	var/datum/player_data/player_data = resolve_player_data(ckey)
	if(!player_data.block_on_available(10 SECONDS))
		message_admins(SPAN_BOLDANNOUNCE("failed to resolve player data during prefs op for [ckey]. ping maintainers."))
		CRASH("failed to grab player data while loading via sql. something bad has happened!")
	authoritative_player_id = player_data.player_id

	var/mob/allow_admin_proccalls = usr
	usr = null

	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO [DB_PREFIX_TABLE_NAME("game_preferences")] \
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

	usr = allow_admin_proccalls

	query.warn_execute(FALSE)
	qdel(query)

	mark_saved()
	authoritatively_loaded_by_sql = TRUE
	sql_state_desynced = FALSE

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

	var/list/deserialized = safe_json_decode(file2text(savefile_path))

	entries_by_key = sanitize_islist(deserialized["entries"])
	toggles_by_key =sanitize_islist( deserialized["toggles"])
	keybindings = sanitize_islist(deserialized["keybindings"])
	misc_by_key = sanitize_islist(deserialized["misc"])

	if(authoritatively_loaded_by_sql)
		sql_state_desynced = TRUE
	mark_saved()
	update_static_data()

	return TRUE

/datum/game_preferences/proc/save_to_file()
	var/savefile_path = file_path()

	var/list/serializing = list(
		"entries" = entries_by_key,
		"toggles" = toggles_by_key,
		"keybindings" = keybindings,
		"misc" = misc_by_key,
	)

	if(fexists(savefile_path))
		fdel(savefile_path)

	text2file(safe_json_encode(serializing), savefile_path)
	mark_saved()

	if(authoritatively_loaded_by_sql)
		sql_state_desynced = TRUE

	return TRUE

/datum/game_preferences/proc/sanitize_everything()
	// reset middleware
	for(var/id in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
		middleware.handle_sanitize(src)
	for(var/key in SSpreferences.entries_by_key)
		var/datum/game_preference_entry/entry = SSpreferences.entries_by_key[key]
		var/current_value = entries_by_key[key]
		entries_by_key[key] = entry.filter_value(current_value)
	for(var/key in SSpreferences.toggles_by_key)
		var/datum/game_preference_toggle/toggle = SSpreferences.toggles_by_key[key]
		if(isnull(toggles_by_key[key]))
			toggles_by_key[key] = toggle.default_value
	// TODO: maybe don't always mark dirty?
	mark_dirty()

//* UI *//

/datum/game_preferences/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/middleware = list()
	for(var/key in GLOB.game_preference_middleware)
		var/datum/game_preference_middleware/middleware_instance = GLOB.game_preference_middleware[key]
		middleware[key] = middleware_instance.name
	.["middleware"] = middleware
	var/list/entries = list()
	for(var/key in SSpreferences.entries_by_key)
		var/datum/game_preference_entry/entry = SSpreferences.entries_by_key[key]
		if(!entry.is_visible(user?.client, TRUE))
			continue
		entries[++entries.len] = entry.tgui_preference_schema()
	.["entries"] = entries
	.["values"] = entries_by_key

// todo: when do we refactor tgui again i don't like ui_interact because i'm a snowflake who likes being different
// (real complaint: ui_interact is weird for being called from tgui as well as from external)
// (update procs should be internally called, imo, not the 'open ui' proc, it leads to)
// (confusion when people add code with side effects like shocking people on touch in it.)
/datum/game_preferences/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!initialized)
		to_chat(user, SPAN_BOLDANNOUNCE("Your preferences are still being loaded. Please wait."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "GamePreferences")
		for(var/key in GLOB.game_preference_middleware)
			var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[key]
			ui.register_module(middleware, key)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/game_preferences/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	var/datum/game_preference_middleware/middleware = GLOB.game_preference_middleware[id]
	if(middleware?.handle_topic(src, action, params))
		return TRUE

/datum/game_preferences/ui_status(mob/user, datum/ui_state/state)
	if(user.ckey == ckey)
		return UI_INTERACTIVE
	if(check_rights(C = user, rights_required = R_DEBUG))
		return UI_INTERACTIVE
	return UI_CLOSE

/datum/game_preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("set")
			var/key = params["key"]
			if(isnull(SSpreferences.entries_by_key[key]))
				return TRUE
			set_entry(key, params["value"])
			return TRUE
		if("reset")
			reset(params["category"])
			return TRUE
		if("save")
			auto_save()
			return TRUE
		if("discard")
			load()
			return TRUE

//? Client Wrappers ?//

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/client/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	if(!preferences && ispath(id_path_instance))
		return id_path_instance.default_value
	return preferences.get_toggle(id_path_instance)

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/client/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	if(!preferences && ispath(id_path_instance))
		return id_path_instance.default_value
	return preferences.get_entry(id_path_instance)

//? Mob Wrappers ?//

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/mob/proc/get_preference_toggle(datum/game_preference_toggle/id_path_instance)
	if(!client?.preferences && ispath(id_path_instance))
		return id_path_instance.default_value
	return client.preferences.get_toggle(id_path_instance)

/**
 * Please use type whenever you can, do not use IDs/instances unless absolutely necessary.
 */
/mob/proc/get_preference_entry(datum/game_preference_entry/id_path_instance)
	if(!client?.preferences && ispath(id_path_instance))
		return id_path_instance.default_value
	return client.preferences.get_entry(id_path_instance)

