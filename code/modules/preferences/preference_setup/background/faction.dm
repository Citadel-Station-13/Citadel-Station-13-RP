/datum/category_item/player_setup_item/background/faction
	save_key = CHARACTER_DATA_FACTION
	sort_order = 5

/datum/category_item/player_setup_item/background/faction/content(datum/preferences/prefs, mob/user, data)
	. = list()

/datum/category_item/player_setup_item/background/faction/act(datum/preferences/prefs, mob/user, action, list/params)
	. = ..()
	if(.)
		return

/datum/category_item/player_setup_item/background/faction/filter(datum/preferences/prefs, data, list/errors)

/datum/category_item/player_setup_item/background/faction/copy_to_mob(mob/M, data, flags)

/datum/category_item/player_setup_item/background/faction/spawn_checks(datum/preferences/prefs, data, flags, list/errors)

/datum/category_item/player_setup_item/background/faction/default_value(randomizing)

#warn impl above
