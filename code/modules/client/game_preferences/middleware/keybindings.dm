//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_middleware/keybindings
	key = "keybindings"

/datum/game_preference_middleware/keybindings/on_initial_load(datum/game_preferences/prefs)
	prefs.active?.update_movement_keys(src)

/datum/game_preference_middleware/keybindings/handle_reset(datum/game_preferences/prefs)
	#warn impl

	var/list/defaults = deep_copy_list(GLOB.hotkey_keybinding_list_by_key)

/datum/game_preference_middleware/keybindings/handle_topic(datum/game_preferences/prefs, action, list/params)
	#warn impl

/datum/game_preference_middleware/keybindings/handle_sanitize(datum/game_preferences/prefs)
	#warn impl
