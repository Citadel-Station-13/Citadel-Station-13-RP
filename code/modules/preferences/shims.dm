/datum/preferences
	var/list/datum/category_item/player_setup_item/preference_datums = list()
	var/list/preference_by_key = list()
	var/list/preference_by_type = list()

/datum/preferences/proc/preference_by_save_key(key)
	RETURN_TYPE(/datum/category_item/player_setup_item)
	return preference_by_key[key]

/datum/preferences/proc/preference_by_type(type)
	RETURN_TYPE(/datum/category_item/player_setup_item)
	return preference_by_type[type]
