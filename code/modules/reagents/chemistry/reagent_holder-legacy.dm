/**
 * todo: this should just be reagent_volumes[id], this is not done for PR atomicity reasons
 *
 * @return null if not found, otherwise amount as number
 */
/datum/reagent_holder/proc/legacy_direct_access_reagent_amount(id)
	return reagent_volumes?[id]

/**
 * todo: what do we do with this?
 */
/datum/reagent_holder/proc/legacy_is_no_react()
	return my_atom?.atom_flags & NOREACT
