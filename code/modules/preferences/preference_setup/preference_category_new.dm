/datum/category_group/player_setup_category

/datum/category_group/player_setup_category/proc/spawn_checks(datum/preferences/prefs, flags, list/errors, list/warnings)
	. = TRUE
	for(var/datum/category_item/player_setup_item/preference in items)
		if(!preference.spawn_checks(prefs, prefs.get_character_data(preference.save_key), flags, errors, warnings))
			. = FALSE

// todo: multi stage random character generation
// todo: categories should probably go; entries should have the ability to render as the TGUI section fully as
//       opposed to defining categories manually.
