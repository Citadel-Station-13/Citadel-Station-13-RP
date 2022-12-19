GLOBAL_LIST_INIT(characteristics_stats, _create_characteristics_stats())

/proc/_create_characteristics_stats()

/**
 * gets a stat datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_stat(datum/characteristic_stat/typepath_or_id)
	RETURN_TYPE(/datum/characteristic_stat)
	return GLOB.characteristics_stats[ispath(typepath_or_id)? initial(typepath_or_id.id) : typepath_or_id]

/**
 * stats - basically raw skills that can theoretically hold anything
 * you usually don't want players to be able to touch these or minmax them too hard
 * use skills whenever possible
 *
 * stats are null when unset, and baseline when characteristics are disabled
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
	var/baseline_value
