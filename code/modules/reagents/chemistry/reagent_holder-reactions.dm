//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Public API *//

/**
 * completely rechecks all reactions
 *
 * * EXPENSIVE.
 * * all instant reactions will be immediately ran.
 */
/datum/reagent_holder/proc/reconsider_reactions()
	SHOULD_NOT_SLEEP(TRUE)

	var/list/datum/chemical_reaction/reactions = SSchemistry.immutable_relevant_reactions_for_reagent_ids(reagent_volumes)
	check_reactions(reactions)

//* Internal API *//

/**
 * Reconsiders a list of reactions.
 *
 * * instant reactions will always run first
 *
 * @params
 * * reactions - reactions to recheck; this will not be mutated
 * * safety - safety parameter to prevent instant reactions from infinite looping
 * * instant_only - skip ticked reactions
 */
/datum/reagent_holder/proc/check_reactions(list/datum/chemical_reaction/reactions, safety)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)

	// todo: should this be a single flag, and should this be here?
	if(legacy_is_no_react())
		return

	var/list/datum/chemical_reaction/potentially_ticked = list()
	var/list/datum/chemical_reaction/instant_reacting = list()
	for(var/datum/chemical_reaction/reaction as anything in reactions)
		// ticked?
		if(reaction.reaction_half_life != 0)
			potentially_ticked += reaction
			continue
		// can happen?
		if(!reaction.can_happen(src))
			continue
		// stage for react
		instant_reacting += reaction

	run_instant_reactions(instant_reacting, safety)

	if(QDELETED(src))
		return

	for(var/datum/chemical_reaction/reaction as anything in potentially_ticked)
		if(!reaction.can_happen(src))
			continue
		start_ticked_reaction(reaction)
		if(QDELETED(src))
			return

/**
 * given a specific chemical id, reconsiders relevant reactions
 *
 * * called by add / remove procs
 * * called by reaction loops
 * * instant reactions will be immediately ran.
 */
/datum/reagent_holder/proc/try_reactions_for_reagent_change(id)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)

	var/list/datum/chemical_reaction/reactions = SSchemistry.immutable_relevant_reactions_for_reagent_id(id)
	check_reactions(reactions)

/**
 * given a set of chemical ids, reconsiders relevant reactions
 *
 * * called by add / remove procs
 * * called by reaction loops
 * * instant reactions will be immediately ran.
 */
/datum/reagent_holder/proc/try_reactions_for_reagents_changed(list/ids)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)

	var/list/datum/chemical_reaction/reactions = SSchemistry.immutable_relevant_reactions_for_reagent_ids(ids)
	check_reactions(reactions)

//* Reaction Orchestration *//

/**
 * Starts a ticked reaction
 */
/datum/reagent_holder/proc/start_ticked_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(active_reactions?[reaction])
		return
	log_chemical_reaction_ticked_start(src, reaction)
	LAZYSET(active_reactions, reaction, list())
	reaction.on_reaction_start(src)
	if(QDELETED(src))
		return
	start_reacting()

/**
 * Stops a ticked reaction
 */
/datum/reagent_holder/proc/stop_ticked_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active_reactions[reaction])
		return
	reaction.on_reaction_finish(src)
	log_chemical_reaction_ticked_start(src, reaction, active_reactions[reaction])
	LAZYREMOVE(active_reactions, reaction)
	if(!length(active_reactions))
		stop_reacting()

/**
 * Starts up reaction loop
 */
/datum/reagent_holder/proc/start_reacting()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING)
		return
	reagent_holder_flags |= REAGENT_HOLDER_FLAG_CURRENTLY_REACTING
	SSchemistry.reacting_holders += src

/**
 * Stops reaction loop
 */
/datum/reagent_holder/proc/stop_reacting()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING))
		return
	reagent_holder_flags &= ~REAGENT_HOLDER_FLAG_CURRENTLY_REACTING
	SSchemistry.reacting_holders -= src

//* Reaction Loops *//

/**
 * Processes all ticking reactions.
 *
 * todo: if necessary reagents for a reaction is removed, it doesn't stop immediately, instead stopping on the next tick.
 *       this is not amazing.
 */
/datum/reagent_holder/proc/reaction_tick(delta_time)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/list/ids_to_recheck = list()

	if(!reagent_volumes)
		for(var/datum/chemical_reaction/reaction as anything in active_reactions)
			stop_ticked_reaction(reaction)
		return

	for(var/datum/chemical_reaction/reaction as anything in active_reactions)
		var/checks_pass = TRUE

		// make sure catalysts are there
		for(var/reagent in reaction.catalysts)
			var/catalyst_amount = reagent_volumes[reagent]
			if(isnull(catalyst_amount) || (catalyst_amount < reaction.catalysts[reagent]))
				checks_pass = FALSE
				break

		if(!checks_pass)
			stop_ticked_reaction(reaction)
			continue

		var/maximum_multiplier = INFINITY
		var/effective_half_life = reaction.reaction_half_life
		var/total_reactant_volume = 0

		// ingredients
		for(var/id in reaction.required_reagents)
			var/amount = reagent_volumes[id]
			maximum_multiplier = min(maximum_multiplier, amount / reaction.required_reagents[id])
			total_reactant_volume += amount

		// results; take into account ingredients consumed if we were to run to completion
		if(reaction.result_amount > 0)
			maximum_multiplier = min(maximum_multiplier, ((maximum_volume - total_volume) + maximum_multiplier * reaction.required_reagents_unit_volume) / reaction.result_amount)

		// equilibrium (this relies on ingredients and must be #2 after ingredients which is #1)
		if(reaction.equilibrium != INFINITY)
			// wanted % of product
			var/wanted_percent = reaction.equilibrium / (reaction.equilibrium + 1)
			var/wanted = wanted_percent * (reagent_volumes[reaction.result] + total_reactant_volume)
			maximum_multiplier = clamp(maximum_multiplier, 0, wanted / reaction.result_amount)
			if(maximum_multiplier <= 0)
				return

		// temperature hard checks are here, not above, because they
		// should've already been checked when these were added.

		// temperature
		effective_half_life = reaction.temperature_modulation(effective_half_life, temperature)
		if(isnull(effective_half_life))
			stop_ticked_reaction(reaction)
			continue

		// moderators
		for(var/id in reaction.moderators)
			if(reagent_volumes[id])
				effective_half_life *= reaction.moderators[id]

		// half life
		maximum_multiplier *= 1 - (0.5 ** (delta_time / effective_half_life))

		// if this is near-infinite it means a moderator is halting the reaction
		if(effective_half_life >= SHORT_REAL_LIMIT)
			stop_ticked_reaction(reaction)
			continue
		// if we don't have enough to finish just halt now
		if(maximum_multiplier <= 0)
			stop_ticked_reaction(reaction)
			continue

		// finalize
		for(var/id in reaction.required_reagents)
			remove_reagent(id, maximum_multiplier * reaction.required_reagents[id], TRUE)
			ids_to_recheck[id] = TRUE
		if(reaction.result_amount > 0)
			add_reagent(
				reaction.result,
				maximum_multiplier * reaction.result_amount,
				reaction.has_data_semantics ? reaction.compute_result_data_initializer(src, maximum_multiplier) : null,
				TRUE,
			)
			ids_to_recheck[reaction.result] = TRUE

		reaction.on_reaction_tick(src, delta_time, maximum_multiplier)

		if(QDELETED(src))
			break

	// secondary qdeleted check incase we got destroyed
	if(QDELETED(src))
		return

	// now that we're done, re-check relevant reactions that might happen
	// and process them as needed
	var/list/datum/chemical_reaction/reactions_to_recheck = SSchemistry.immutable_relevant_instant_reactions_for_reagent_ids(ids_to_recheck)
	check_reactions(reactions_to_recheck, null)

/**
 * Processes instant reactions
 *
 * * cached data like 'total_volume' must be updated prior to call!
 * * pre-checks for the reaction being able to be completed should already have been done.
 * * the provided reaction list must be priority-sorted if it matters; this proc doesn't do that.
 * * this proc reserves the right to not check any pre-conditions like if we're the correct type of container.
 * * this proc will run reactions to completion.
 */
/datum/reagent_holder/proc/run_instant_reactions(list/datum/chemical_reaction/reactions, safety = 50)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!length(reactions))
		return
	if(safety <= 0)
		clear_reagents(TRUE)
		CRASH("run_instant_reactions aborted due to potential infinite loop. reactions list was [english_list(reactions)]")
	if(!reagent_volumes)
		return

	var/list/ids_to_recheck = list()

	for(var/datum/chemical_reaction/reaction as anything in reactions)
		var/checks_pass = TRUE

		// make sure catalysts are there
		for(var/reagent in reaction.catalysts)
			var/catalyst_amount = reagent_volumes[reagent]
			if(isnull(catalyst_amount) || (catalyst_amount < reaction.catalysts[reagent]))
				checks_pass = FALSE
				break

		if(!checks_pass)
			continue

		// we only care about moderators that halt reaction for instant reactions
		for(var/id in reaction.moderators)
			if(reaction.moderators[id] >= SHORT_REAL_LIMIT && reagent_volumes[id])
				checks_pass = FALSE
				break
		if(!checks_pass)
			continue

		var/maximum_multiplier = INFINITY

		if(reaction.require_whole_numbers)
			// tally up required reagents
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, floor(reagent_volumes[id] / reaction.required_reagents[id]))
			// tally up remaining space, taking into account the reagents we would consume if we reacted to completion
			if(reaction.result && reaction.result_amount > 0)
				maximum_multiplier = min(maximum_multiplier, floor(((maximum_volume - total_volume) + (maximum_multiplier * reaction.required_reagents_unit_volume)) / reaction.result_amount))
		else
			// tally up required reagents
			for(var/id in reaction.required_reagents)
				maximum_multiplier = min(maximum_multiplier, reagent_volumes[id] / reaction.required_reagents[id])
			// tally up remaining space, taking into account the reagents we would consume if we reacted to completion
			if(reaction.result && reaction.result_amount > 0)
				maximum_multiplier = min(maximum_multiplier, ((maximum_volume - total_volume) + (maximum_multiplier * reaction.required_reagents_unit_volume)) / reaction.result_amount)

		if(maximum_multiplier <= 0)
			continue

		log_chemical_reaction_instant(src, reaction, maximum_multiplier)

		for(var/id in reaction.required_reagents)
			remove_reagent(id, maximum_multiplier * reaction.required_reagents[id], TRUE)
			ids_to_recheck[id] = TRUE
		if(reaction.result && reaction.result_amount > 0)
			add_reagent(
				reaction.result,
				maximum_multiplier * reaction.result_amount,
				reaction.has_data_semantics ? reaction.compute_result_data_initializer(src, maximum_multiplier) : null,
				TRUE,
			)
			ids_to_recheck[reaction.result] = TRUE

		reaction.on_reaction_instant(src, maximum_multiplier)

		if(QDELETED(src))
			break

	// secondary qdeleted check incase we got destroyed
	if(QDELETED(src))
		return

	// now that we're done, re-check relevant reactions that might happen
	// and process them as needed
	var/list/datum/chemical_reaction/reactions_to_recheck = SSchemistry.immutable_relevant_reactions_for_reagent_ids(ids_to_recheck)
	check_reactions(reactions_to_recheck, safety - 1)
