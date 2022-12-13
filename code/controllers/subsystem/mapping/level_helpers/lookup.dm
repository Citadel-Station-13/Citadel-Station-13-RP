/**
 * returns the map level id of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_id(z)
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
	return level_by_id[id]?.z_value

/**
 * returns the z indices in a struct id
 */
/datum/controller/subsystem/mapping/proc/levels_by_struct_id(id)
	#warn impl
