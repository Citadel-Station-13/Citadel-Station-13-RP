/**
 * gets if two zlevels are logically connected.
 * requires them to be in the same struct.
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_struct(z1, z2)
	#warn impl

/**
 * gets if the two zlevels are both station levels
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_station(z1, z2)
	#warn impl

/**
 * gets if the two zlevels are both station zlevels, OR are in the same struct
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_loose(z1, z2)
	#warn impl

/**
 * gets if the two zlevels are both crosslinked.
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_crosslink(z1, z2)
	#warn impl

/**
 * gets if the two zlevels are in the same overmaps object
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_overmap(z1, z2)
	#warn impl

/**
 * default connectivity checks
 *
 * 1. overmap check ONLY if overmaps are enabled
 * 2. default to either both same struct, or both station
 *
 * crosslinking is ignored.
 */
/datum/controller/subsystem/mapping/proc/level_connectivity(z1, z2)
	#warn impl

/**
 * default connectivity checks but with a specified overmaps range
 * this is here so regexing later is easier (we won't have to touch level_connectivity)
 *
 * 1. overmap check ONLY if overmaps are enabled
 * 2. default to either struct, or both station
 */
/datum/controller/subsystem/mapping/proc/level_in_range(z1, z2, radius = 1)
	#warn impl

/**
 * gets connected levels by struct
 *
 * !* DO NOT MODIFY RETURNED LIST *!
 */
/datum/controller/subsystem/mapping/proc/get_connected_levels_struct(z)
	RETURN_TYPE(/list)
	if(!struct_by_z[z])
		return list(z)
	return struct_by_z[z].real_indices

/**
 * gets connected levels by overmap
 */
/datum/controller/subsystem/mapping/proc/get_connected_levels_overmap(z, radius = 1)
	RETURN_TYPE(/list)
	. = list()
	#warn impl

/**
 * default logic for getting all crosslinked zlevels
 */
/datum/controller/subsystem/mapping/proc/get_connected_levels_crosslink(z)
	RETURN_TYPE(/list)
	var/datum/space_level/L = ordered_levels[z]
	if(L.linkage_mode != Z_LINKAGE_CROSSLINKED)
		return list(z)
	return crosslinked_levels()

/**
 * default logic for getting all connected zlevels
 *
 * 1. if using overmaps, returns overmap object levels
 * 2. if using struct, struct levels are added ontop of that
 */
/datum/controller/subsystem/mapping/proc/get_connected_levels(z)
	RETURN_TYPE(/list)
	. = list()
	#warn impl

/**
 * default logic for getting all connected zlevels with a specified overmaps range
 * this is here so regexing later is easier (we won't have to touch get_connected_levels)
 */
/datum/controller/subsystem/mapping/proc/levels_in_range(z, radius = 1)
	#warn impl
