//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(game_preference_entries, init_game_preference_entries())

/proc/init_game_preference_entries()
	. = list()
	for(var/datum/game_preference_entry/casted as anything in subtypesof(/datum/game_preference_entry))
		if(initial(casted.abstract_type) == casted)
			continue
		casted = new casted
		if(!isnull(.[casted.key]))
			STACK_TRACE("dupe key between [casted.type] and [.[casted.key]:type]")
			continue
		.[casted.key] = casted

/proc/fetch_game_preference_entry(datum/game_preference_entry/entrylike)
	if(ispath(entrylike))
		entrylike = initial(entrylike.key)
	else if(istype(entrylike))
	else
		entrylike = GLOB.game_preference_entrys[entrylike]
	return entrylike

/datum/game_preference_entry
	abstract_type = /datum/game_preference_entry
	var/name = "-- broken entry --"
	var/description = "A preference entry."
	/// Must be unique
	var/key
	var/category = "Misc"
	var/subcategory = "Misc"
	/// priority - higher means it appears first. only valid within the same category.
	var/priority = 0
	/// default value
	var/default_value
	/// legacy import id - set if it's using new global prefs system
	var/legacy_global_key
	/// legacy import id - set if it's using old savefile direct write
	var/legacy_savefile_key

/datum/game_preference_entry/proc/default_value(client/user)
	return default_value

/datum/game_preference_entry/proc/is_visible(client/user)
	return TRUE

/datum/game_preference_entry/proc/on_set(client/user, value)
	return

/datum/game_preference_entry/proc/filter_value(client/user, value)
	return value

/datum/game_preference_entry/proc/migrate_legacy_data(data)
	return data

/datum/game_preference_entry/number
	default_value = 0
	var/min_value
	var/max_value
	var/round_to_nearest

/datum/game_preference/entry/number/filter_value(client/user, value)
	. = isnum(value)? clamp(value, min_value, max_value) : default_value
	if(!isnull(.))
		. = round(., round_to_nearest)

/datum/game_preference_entry/string
	default_value = ""
	var/min_length = 0
	var/max_length = 64

/datum/game_preference/entry/string/filter_value(client/user, value)
	. = "[value]"
	return copytext_char(., 1, min(length_char(.) + 1, max_length + 1))

/datum/game_preference_entry/toggle
	default_value = TRUE
	var/enabled_name = "On"
	var/disabled_name = "Off"

/datum/game_preference/entry/toggle/filter_value(client/user, value)
	return !!value

/datum/game_preference_entry/dropdown
	default_value = null
	/// entries must be strings
	var/list/options = list()

/datum/game_preference_entry/dropdown/New()
	if(isnull(default_value) && length(options))
		default_value = options[1]

/datum/game_preference_entry/dropdown/filter_value(client/user, value)
	return (value in options)? value : ((length(options) && options[1]) || null)

#warn impl

#warn unit test key uniqueness
