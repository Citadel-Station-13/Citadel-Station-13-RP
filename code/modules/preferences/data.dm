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
/datum/preferences/proc/write_character_data()

/**
 * flush global data to disk
 */
/datum/preferences/proc/write_global_data()

/**
 * load character data from disk
 */
/datum/preferences/proc/read_character_data()

/**
 * load global data from disk
 */
/datum/preferences/proc/read_global_data()

#warn impl all

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
