/**
 * completely rechecks all reactions
 *
 * * EXPENSIVE.
 * * all instant reactions will be immediately ran.
 */
/datum/reagent_holder/proc/reconsider_reactions()
	SHOULD_NOT_SLEEP(TRUE)

/**
 * reconsiders a specific reaction
 *
 * * the reaction, if instant, will be immediately ran.
 */
/datum/reagent_holder/proc/reconsider_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * given a specific chemical id, reconsiders relevant reactions
 *
 * * called by add / remove procs
 * * for optimization reasons, not called by primary reaction loop; reaction loop does this itself.
 */
/datum/reagent_holder/proc/reconsider_reaction_on_reagent(id, amount)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Starts a ticked reaction
 */
/datum/reagent_holder/proc/start_ticked_reaction(datum/chemical_reaction/reaction)

/**
 * Stops a ticked reaction
 */
/datum/reagent_holder/proc/stop_ticked_reaction(datum/chemical_reaction/reaction)

/**
 * Processes all ticking reactions.
 */
/datum/reagent_holder/proc/reaction_tick(delta_time)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/datum/chemical_reaction/reaction as anything in active_reactions)

/**
 * Processes instant reactions
 *
 * * pre-checks for the reaction being able to be completed should already have been done.
 * * the provided reaction list must be priority-sorted if it matters; this proc doesn't do that.
 * * this proc reserves the right to not check any pre-conditions like if we're the correct type of container.
 */
/datum/reagent_holder/proc/run_instant_reactions(list/datum/chemical_reaction/reactions)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/datum/chemical_reaction/reaction as anything in reactions)
		var/maximum_multiplier = INFINITY

		if(reaction.require_whole_numbers)
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, floor(legacy_direct_access_reagent_amount(id) / reaction.required_reagents[id]))
		else
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, legacy_direct_access_reagent_amount(id) / reaction.required_reagents[id])

