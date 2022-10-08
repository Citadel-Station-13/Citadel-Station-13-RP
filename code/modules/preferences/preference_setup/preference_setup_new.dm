//! right now these are just called via snowflake
//! please use these for new datums; in the future we'll standardize to this and decide
//! how to handle UI.
//! in the future, these are going to be singletons.
/datum/category_item/player_setup_item
	/// primary data key
	// todo: unit test for this to exist
	var/const/save_key		// genuinely you have zero reason to change this at runtime
	/// globally saved, or character-slot saved?
	var/const/is_global		// genuinely you have zero reason to change this at runtime

/**
 * called to apply to mob
 *
 * prefs are not provided because you shouldn't be filtering at this point!
 *
 * @params
 * - M - the mob in question
 * - data - our save data
 * - flags - PREF_COPY_TO_ flags
 */
/datum/category_item/player_setup_item/proc/copy_to_mob(mob/M, data, flags)
	return

// todo: apply to global/client
// todo: update to global/client

/**
 * called to check for errors; if non null, players get showed this while spawning and the
 * spawn is blocked.
 */
/datum/category_item/player_setup_item/proc/spawn_checks(datum/preferences/prefs, data, flags)
	return

#warn hook spawn_checks in spawning

/**
 * called to sanitize our value.
 *
 * called after deserialization.
 */
/datum/category_item/player_setup_item/proc/filter(datum/preferences/prefs, data)
	return data

/**
 * called to serialize our value for saving
 *
 * @return raw data to save
 */
/datum/category_item/player_setup_item/proc/serialize_data(datum/preferences/prefs, data)
	return data

/**
 * called to deserialize our value during loading
 *
 * migrations are obviously allowed
 *
 * @return deserialized data to set on preferences data lists
 */
/datum/category_item/player_setup_item/proc/deserialize_data(datum/preferences/prefs, raw)
	return raw

/**
 * write data
 */
/datum/category_item/player_setup_item/proc/write(datum/preferences/prefs, data)
	#warn impl

/**
 * read data
 */
/datum/category_item/player_setup_item/proc/read(datum/preferences/prefs)
	#warn impl

/**
 * get default value
 */
/datum/category_item/player_setup_item/proc/default_value(randomizing)
	return null

/**
 * get default value assuming pref
 */
/datum/category_item/player_setup_item/proc/informed_default_value(randomizing)
	return default_value(randomizing)
