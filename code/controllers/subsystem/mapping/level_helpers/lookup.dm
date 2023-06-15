/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_id(z)
	return ordered_levels[z]?.id

/**
 * returns the canon/IC-friendly level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_id(z)
	return ordered_levels[z]?.display_id

/**
 * returns the map level name of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_name(z)
	return ordered_levels[z]?.name

/**
 * returns the canon/IC-friendly level mame of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_name(z)
	return ordered_levels[z]?.display_name

/**
 * returns the z index of an id
 */
/datum/controller/subsystem/mapping/proc/level_by_id(id)
	return keyed_levels[id]?.z_index
