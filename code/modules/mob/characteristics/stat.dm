GLOBAL_LIST_INIT(characteristics_stats, _create_characteristics_stats())

/proc/_create_characteristics_stats()

/**
 * gets a stat datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_stat(datum/characteristic_stat/typepath_or_id)
	if(ispath(typepath_or_id))
		return GLOB.characteristics_stats[initial(typepath_or_id[id])]
	ASSERT(istext(typepath_or_id))
	return GLOB.characteristics_stats[typepath_or_id]

/**
 * stats - basically raw skills that can theoretically hold anything
 * you usually don't want players to be able to touch these or minmax them too hard
 * use skills whenever possible
 */
/datum/characteristic_stat
	abstract_type = /datum/characteristic_stat
	/// unique id
	var/id
	/// name
	var/name = "ERROR"
	/// description
	var/desc = "An unknown stat. Someone needs to change this."
	/// cateogry - just a string, no defines for now, surely no one will typo..
	var/category = "General"
	/// datatype
	var/datatype = CHARACTER_STAT_UNKNOWN
	/// default value when characteristics are disabled
	var/default
	/// default value when *unset* - MAKE SURE TO SET THIS
	var/baseline
