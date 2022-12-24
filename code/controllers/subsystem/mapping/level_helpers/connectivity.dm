// todo: better connectivity checks and struct "glueing"

/**
 * gets if two zlevels are logically connected.
 * requires them to be in the same struct.
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_struct(z1, z2)
	return (z1 == z2) || (struct_by_z[z1] && (struct_by_z[z1] == struct_by_z[z2]))

/**
 * gets if the two zlevels are both station levels
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_station(z1, z2)
	return (z1 == z2) || (level_trait(z1, ZTRAIT_STATION) && level_trait(z2, ZTRAIT_STATION))

/**
 * gets if the two zlevels are both station zlevels, OR are in the same struct
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_loose(z1, z2)
	return (z1 == z2) || \
		(level_trait(z1, ZTRAIT_STATION) && level_trait(z2, ZTRAIT_STATION)) || \
		(struct_by_z[z1] && (struct_by_z[z1] == struct_by_z[z2]))

/**
 * gets if the two zlevels are both crosslinked.
 * used in loose interconnectivity checks
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_crosslink(z1, z2)
	return (z1 == z2) || ((ordered_levels[z1].linkage_mode == Z_LINKAGE_CROSSLINKED) && (ordered_levels[z2].linkage_mode == Z_LINKAGE_CROSSLINKED))


/**
 * gets if the two zlevels are in the same overmaps object (or close enough)
 */
/datum/controller/subsystem/mapping/proc/level_connectivity_overmap(z1, z2, radius = DEFAULT_OVERMAP_RANGE)
	if(z1 == z2)
		return TRUE
	var/obj/effect/overmap/visitable/V1 = get_overmap_sector(z1)
	var/obj/effect/overmap/visitable/V2	= get_overmap_sector(z2)
	if(radius == NO_OVERMAP_RANGE)
		return V1 == V2
	return get_dist(V1, V2) <= radius

/**
 * default connectivity checks
 *
 * 1. overmap check ONLY if overmaps are enabled
 * 2. default to either both same struct, or both station
 * 3. long range referes to crosslinking (?) undetermined yet
 */
/datum/controller/subsystem/mapping/proc/level_connectivity(z1, z2, radius = DEFAULT_OVERMAP_RANGE, long_range)
	#warn impl - make sure to check for NO_OVERMAP_RANGE

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
/datum/controller/subsystem/mapping/proc/get_connected_levels_overmap(z, radius = DEFAULT_OVERMAP_RANGE)
	RETURN_TYPE(/list)
	. = list()
	#warn impl - make sure to check for NO_OVERMAP_RANGE

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
 * 1. if using overmaps, returns overmap object levels; else, check crosslinked if long range
 * 2. if using struct, struct levels are added ontop of that
 *
 * @params
 * - z - level
 * - radius - overmap radius to search in; *NULL* to disable and use current object only
 * - long_range - check crosslinked if not overmaps; overmaps behavior is nothing for now.
 */
/datum/controller/subsystem/mapping/proc/get_connected_levels(z, radius = DEFAULT_OVERMAP_RANGE, long_range)
	RETURN_TYPE(/list)
	. = list()
	#warn impl - make sure to check for NO_OVERMAP_RANGE
