/**
 * added fluid procs to reagents
 */

/**
 * Quickly removes a ratio of reagents and returns the removed reagents
 */
/datum/reagents/proc/FastRemoveRatio(ratio, defer)
	ratio = clamp(ratio, 0, 1)
	var/datum/reagents/returned = new(FLUID_MAX_VOLUME)
	if(!total_volume)
		return returned
	for(var/datum/reagent/old in reagent_list)
		var/datum/reagent/R = new SSchemistry.chemical_reagents[old.id]
		returned.reagent_list += R
		R.volume = old.volume
		R.holder = returned
	returned.total_volume = reagents.total_volume * ratio
	if(!defer)
		FastUpdateVolume()
	return returned

/**
 * Quickly removes an amount of reagents and returns the removed reagents
 */
/datum/reagents/proc/FastRemove(units, defer)
	return FastRemoveRatio(units / reagents.total_volume, defer)

/**
 * Quickly updates the total_volume variable
 */
/datum/reagents/proc/FastUpdateVolume()
	. = 0
	for(var/datum/reagent/R as anything in reagent_list)
		. += R.volume
	total_volume = .

/**
 * Quickly compares to see if we're different in composition ratios
 *
 * Returns 1 if we're different
 */
/datum/reagents/proc/FastCompareComposition(datum/reagents/other, lenience = 1)
	if(!total_volume || !other.total_volume)
		return !(total_volume == other.total_volume)
	var/ratio = total_volume / other.total_volume
	var/list/by_id = list()
	for(var/datum/reagent/R as anything in reagent_list)
		by_id[R.id] = R.volume
	for(var/datum/reagent/R as anything in other)
		if(round(abs((by_id[R.id] * ratio) - R.volume), lenience))
			return TRUE
	return FALSE
