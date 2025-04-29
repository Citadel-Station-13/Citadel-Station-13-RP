/**
 * todo: what do we do with this?
 */
/datum/reagent_holder/proc/legacy_is_no_react()
	return my_atom?.atom_flags & NOREACT
