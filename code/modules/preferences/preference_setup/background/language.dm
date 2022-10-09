/datum/category_item/player_setup_item/background/language
	sort_order = 4
	save_key = CHARACTER_DATA_LANGUAGES

/datum/category_item/player_setup_item/background/language/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/language_ids = read(prefs)



/datum/category_item/player_setup_item/background/language/act(datum/preferences/prefs, mob/user, action, list/params)
	. = PREFERENCES_NOACTION

/datum/category_item/player_setup_item/background/language/filter(datum/preferences/prefs, data, list/errors)
	var/list/languages = data
	// for now, everyone requires galcommon

/datum/category_item/player_setup_item/background/language/copy_to_mob(mob/M, data, flags)

/datum/category_item/player_setup_item/background/language/spawn_checks(datum/preferences/prefs, data, flags, list/errors)

/datum/category_item/player_setup_item/background/language/default_value(randomizing)

#warn impl above

#warn language by id?
