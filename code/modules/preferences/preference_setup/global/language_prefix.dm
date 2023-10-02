/datum/category_item/player_setup_item/player_global/language_prefix
	name = "Language Prefix"
	is_global = TRUE
	save_key = GLOBAL_DATA_LANGUAGE_PREFIX

/datum/category_item/player_setup_item/player_global/language_prefix/proc/valid_prefix(c)
	return length(c) == 1 && !(c in list(";", ":", ".", "!", "*", "^")) && !contains_az09(c)

/datum/category_item/player_setup_item/player_global/language_prefix/filter_data(datum/preferences/prefs, data, list/errors)
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
	. += "<b>Language Keys</b><br>"
	. += "  [jointext(prefixes, "")] [href_simple(prefs, "change", "Change")] [href_simple(prefs, "reset", "Reset")]"

/datum/category_item/player_setup_item/player_global/language_prefix/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("change")
			var/char
			var/keys[0]
			do
				char = input("Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining") as null|text
				if(char)
					if(length(char) > 1)
						alert(user, "Only single characters allowed.", "Error", "Ok")
					else if(char in list(";", ":", "."))
						alert(user, "Radio character. Rejected.", "Error", "Ok")
					else if(char in list("!","*", "^"))
						alert(user, "Say character. Rejected.", "Error", "Ok")
					else if(contains_az09(char))
						alert(user, "Non-special character. Rejected.", "Error", "Ok")
					else
						keys.Add(char)
			while(char && keys.len < 3)

			if(keys.len == 3)
				write(prefs, keys)
				return PREFERENCES_REFRESH
			return PREFERENCES_HANDLED
		if("reset")
			write(prefs, config_legacy.language_prefixes.Copy())
			return PREFERENCES_REFRESH
	return ..()

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
