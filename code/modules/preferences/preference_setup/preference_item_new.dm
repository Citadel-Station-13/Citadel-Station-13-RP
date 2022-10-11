//! right now these are just called via snowflake
//! please use these for new datums; in the future we'll standardize to this and decide
//! how to handle UI.
//! in the future, these are going to be singletons.
//? furthermore, in each item, "helper" functions for getting/setting related data from external
//? should be in the file too; this makes it easier to update/harder to forget about during
//? refactors.
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
 *
 * put reasons into errors
 */
/datum/category_item/player_setup_item/proc/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	return TRUE

#warn hook spawn_checks in spawning

/**
 * called to sanitize our value.
 *
 * called after deserialization.
 *
 * put errors into errors for user feedback
 */
/datum/category_item/player_setup_item/proc/filter(datum/preferences/prefs, data, list/errors)
	return data

/**
 * called to sanitize our value on a preferences datum
 *
 * put errors into errors for user feedback
 */
/datum/category_item/player_setup_item/proc/sanitize_data(datum/preferences/prefs, list/errors)
	write(prefs, filter(prefs, read(prefs), errors))

/**
 * called to serialize our value for saving
 *
 * @return raw data to save
 */
/datum/category_item/player_setup_item/proc/serialize_data(datum/preferences/prefs, data, list/errors)
	return data

/**
 * called to deserialize our value during loading
 *
 * migrations are obviously allowed
 *
 * @return deserialized data to set on preferences data lists
 */
/datum/category_item/player_setup_item/proc/deserialize_data(datum/preferences/prefs, raw, list/errors)
	return raw

/**
 * write data, sanitizing in the process
 */
/datum/category_item/player_setup_item/proc/write(datum/preferences/prefs, data)
	#warn impl

/**
 * read data; does not auto-sanitize
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
/datum/category_item/player_setup_item/proc/informed_default_value(datum/preferences/prefs, randomizing)
	return default_value(randomizing)

/**
 * called to render the text the user sees
 *
 * @params
 * - prefs - host preferences datum
 * - user - viewer
 * - data - our save data
 */
/datum/category_item/player_setup_item/proc/content(datum/preferences/prefs, mob/user, data)
	RETURN_TYPE(/list)
	return list()

/**
 * called when something acts on a href
 * returns PREFERENCES_X bitfields for what to do
 *
 * @params
 * - prefs - prefs we're acting on
 * - user - person acting on us
 * - action - the action
 * - params - additional parameters
 */
/datum/category_item/player_setup_item/proc/act(datum/preferences/prefs, mob/user, action, list/params)
	return PREFERENCES_NOACTION

/**
 * encodes href
 */
/datum/category_item/player_setup_item/proc/href(datum/preferences/prefs, action, innerhtml, list/params)
	if(length(params))
		return "<a href='?src=\ref[src];prefs=\ref[prefs];act=[action];[list2params(params)]'>[innerhtml]</a>"
	return "<a href='?src=\ref[src];prefs=\ref[prefs];act=[action]'>[innerhtml]</a>"

/**
 * encodes href
 *
 * act() will be called with action and the action associated to the option in params.
 */
/datum/category_item/player_setup_item/proc/href_simple(datum/preferences/prefs, action, innerhtml, option)
	if(option)
		return "<a href='?src=\ref[src];prefs=\ref[prefs];act=[action];[action]=[option]'>[innerhtml]</a>"
	return "<a href='?src=\ref[src];prefs=\ref[prefs];act=[action]'>[innerhtml]</a>"

//! warning not all content() procs return a list properly
