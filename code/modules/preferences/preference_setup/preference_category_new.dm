/datum/category_group/player_setup_category

/datum/category_group/player_setup_category/proc/spawn_checks(datum/preferences/prefs, flags, list/errors)
	. = TRUE
	for(var/datum/category_item/player_setup_item/preference in items)
		if(!preference.spawn_checks(prefs, prefs.get_character_data(preference.save_key), flags, errors))
			. = FALSE

// todo: multi stage random character generation
