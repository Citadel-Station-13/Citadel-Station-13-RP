/datum/category_item/player_setup_item/background/religion
	save_key = CHARACTER_DATA_RELIGION
	sort_order = 6

/datum/category_item/player_setup_item/background/religion/content(datum/preferences/prefs, mob/user, data)
	. = list()

/datum/category_item/player_setup_item/background/religion/act(datum/preferences/prefs, mob/user, action, list/params)
	. = PREFERENCES_NOACTION

/datum/category_item/player_setup_item/background/religion/filter(datum/preferences/prefs, data, list/errors)

/datum/category_item/player_setup_item/background/religion/copy_to_mob(mob/M, data, flags)

/datum/category_item/player_setup_item/background/religion/spawn_checks(datum/preferences/prefs, data, flags, list/errors)

/datum/category_item/player_setup_item/background/religion/default_value(randomizing)

#warn impl above
