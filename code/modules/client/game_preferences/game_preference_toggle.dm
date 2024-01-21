//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_toggle
	var/name = "A Toggle"
	var/description = "Someone fucked up"
	var/enabled_name = "On"
	var/disabled_name = "Off"
	/// must be unique
	var/key
	var/category = "Misc"
	/// legacy import id - set if it's using new global prefs system
	var/legacy_global_key
	/// legacy import id - set if it's using old savefile direct write
	var/legacy_savefile_key
	var/default_value = TRUE


#warn impl

#warn unit test key uniqueness
