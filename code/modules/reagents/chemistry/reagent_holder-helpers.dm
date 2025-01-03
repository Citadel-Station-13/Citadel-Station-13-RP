//* Majority Reagent *//

/**
 * Returns reagent datum of highest single reagent in volume, or null if we are empty.
 */
/datum/reagent_holder/proc/get_majority_reagent_datum() as /datum/reagent
	var/highest_so_far = 0
	var/id_so_far
	for(var/id in reagent_volumes)
		if(reagent_volumes[id] > highest_so_far)
			id_so_far = id
	return SSchemistry.fetch_reagent(id_so_far)

/**
 * Returns reagent name of highest single reagent in volume, or null if we are empty.
 */
/datum/reagent_holder/proc/get_majority_reagent_name()
	return get_majority_reagent_datum()?.name

/**
 * Returns reagent ID of highest single reagent in volume, or null if we are empty.
 */
/datum/reagent_holder/proc/get_majority_reagent_id()
	return get_majority_reagent_datum()?.id
