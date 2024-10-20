/**
 * todo: this should just be reagent_volumes[id] but the current system is pants on head stupid
 */
/datum/reagent_holder/proc/legacy_direct_access_reagent_amount(id)
	#warn impl

/**
 * todo: what do we do with this?
 */
/datum/reagent_holder/proc/legacy_is_no_react()
	return my_atom.atom_flags & NOREACT
