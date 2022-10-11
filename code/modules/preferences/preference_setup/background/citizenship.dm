/datum/category_item/player_setup_item/background/citizenship
	save_key = CHARACTER_DATA_CITIZENSHIP
	sort_order = 3

/datum/category_item/player_setup_item/background/citizenship/content(datum/preferences/prefs, mob/user, data)
	. = list()

/datum/category_item/player_setup_item/background/citizenship/act(datum/preferences/prefs, mob/user, action, list/params)
	. = ..()
	if(.)
		return

/datum/category_item/player_setup_item/background/citizenship/filter(datum/preferences/prefs, data, list/errors)

/datum/category_item/player_setup_item/background/citizenship/copy_to_mob(mob/M, data, flags)

/datum/category_item/player_setup_item/background/citizenship/spawn_checks(datum/preferences/prefs, data, flags, list/errors)

/datum/category_item/player_setup_item/background/citizenship/default_value(randomizing)

#warn impl above
