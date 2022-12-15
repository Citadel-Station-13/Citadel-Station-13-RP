/**
 * Level modules
 *
 * used to do specific code for when .json is not enough for a special feature.
 */
/datum/map_module

/datum/map_module/proc/on_load(datum/map_data/map, list/datum/space_level/levels, list/z_indices)
	return
	#warn call after a map config is loaded

