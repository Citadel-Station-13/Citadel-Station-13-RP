//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn global list

/datum/game_preference_entry
	var/name = "-- broken entry --"
	var/description = "A preference entry."
	/// Must be unique
	var/key
	var/category
	/// legacy import id - set if it's using new global prefs system
	var/legacy_global_key
	/// legacy import id - set if it's using old savefile direct write
	var/legacy_savefile_key
	/// default value
	var/default_value

/datum/game_preference_entry/number
	default_value = 0
	var/min_value
	var/max_value
	var/round_to_nearest

/datum/game_preference_entry/string
	default_value = ""
	var/min_length = 0
	var/max_length = 64

/datum/game_preference_entry/toggle
	default_value = TRUE
	var/enabled_name = "On"
	var/disabled_name = "Off"

/datum/game_preference_entry/dropdown
	default_value = null
	/// entries must be strings
	var/list/options = list()

/datum/game_preference_entry/dropdown/New()
	if(isnull(default_value) && length(options))
		default_value = options[1]

#warn impl

#warn unit test key uniqueness
