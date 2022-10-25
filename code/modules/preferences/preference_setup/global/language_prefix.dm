/datum/category_item/player_setup_item/player_global/language_prefix
	is_global = TRUE
	save_key = GLOBAL_DATA_LANGUAGE_PREFIX

/datum/category_item/player_setup_item/player_global/language_prefix/proc/valid_prefix(c)
	return length(c) == 1 && !(c in list(";", ":", ".", "!", "*", "^")) && !contains_az09(c)

/datum/category_item/player_setup_item/player_global/language_prefix/filter(datum/preferences/prefs, data, list/errors)
	var/list/prefixes = data
	prefixes = sanitize_islist(prefixes)
	for(var/c in prefixes)
		if(!valid_prefix(c))
			prefixes -= c
	if(!length(prefixes))
		return default_value()
	return prefixes

/datum/category_item/player_setup_item/player_global/language_prefix/content(datum/preferences/prefs, mob/user, data)
	var/list/prefixes = data
	. = list()
	. += "<b>Language Prefix</b><br>"
	#warn impl

/datum/category_item/player_setup_item/player_global/language_prefix/act(datum/preferences/prefs, mob/user, action, list/params)
	. = ..()

/datum/category_item/player_setup_item/player_global/language_prefix/default_value(randomizing)
	return config_legacy.language_prefixes.Copy()

/datum/preferences/proc/get_language_prefixes()
	var/list/L = get_global_data(GLOBAL_DATA_LANGUAGE_PREFIX)
	return L.Copy()

/datum/preferences/proc/get_primary_language_prefix()
	var/list/L = get_global_data(GLOBAL_DATA_LANGUAGE_PREFIX)
	return L[1]

/datum/preferences/proc/is_language_prefix(c)
	return c in get_global_data(GLOBAL_DATA_LANGUAGE_PREFIX)
