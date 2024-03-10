//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_middleware/keybindings
	key = "keybindings"

/datum/game_preference_middleware/keybindings/on_initial_load(datum/game_preferences/prefs)
	prefs.active?.update_movement_keys(src)
	prefs.active?.set_macros()

/datum/game_preference_middleware/keybindings/handle_reset(datum/game_preferences/prefs)
	. = ..()
	#warn impl

	var/list/defaults = deep_copy_list(GLOB.hotkey_keybinding_list_by_key)
	prefs.misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE] = TRUE

/datum/game_preference_middleware/keybindings/handle_topic(datum/game_preferences/prefs, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
	#warn impl

/datum/game_preference_middleware/keybindings/handle_sanitize(datum/game_preferences/prefs)
	. = ..()
	#warn impl

/datum/game_preference_middleware/keybindings/ui_static_data(mob/user, datum/tgui/ui, is_module)
	. = ..()

/datum/game_preference_middleware/keybindings/ui_data(mob/user, datum/tgui/ui, is_module)
	. = ..()
	
//? Preferences Helpers

/datum/game_preferences/proc/is_hotkeys_mode()
	if(!initialized)
		return TRUE
	return misc_by_key[GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE]
