//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * completely rechecks all reactions
 *
 * * EXPENSIVE.
 * * all instant reactions will be immediately ran.
 */
/datum/reagent_holder/proc/reconsider_reactions()
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl

/**
 * reconsiders a specific reaction
 *
 * * the reaction, if instant, will be immediately ran.
 */
/datum/reagent_holder/proc/reconsider_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl

/**
 * given a specific chemical id, reconsiders relevant reactions
 *
 * * called by add / remove procs
 * * for optimization reasons, not called by primary reaction loop; reaction loop does this itself.
 */
/datum/reagent_holder/proc/reconsider_reaction_on_reagent(id, amount)
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl

/**
 * Starts a ticked reaction
 */
/datum/reagent_holder/proc/start_ticked_reaction(datum/chemical_reaction/reaction)
	LAZYADD(active_reactions, reaction)
	start_reacting()
	#warn log?

/**
 * Stops a ticked reaction
 */
/datum/reagent_holder/proc/stop_ticked_reaction(datum/chemical_reaction/reaction)
	stop_reacting()
	LAZYREMOVE(active_reactions, reaction)
	#warn log?

/**
 * Starts up reaction loop
 */
/datum/reagent_holder/proc/start_reacting()
	if(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING)
		return
	reagent_holder_flags |= REAGENT_HOLDER_FLAG_CURRENTLY_REACTING
	SSchemistry.reacting_holders += src

/**
 * Stops reaction loop
 */
/datum/reagent_holder/proc/stop_reacting()
	if(!(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING))
		return
	reagent_holder_flags &= ~REAGENT_HOLDER_FLAG_CURRENTLY_REACTING
	SSchemistry.reacting_holders -= src

/**
 * Processes all ticking reactions.
 */
/datum/reagent_holder/proc/reaction_tick(delta_time)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/datum/chemical_reaction/reaction as anything in active_reactions)
		var/checks_pass = TRUE

		for(var/id in reaction.catalysts)
			if(legacy_direct_access_reagent_amount(id) < reaction.catalysts[id])
				checks_pass = FALSE
				break

		if(!checks_pass)
			continue

		var/maximum_multiplier = INFINITY
		var/effective_half_life = reaction.reaction_half_life
		var/total_reactant_volume = 0

		// 1. ingredients
		if(reaction.result_amount > 0)
			maximum_multiplier = min(maximum_multiplier, (maximum_volume - total_volume) / reaction.result_amount)
		for(var/id in reaction.required_reagents)
			var/amount = legacy_direct_access_reagent_amount(id)
			maximum_multiplier = min(maximum_multiplier, amount / reaction.required_reagents[id])
			total_reactant_volume += amount

		// 2. equilibrium (this relies on ingredients and must be #2 after ingredients which is #1)
		if(reaction.equilibrium < 1)
			var/wanted = reaction.equilibrium * legacy_direct_access_reagent_amount(reaction.result)
			maximum_multiplier = min(maximum_multiplier, wanted / reaction.result_amount)

		// 2. temperature

		// 3. ph

		// 4. final checks

		if(effective_half_life >= SHORT_REAL_LIMIT)
			stop_ticked_reaction(reaction)
			continue
		if(maximum_multiplier <= 0)
			stop_ticked_reaction(reaction)
			continue

		// 7. finalize

		#warn log?

		#warn how to trigger reactions if we skip it for the following procs?

		for(var/id in reaction.required_reagents)
			remove_reagent(id, maximum_multiplier * reaction.required_reagents[id], TRUE)
		if(reaction.result_amount > 0)
			add_reagent(reaction.result, maximum_multiplier * reaction.result_amount, null, TRUE)

/**
 * Processes instant reactions
 *
 * * cached data like 'total_volume' must be updated prior to call!
 * * pre-checks for the reaction being able to be completed should already have been done.
 * * the provided reaction list must be priority-sorted if it matters; this proc doesn't do that.
 * * this proc reserves the right to not check any pre-conditions like if we're the correct type of container.
 */
/datum/reagent_holder/proc/run_instant_reactions(list/datum/chemical_reaction/reactions)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/ids_to_recheck = list()

	for(var/datum/chemical_reaction/reaction as anything in reactions)
		var/checks_pass = TRUE

		for(var/id in reaction.catalysts)
			if(legacy_direct_access_reagent_amount(id) < reaction.catalysts[id])
				checks_pass = FALSE
				break

		if(!checks_pass)
			continue

		var/maximum_multiplier = INFINITY

		if(reaction.require_whole_numbers)
			if(reaction.result_amount > 0)
				maximum_multiplier = min(maximum_multiplier, floor((maximum_volume - total_volume) / reaction.result_amount))
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, floor(legacy_direct_access_reagent_amount(id) / reaction.required_reagents[id]))
		else
			if(reaction.result_amount > 0)
				maximum_multiplier = min(maximum_multiplier, (maximum_volume - total_volume) / reaction.result_amount)
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, legacy_direct_access_reagent_amount(id) / reaction.required_reagents[id])

		if(maximum_multiplier <= 0)
			continue

		#warn how to trigger reactions if we skip it for the following procs?
		#warn log?

		for(var/id in reaction.required_reagents)
			remove_reagent(id, maximum_multiplier * reaction.required_reagents[id], TRUE)
			ids_to_recheck[id] = TRUE
		if(reaction.result_amount > 0)
			add_reagent(reaction.result, maximum_multiplier * reaction.result_amount, null, TRUE)
			ids_to_recheck[reaction.result] = TRUE
