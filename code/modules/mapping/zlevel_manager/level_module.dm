/**
 * Level modules
 *
 * used to do specific code for when .json is not enough for a special feature.
 */
/datum/level_module

/datum/level_module/proc/on_load(datum/space_level/level, z_index)
	return
	#warn call in batch after every level is loaded of that level-loading batch

