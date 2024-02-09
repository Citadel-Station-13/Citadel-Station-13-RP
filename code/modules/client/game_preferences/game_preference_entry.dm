//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(game_preference_entries, init_game_preference_entries())

/proc/init_game_preference_entries()
	. = list()
	var/list/category_cache = list()
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

/**
 * called when a value is changed with a client active
 */
/datum/game_preference_entry/proc/on_set(client/user, value)
	return

/**
 * called when we first load onto a client to apply the value
 * 
 * subsequent loads don't call this, we only call this on the first load of the preferences
 * the client should poll their preferences datum itself. 
 * 
 * this is just so the client init isn't blocked on prefs init, technically
 */
/datum/game_preference_entry/proc/on_first_init(client/user, value)
	return

/datum/game_preference_entry/proc/filter_value(client/user, value)
	return value

/datum/game_preference_entry/proc/migrate_legacy_data(data)
	return data

/datum/game_preference_entry/proc/tgui_preference_schema()
	return list(
		"key" = key,
		"category" = category,
		"subcategory" = subcategory,
		"name" = name,
		"desc" = description,
		"priority" = priority,
		"defaultValue" = default_value,
	)

/datum/game_preference_entry/number
	abstract_type = /datum/game_preference_entry/number
	default_value = 0
	/// optional
	var/min_value
	/// optional
	var/max_value
	/// optional
	var/round_to_nearest

/datum/game_preference/entry/number/filter_value(client/user, value)
	. = isnum(value)? clamp(value, min_value, max_value) : default_value
	if(!isnull(.))
		. = round(., round_to_nearest)

/datum/game_preference_entry/number/tgui_preference_schema()
	return ..() | list(
		"type" = "number",
		"minValue" = min_value,
		"maxValue" = max_value,
		"round_to" = round_to_nearest,
	)

/datum/game_preference_entry/string
	abstract_type = /datum/game_preference_entry/string
	default_value = ""
	/// mandatory
	var/min_length = 0
	/// mandatory
	var/max_length = 64

/datum/game_preference/entry/string/filter_value(client/user, value)
	. = "[value]"
	return copytext_char(., 1, min(length_char(.) + 1, max_length + 1))

/datum/game_preference_entry/string/tgui_preference_schema()
	return ..() | list(
		"type" = "string",
		"minLength" = min_length,
		"maxLength" = max_length,
	)

/datum/game_preference_entry/toggle
	abstract_type = /datum/game_preference_entry/toggle
	default_value = TRUE
	/// mandatory
	var/enabled_name = "On"
	/// mandatory
	var/disabled_name = "Off"

/datum/game_preference/entry/toggle/filter_value(client/user, value)
	return !!value

/datum/game_preference_entry/toggle/tgui_preference_schema()
	return ..() | list(
		"type" = "toggle",
		"enabledName" = enabled_name,
		"disabledName" = disabled_name,
	)

/datum/game_preference_entry/dropdown
	abstract_type = /datum/game_preference_entry/dropdown
	default_value = null
	/// entries must be strings
	var/list/options = list()

/datum/game_preference_entry/dropdown/New()
	if(isnull(default_value) && length(options))
		default_value = options[1]

/datum/game_preference_entry/dropdown/filter_value(client/user, value)
	return (value in options)? value : ((length(options) && options[1]) || null)

/datum/game_preference_entry/dropdown/tgui_preference_schema()
	return ..() | list(
		"type" = "dropdown",
		"options" = options,
	)

/datum/game_preference_entry/simple_color
	abstract_type = /datum/game_preference_entry/simple_color
	default_value = "#ffffff"

/datum/game_preference_entry/simple_color/filter_value(client/user, value)
	return sanitize_hexcolor(value, desired_format = 6, default = default_value)

/datum/game_preference_entry/simple_color/tgui_preference_schema()
	return ..() | list(
		"type" = "simpleColor",
	)

#warn impl

#warn unit test key uniqueness
