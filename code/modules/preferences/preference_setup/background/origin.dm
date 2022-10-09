/datum/category_item/player_setup_item/background/origin
	save_key = CHARACTER_DATA_ORIGIN
	sort_order = 2

/datum/category_item/player_setup_item/background/origin/content(datum/preferences/prefs, mob/user, data)
	. = list()

/datum/category_item/player_setup_item/background/origin/act(datum/preferences/prefs, mob/user, action, list/params)
	. = PREFERENCES_NOACTION

/datum/category_item/player_setup_item/background/origin/filter(datum/preferences/prefs, data, list/errors)

/datum/category_item/player_setup_item/background/origin/copy_to_mob(mob/M, data, flags)

/datum/category_item/player_setup_item/background/origin/spawn_checks(datum/preferences/prefs, data, flags, list/errors)

/datum/category_item/player_setup_item/background/origin/default_value(randomizing)

#warn impl above
