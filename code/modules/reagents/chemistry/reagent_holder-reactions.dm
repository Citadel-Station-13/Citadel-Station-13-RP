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

	var/list/reagent_ids = list()
	for(var/datum/reagent/reagent in reagent_list)
		reagent_ids[reagent.id] = TRUE

	var/list/datum/chemical_reaction/reactions = SSchemistry.relevant_reactions_for_reagent_ids(reagent_ids)
	check_reactions(reactions)

//* Internal API *//

/**
 * Reconsiders a list of reactions.
 *
 * * instant reactions will always run first
 *
 * @params
 * * reactions - reactions to recheck
 * * safety - safety parameter to prevent instant reactions from infinite looping
 */
/datum/reagent_holder/proc/check_reactions(list/datum/chemical_reaction/reactions, safety)
	var/list/datum/chemical_reaction/potentially_ticked = list()
	var/list/datum/chemical_reaction/instant_reacting = list()
	for(var/datum/chemical_reaction/reaction as anything in reactions)
		if(reaction.reaction_half_life != 0)
			// ticked
			potentially_ticked += reaction
			continue
		if(!reaction.can_happen(src))
			continue
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
/datum/reagent_holder/proc/try_reactions_on_reagent_change(id)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)

	var/list/datum/chemical_reaction/reactions = SSchemistry.relevant_reactions_for_reagent_id(id)
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

	var/list/datum/chemical_reaction/reactions = SSchemistry.relevant_reactions_for_reagent_ids(ids)
	check_reactions(reactions)

//* Reaction Orchestration *//

/**
 * Starts a ticked reaction
 */
/datum/reagent_holder/proc/start_ticked_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(active_reactions[reaction])
		return
	LAZYSET(active_reactions, reaction, list())
	reaction.on_reaction_start(src)
	if(QDELETED(src))
		return
	start_reacting()

	#warn log?

/**
 * Stops a ticked reaction
 */
/datum/reagent_holder/proc/stop_ticked_reaction(datum/chemical_reaction/reaction)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active_reactions[reaction])
		return
	reaction.on_reaction_finish(src)
	LAZYREMOVE(active_reactions, reaction)
	if(!length(active_reactions))
		stop_reacting()

	#warn log?

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

	for(var/datum/chemical_reaction/reaction as anything in active_reactions)
		var/checks_pass = TRUE

		// make sure catalysts are there
		for(var/id in reaction.catalysts)
			if(legacy_direct_access_reagent_amount(id) < reaction.catalysts[id])
				checks_pass = FALSE
				break

		if(!checks_pass)
			stop_ticked_reaction(reaction)
			continue

		var/maximum_multiplier = INFINITY
		var/effective_half_life = reaction.reaction_half_life
		var/total_reactant_volume = 0

		#warn check before/after volume

		// ingredients
		if(reaction.result_amount > 0)
			maximum_multiplier = min(maximum_multiplier, (maximum_volume - total_volume) / reaction.result_amount)
		for(var/id in reaction.required_reagents)
			var/amount = legacy_direct_access_reagent_amount(id)
			maximum_multiplier = min(maximum_multiplier, amount / reaction.required_reagents[id])
			total_reactant_volume += amount

		// equilibrium (this relies on ingredients and must be #2 after ingredients which is #1)
		if(reaction.equilibrium < 1)
			#warn recalc this
			var/wanted = reaction.equilibrium * legacy_direct_access_reagent_amount(reaction.result)
			maximum_multiplier = min(maximum_multiplier, wanted / reaction.result_amount)

		// temperature hard checks are here, not above, because they
		// should've already been checked when these were added.

		// temperature
		effective_half_life = reaction.temperature_modulation(effective_half_life, temperature)
		if(isnull(effective_half_life))
			stop_ticked_reaction(reaction)
			continue

		// moderators
		for(var/id in reaction.moderators)
			if(legacy_direct_access_reagent_amount(id))
				effective_half_life *= reaction.moderators[id]

		// half life
		#warn half-life & finish threshold

		// if this is near-infinite it means a moderator is halting the reaction
		if(effective_half_life >= SHORT_REAL_LIMIT)
			stop_ticked_reaction(reaction)
			continue
		// if we don't have enough to finish just halt now
		if(maximum_multiplier <= 0)
			stop_ticked_reaction(reaction)
			continue

		// finalize

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
 * * this proc will run reactions to completion.
 */
/datum/reagent_holder/proc/run_instant_reactions(list/datum/chemical_reaction/reactions, safety = 50)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!length(reactions))
		return
	if(safety <= 0)
		CRASH("run_instant_reactions aborted due to potential infinite loop. reactions list was [english_list(reactions)]")

	var/list/ids_to_recheck = list()

	for(var/datum/chemical_reaction/reaction as anything in reactions)
		var/checks_pass = TRUE

		// make sure catalysts are there
		for(var/id in reaction.catalysts)
			if(legacy_direct_access_reagent_amount(id) < reaction.catalysts[id])
				checks_pass = FALSE
				break
		if(!checks_pass)
			continue

		// we only care about moderators that halt reaction for instant reactions
		for(var/id in reaction.moderators)
			if(reaction.moderators[id] >= SHORT_REAL_LIMIT && legacy_direct_access_reagent_amount(id))
				checks_pass = FALSE
				break
		if(!checks_pass)
			continue

		var/maximum_multiplier = INFINITY

		#warn check before/after volume

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

		#warn log here!

		for(var/id in reaction.required_reagents)
			remove_reagent(id, maximum_multiplier * reaction.required_reagents[id], TRUE)
			ids_to_recheck[id] = TRUE
		if(reaction.result_amount > 0)
			add_reagent(reaction.result, maximum_multiplier * reaction.result_amount, null, TRUE)
			ids_to_recheck[reaction.result] = TRUE

		reaction.on_reaction_instant(src, maximum_multiplier)

		if(QDELETED(src))
			break

	// secondary qdeleted check incase we got destroyed

	if(QDELETED(src))
		return

	// now that we're done, re-check relevant reactions that might happen
	// and process them as needed

	var/list/datum/chemical_reaction/reactions_to_recheck = SSchemistry.relevant_reactions_for_reagent_ids(ids_to_recheck)
	check_reactions(reactions_to_recheck, safety - 1)
