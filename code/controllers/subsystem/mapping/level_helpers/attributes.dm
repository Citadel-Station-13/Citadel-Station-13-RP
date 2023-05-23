/**
 * Returns an attribute of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_attribute(z, key)
	var/datum/map_level/L = ordered_levels[z]
	return L.attributes[key]

/**
 * Returns the z indices of levels with a certain attribute set to a certain value
 */
/datum/controller/subsystem/mapping/proc/levels_by_attribute(key, value)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(L.attributes[key] == value)
			. += L.z_value
