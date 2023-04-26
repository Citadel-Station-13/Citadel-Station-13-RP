/**
 * Sector module
 *
 * Handles sector registration and lookups
 *
 * Does **not** handle sector ticking!
 */
/datum/controller/subsystem/mapping
	/// sector by id
	var/list/sector_lookup = list()
	/// sector by z
	var/list/sector_index = list()
	/// cached "this is the top level of the sector"
	var/list/sector_is_top_level = list()

/datum/controller/subsystem/mapping/Recover()
	. = ..()
	#warn impl

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	if(sector_index.len != new_z_count)
		sector_index.len = new_z_count
		for(var/i in 1 to sector_index.len)
			if(!islist(sector_index[i]))
				sector_index[i] = list()
	if(sector_is_top_level.len != new_z_count)
		sector_is_top_level.len = new_z_count
		rebuild_sector_top_levels()

/**
 * looks up a world sector, or null if there's none
 */
/datum/controller/subsystem/mapping/proc/sector_by_id(id)
	RETURN_TYPE(/datum/world_sector)
	return sector_lookup[id]

/**
 * looks up a world sector, or null if there's none
 */
/datum/controller/subsystem/mapping/proc/sector_by_z(z)
	RETURN_TYPE(/datum/world_sector)
	return sector_index[z]

/**
 * rebuilds the cache of which levels are the top of their sectors
 */
/datum/controller/subsystem/mapping/proc/rebuild_sector_top_levels()
	#warn impl

#warn register
#warn ticking on SSplanets
