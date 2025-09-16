//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/game_preference_middleware/keybindings
	name = "Keybindings"
	key = "keybindings"

/datum/game_preference_middleware/keybindings/on_initial_load(datum/game_preferences/prefs)
	prefs.active?.set_macros()
	prefs.active?.update_movement_keys(src)
	return ..()

/datum/game_preference_middleware/keybindings/handle_reset(datum/game_preferences/prefs)
	. = ..()

	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = TRUE
	prefs.keybindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key)
	prefs.push_ui_modules(updates = list((src.key) = list(
		"bindings" = prefs.keybindings,
		"hotkeyMode" = prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE],
	)))

/datum/game_preference_middleware/keybindings/handle_topic(datum/game_preferences/prefs, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("reset")
			handle_reset(prefs)
			return TRUE
		if("hotkeys")
			var/value = params["value"]
			if(prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] == value)
				return TRUE
			prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = !!value
			prefs.mark_dirty()
			prefs.push_ui_modules(updates = list((src.key) = list(
				"hotkeyMode" = value,
			)))
			prefs.active?.set_macros()
			return TRUE
		if("addBind")
			var/keybind_id = params["keybind"]
			// key can be blank if we're only using ctrl/alt/shift!!
			var/key = params["key"]
			var/alt_depressed = params["alt"]
			var/shift_depressed = params["shift"]
			var/ctrl_depressed = params["ctrl"]
			var/is_numpad = params["numpad"]
			var/replacing_key = params["replaceKey"]
			var/adding_key = "[alt_depressed? "Alt":""][ctrl_depressed? "Ctrl":""][shift_depressed? "Shift":""][is_numpad? "Numpad":""][key]"
			if(!adding_key)
				return TRUE
			if(adding_key == replacing_key)
				return TRUE
			if(!isnull(replacing_key))
				prefs.keybindings[replacing_key] -= keybind_id
			if(isnull(prefs.keybindings[adding_key]))
				prefs.keybindings[adding_key] = list()
			if(!(keybind_id in prefs.keybindings[adding_key]))
				prefs.keybindings[adding_key] += keybind_id
			prefs.push_ui_modules(updates = list((src.key) = list(
				"bindings" = prefs.keybindings,
			)))
			prefs.active?.update_movement_keys()
			return TRUE
		if("removeBind")
			var/keybind_id = params["keybind"]
			var/key = params["key"]
			if(!key)
				return TRUE
			prefs.keybindings[key] -= keybind_id
			prefs.push_ui_modules(updates = list((src.key) = list(
				"bindings" = prefs.keybindings,
			)))
			prefs.active?.update_movement_keys()
			return TRUE

/datum/game_preference_middleware/keybindings/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = \
		isnull(prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE])? TRUE : !!prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
	var/list/keys_by_bind_id = list()
	//! legacy: get rid of known trash values
	prefs.keybindings -= "Unbound"
	//! end
	for(var/key in prefs.keybindings)
		var/had_something = FALSE
		if(islist(prefs.keybindings[key]))
			var/list/keybind_ids = prefs.keybindings[key]
			if(length(keybind_ids) > MAX_COMMANDS_PER_KEY)
				keybind_ids.len = MAX_COMMANDS_PER_KEY
			for(var/bind_id in prefs.keybindings[key])
				var/datum/keybinding/found = GLOB.keybindings_by_name[bind_id]
				if(isnull(found))
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

/datum/game_preference_middleware/keybindings/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/game_preferences/prefs = ui.src_object
	.["bindings"] = prefs.keybindings
	var/list/constructed_keybinds = list()
	for(var/key in GLOB.keybindings_by_name)
		var/datum/keybinding/keybind = GLOB.keybindings_by_name[key]
		if(!keybind.is_visible(user?.client))
			continue
		constructed_keybinds[++constructed_keybinds.len] = keybind.tgui_keybinding_data()
	.["keybinds"] = constructed_keybinds
	.["hotkeyMode"] = prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
	.["maxBinds"] = MAX_KEYS_PER_KEYBIND
	.["maxPerKey"] = MAX_COMMANDS_PER_KEY

//? Preferences Helpers

/datum/game_preferences/proc/is_hotkeys_mode()
	if(!initialized)
		return TRUE
	return misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]

//? UI Design Assertions

#if MAX_KEYS_PER_KEYBIND != 3
	#error TGUI for prefs is only designed for 3 bindings per keybind datum. Fix it if you want more.
#endif
