/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_id(z)
	#warn impl

/**
 * returns the canon/IC-friendly level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/fluff_level_id(z)
	#warn impl

/**
 * returns the struct id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/struct_id(z)
	#warn impl

/**
 * returns the z index of an id
 */
/datum/controller/subsystem/mapping/proc/level_by_id(id)
	return keyed_levels[id]?.z_value

/**
 * returns the z indices in a struct id
 */
/datum/controller/subsystem/mapping/proc/levels_by_struct_id(id)
	#warn impl
