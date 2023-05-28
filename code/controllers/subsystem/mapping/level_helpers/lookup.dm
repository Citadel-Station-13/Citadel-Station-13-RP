/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_id(z)
	return keyed_levels[id]?.id

/**
 * returns the canon/IC-friendly level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_id(z)
	return keyed_levels[id]?.display_id

/**
 * returns the map level name of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_name(z)
	return keyed_levels[id]?.name

/**
 * returns the canon/IC-friendly level mame of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_name(z)
	return keyed_levels[id]?.display_name

/**
 * returns the z index of an id
 */
/datum/controller/subsystem/mapping/proc/level_by_id(id)
	return keyed_levels[id]?.z_index
