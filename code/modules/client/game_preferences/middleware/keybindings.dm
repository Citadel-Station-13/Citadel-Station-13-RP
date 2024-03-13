//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_middleware/keybindings
	key = "keybindings"

/datum/game_preference_middleware/keybindings/on_initial_load(datum/game_preferences/prefs)
	prefs.active?.update_movement_keys(src)
	prefs.active?.set_macros()
	return ..()

/datum/game_preference_middleware/keybindings/handle_reset(datum/game_preferences/prefs)
	. = ..()

	// don't change their hotkey mode.. unless it was never there.
	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = \
		isnull(prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE])? TRUE : !!prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
	var/hotkey_mode = prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
	var/list/defaults = deep_copy_list(hotkey_mode? GLOB.hotkey_keybinding_list_by_key : GLOB.classic_keybinding_list_by_key)

	prefs.push_ui_modules(updates = list((key) = list(
		"keybindings" = prefs.keybindings,
		"hotkeyMode" = prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE],
	)))

/datum/game_preference_middleware/keybindings/handle_topic(datum/game_preferences/prefs, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("hotkeys")
			var/value = params["value"]
			prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = !!value
			prefs.mark_dirty()
			prefs.push_ui_modules(updates = list((key) = list(
				"hotkeyMode" = value,
			)))
			prefs.active?.set_macros()
			return TRUE
		if("addBind")
			var/keybind_id = params["keybind"]
			var/datum/keybinding/keybind = GLOB.keybindings_by_name[keybind_id]
			var/key = params["key"]
			var/alt_depressed = params["alt"]
			var/shift_depressed = params["shift"]
			var/ctrl_depressed = params["ctrl"]
			var/replacing_key = params["replaceKey"]
			if(!isnull(replacing_key))
				prefs.keybindings[replacing_key] -= keybind_id
			if(isnull(prefs.keybindings[key]))
				prefs.keybindings[key] = list()
			prefs.keybindings[key] += keybind_id
			prefs.push_ui_modules(updates = list((key) = list(
				"keybindings" = prefs.keybindings,
			)))
			prefs.active?.update_movement_keys()
			return TRUE

/datum/game_preference_middleware/keybindings/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = \
		isnull(prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE])? TRUE : !!prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
	var/list/keys_by_bind_id = list()
	for(var/key in prefs.keybindings)
		var/had_something = FALSE
		if(islist(prefs.keybindings[key]))
			var/list/keybind_ids = prefs.keybindings[key]
			if(length(keybind_ids) > MAX_COMMANDS_PER_KEY)
				keybind_ids.len = MAX_COMMANDS_PER_KEY
			for(var/bind_id in prefs.keybindings[key])
				var/datum/keybinding/found = GLOB.keybindings_by_name[bind_id]
				if(isnull(fonud))
					prefs.keybindings[key] -= bind_id
					continue
				if(isnull(keys_by_bind_id[bind_id]))
					keys_by_bind_id[bind_id] = list()
				if(length(keys_by_bind_id[bind_id]) > MAX_KEYS_PER_KEYBIND)
					prefs.keybindings[key] -= bind_id
					continue
				keys_by_bind_id[bind_id] += key
				had_something = TRUE
		if(!had_something)
			prefs.keybindings -= key

/datum/game_preference_middleware/keybindings/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()
	var/datum/game_preferences/prefs = ui.src_object
	.["keybindings"] = prefs.keybindings
	.["hotkeyMode"] = prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]

//? Preferences Helpers

/datum/game_preferences/proc/is_hotkeys_mode()
	if(!initialized)
		return TRUE
	return misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
