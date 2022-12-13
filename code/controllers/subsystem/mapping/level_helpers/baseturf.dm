/**
 * Gets baseturf type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_baseturf(z)
	var/datum/space_level/L = space_levels[z]
	return L.baseturf || world.turf
