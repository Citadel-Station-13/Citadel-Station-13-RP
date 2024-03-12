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

	// don't change their hotkey mode
	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = !!prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
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
			var/keybinding = params["keybind"]
			var/key = params["key"]
			var/replacing_key = params["replaceKey"]
			#warn impl

			prefs.push_ui_modules(updates = list((key) = list(
				"keybindings" = prefs.keybindings,
			)))
			prefs.active?.update_movement_keys()

/datum/game_preference_middleware/keybindings/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	#warn impl

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
