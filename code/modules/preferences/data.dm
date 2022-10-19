/**
 * sets a character data key to a value
 */
/datum/preferences/proc/set_character_data(key, value)
	character[key] = value

/**
 * reads a character data key
 */
/datum/preferences/proc/get_character_data(key)
	return character[key]

/**
 * sets a global options data key to a value
 */
/datum/preferences/proc/set_global_data(key, value)
	options[key] = value

/**
 * reads a global options data key
 */
/datum/preferences/proc/get_global_data(key)
	return options[key]

/**
 * flush character data to disk
 */
/datum/preferences/proc/write_character_data(savefile/S, slot, list/errors)
	var/old_cd = S.cd
	S.cd = "/"
	var/list/transformed = list()
	for(var/key in character)
		var/datum/category_item/player_setup_item/I = preference_by_save_key(key)
		if(I.is_global)
			continue
		transformed[key] = I.serialize_data(src, I.filter(src, character[key], errors), errors)
	S["slot_[slot]"] << transformed
	S.cd = old_cd

/**
 * flush global data to disk
 */
/datum/preferences/proc/write_global_data(savefile/S, list/errors)
	var/old_cd = S.cd
	S.cd = "/"
	var/list/transformed = list()
	for(var/key in options)
		var/datum/category_item/player_setup_item/I = preference_by_save_key(key)
		if(!I.is_global)
			continue
		transformed[key] = I.serialize_data(src, I.filter(src, character[key], errors), errors)
	S["global"] << transformed
	S.cd = old_cd

/**
 * load character data from disk
 */
/datum/preferences/proc/read_character_data(savefile/S, slot, list/errors)
	character = list()
	var/old_cd = S.cd
	S.cd = "/"
	var/list/transformed
	S["slot_[slot]"] >> transformed
	if(!islist(transformed))
		transformed = list()
	for(var/key in transformed)
		var/datum/category_item/player_setup_item/I = preference_by_save_key(key)
		if(I.is_global)
			continue
		character[key] = I.filter(src, I.deserialize_data(src, transformed[key], errors), errors)
	S.cd = old_cd

/**
 * load global data from disk
 */
/datum/preferences/proc/read_global_data(savefile/S, list/errors)
	options = list()
	var/old_cd = S.cd
	S.cd = "/"
	var/list/transformed
	S["global"] >> transformed
	if(!islist(transformed))
		transformed = list()
	for(var/key in transformed)
		var/datum/category_item/player_setup_item/I = preference_by_save_key(key)
		if(!I.is_global)
			continue
		options[key] = I.filter(src, I.deserialize_data(src, transformed[key], errors), errors)
	S.cd = old_cd

/**
 * checked set preference data
 */
/datum/preferences/proc/set_preference_data(datum/category_item/player_setup_item/preference, value)
	value = preference.filter(value)
	if(preference.is_global)
		options[preference.save_key] = value
	else
		character[preference.save_key] = value

/**
 * checked get preference data
 */
/datum/preferences/proc/get_preference_data(datum/category_item/player_setup_item/preference)
	if(preference.is_global)
		return options[preference.save_key]
	else
		return character[preference.save_key]

/**
 * sanitize prefs data
 */
/datum/preferences/proc/sanitize_preference_data(datum/category_item/player_setup_item/preference)
	if(preference.is_global)
		return options[preference.save_key] = preference.filter(options[preference.save_key])
	else
		return character[preference.save_key] = preference.filter(character[preference.save_key])

#warn above should sanitize on sanitize_character and sanitize_global

/**
 * resanitize everything
 */
/datum/preferences/proc/sanitize_everything(list/errors)
	for(var/datum/category_group/player_setup_category/category in player_setup.categories)
		category.sanitize_data(src, errors)

/datum/preferences/proc/sanitize_character(list/errors)
	for(var/key in preference_by_key)
		var/datum/category_item/player_setup_item/I = preference_by_key[key]
		if(I.is_global)
			continue
		I.sanitize_data(src, errors)

/datum/preferences/proc/sanitize_global(list/errors)
	for(var/key in preference_by_key)
		var/datum/category_item/player_setup_item/I = preference_by_key[key]
		if(!I.is_global)
			continue
		I.sanitize_data(src, errors)

#warn impl

/**
 * json export
 */
/datum/preferences/proc/json_export_character()
	return json_encode(character)

/**
 * json import
 */
/datum/preferences/proc/json_import_character(list/json, list/errors)
	if(!islist(json))
		json = safe_json_decode(json)
	if(!islist(json))
		return FALSE
	#warn impl
	return TRUE
