/**
 * todo: this should just be reagent_volumes[id] but the current system is pants on head stupid
 *
 * @return null if not found, otherwise amount as number
 */
/datum/reagent_holder/proc/legacy_direct_access_reagent_amount(id)
	for(var/datum/reagent/reagent in reagent_list)
		if(reagent.id == id)
			return reagent.volume
	return null

/**
 * todo: what do we do with this?
 */
/datum/reagent_holder/proc/legacy_is_no_react()
	return my_atom?.atom_flags & NOREACT
