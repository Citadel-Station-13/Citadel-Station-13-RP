/**
 * announcement locations
 */
/datum/announce_location
	/// name
	var/name = "Unknown Location"
	/// description
	var/desc = "Unknown."

/**
 * get affected atoms to process on
 */
/datum/announce_location/proc/get_affected_atoms()
	return list()

/**
 * get affected zlevels
 */
/datum/announce_location/proc/get_affected_levels()
	return list()
