GLOBAL_LIST_INIT(characteristics_stats, _create_characteristics_stats())

/proc/_create_characteristics_stats()

/**
 * gets a stat datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_stat(datum/stat/typepath_or_id)
	if(ispath(typepath_or_id))
		return GLOB.characteristics_stats[initial(typepath_or_id[id])]
	ASSERT(istext(typepath_or_id))
	return GLOB.characteristics_stats[typepath_or_id]

/**
 * stats - heavily numeric skills
 * you usually don't want players to be able to touch these or minmax them too hard
 * use skills whenever possible
 */
/datum/stat
	var/id

