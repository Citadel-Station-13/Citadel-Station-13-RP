/**
 * completely rechecks all reactions
 *
 * * EXPENSIVE.
 */
/datum/reagent_holder/proc/reconsider_reactions()

/**
 * reconsiders a specific reaction
 */
/datum/reagent_holder/proc/reconsider_reaction(datum/chemical_reaction/reaction)

/**
 * given a specific chemical id, reconsiders relevant reactions
 *
 * * called by add / remove procs
 * * for optimization reasons, not called by primary reaction loop; reaction loop does this itself.
 */
/datum/reagent_holder/proc/reconsider_reaction_on_reagent(id, amount)

/datum/reagent_holder/proc/reaction_loop()

/datum/reagent_holder/proc/handle_reactions()
	set waitfor = FALSE		// shitcode. reagents shouldn't ever sleep but hey :^)
	if(QDELETED(my_atom))
		return FALSE
	if(my_atom.atom_flags & NOREACT)
		return FALSE
	var/reaction_occurred
	var/list/eligible_reactions = list()
	var/list/effect_reactions = list()
	do
		reaction_occurred = FALSE
		for(var/i in reagent_list)
			var/datum/reagent/R = i
			if(SSchemistry.chemical_reactions_by_reagent[R.id])
				eligible_reactions |= SSchemistry.chemical_reactions_by_reagent[R.id]

		for(var/i in eligible_reactions)
			var/datum/chemical_reaction/C = i
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occurred = TRUE
		eligible_reactions.len = 0
	while(reaction_occurred)
	for(var/i in effect_reactions)
		var/datum/chemical_reaction/C = i
		C.post_reaction(src)
	update_total()
