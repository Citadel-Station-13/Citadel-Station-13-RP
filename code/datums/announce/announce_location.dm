/**
 * announcement locations
 */
/datum/announce_location
	/// name
	var/name = "Unknown Location"
	/// description
	var/desc = "Unknown."
	/// allow ghosts?
	var/always_allow_ghosts = FALSE

/**
 * get affected atoms to process on
 */
/datum/announce_location/proc/get_affected_atoms()
	. = list()
	var/list/levels = get_affected_levels()
	for(var/mob/M in GLOB.player_list)
		if(always_allow_ghosts && istype(M, /mob/observer/dead))
			. += M
			continue
		if(get_z(M) in levels)
			. += M
/**
 * get affected zlevels
 */
/datum/announce_location/proc/get_affected_levels()
	return list()

/datum/announce_location/proc/render_proper_possessive_name()
	return "A"
