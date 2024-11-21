SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 10
	init_order = INIT_ORDER_CHEMISTRY
	subsystem_flags = SS_NO_INIT

	/// id to instance dict of reagents
	var/list/reagent_lookup = list()
	/// flat list of all chemical reactions
	var/list/chemical_reactions = list()
	/// cached relevant reactions by reagent
	///
	/// * reagent id = list(reactions)
	/// * used to prune reactions to check
	var/list/chemical_reactions_relevant_for_reagent_id = list()

	/// reacting holders
	var/static/list/datum/reagent_holder/reacting_holders = list()
	/// currentrun for reacting holders
	var/static/list/datum/reagent_holder/reacting_holders_current_cycle

/datum/controller/subsystem/chemistry/Recover()
	chemical_reactions = SSchemistry.chemical_reactions
	reagent_lookup = SSchemistry.reagent_lookup
	rebuild_reaction_caches()

// honestly hate that we have to do this but some things INITIALIZE_IMMEDIATE so uh fuck me I guess!
/datum/controller/subsystem/chemistry/PreInit(recovering)
	initialize_chemical_reagents()
	initialize_chemical_reactions()
	rebuild_reaction_caches()
	return ..()

/**
 * Chemical Reactions - Initialises all /datum/chemical_reaction into a list
 * It is filtered into multiple lists within a list.
 * For example:
 * - chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
 * - Note that entries in the list are NOT duplicated. So if a reaction pertains to
 * - more than one chemical it will still only appear in only one of the sublists.
 */
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reactions()
	var/paths = subtypesof(/datum/chemical_reaction)
	chemical_reactions = list()

	for(var/datum/chemical_reaction/path as anything in paths)
		if(initial(path.abstract_type) == path)
			continue
		var/datum/chemical_reaction/D = new path
		chemical_reactions += D
	tim_sort(chemical_reactions, GLOBAL_PROC_REF(cmp_chemical_reaction_priority))

/// Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reagents()
	var/paths = subtypesof(/datum/reagent)
	reagent_lookup = list()
	for(var/datum/reagent/path as anything in paths)
		if(initial(path.abstract_type) == path)
			continue
		var/datum/reagent/D = new path()
		if(!D.name)
			continue
		reagent_lookup[D.id] = D

/**
 * this is dependent on priorities of chemical reaction list.
 */
/datum/controller/subsystem/chemistry/proc/rebuild_reaction_caches()
	chemical_reactions_relevant_for_reagent_id = list()
	for(var/datum/chemical_reaction/reaction as anything in chemical_reactions)
		for(var/id in (reaction.required_reagents | reaction.moderators | reaction.catalysts))
			LAZYINITLIST(chemical_reactions_relevant_for_reagent_id[id])
			chemical_reactions_relevant_for_reagent_id[id] |= reaction

/datum/controller/subsystem/chemistry/fire(resumed)
	if(!resumed)
		reacting_holders_current_cycle = reacting_holders.Copy()
	var/reacted_holder_count = 0
	for(var/reacted_holder_index in length(reacting_holders_current_cycle) to 1 step -1)
		var/datum/reagent_holder/holder = reacting_holders_current_cycle[reacted_holder_index]
		holder.reaction_tick(nominal_dt_s)
		reacted_holder_count++
		if(MC_TICK_CHECK)
			break
	reacting_holders_current_cycle.len -= reacted_holder_count

//* Reagents *//

/**
 * fetches the instance of a reagent
 *
 * do not edit the returned instance, it is global!
 */
/datum/controller/subsystem/chemistry/proc/fetch_reagent(datum/reagent/id_or_path)
	return reagent_lookup[ispath(id_or_path)? initial(id_or_path.id) : id_or_path]

//* Reaction Lookups *//

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_for_reagent_id(id) as /list
	return chemical_reactions_relevant_for_reagent_id[id]

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_for_reagent_ids(list/ids) as /list
	. = list()
	for(var/id in ids)
		for(var/datum/chemical_reaction/reaction as anything in chemical_reactions_relevant_for_reagent_id[id])
			.[reaction] = TRUE

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_instant_reactions_for_reagent_ids(list/ids) as /list
	. = list()
	for(var/id in ids)
		for(var/datum/chemical_reaction/reaction as anything in chemical_reactions_relevant_for_reagent_id[id])
			if(reaction.reaction_half_life)
				continue
			.[reaction] = TRUE

//* Reaction Lookups - Add *//

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_on_add_reagent_id(id) as /list
	return immutable_relevant_reactions_for_reagent_id(id)

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_on_add_reagent_ids(list/ids) as /list
	return immutable_relevant_reactions_for_reagent_ids(ids)

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_instant_reactions_on_add_reagent_ids(list/ids) as /list
	return immutable_relevant_instant_reactions_for_reagent_ids(ids)

//* Reaction Lookups - Remove *//

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_on_remove_reagent_id(id) as /list
	return immutable_relevant_reactions_for_reagent_id(id)

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_reactions_on_remove_reagent_ids(list/ids) as /list
	return immutable_relevant_reactions_for_reagent_ids(ids)

/**
 * Returned list is immutable. You must never edit it.
 *
 * todo: this is somewhat slow; maybe start inlining it?
 */
/datum/controller/subsystem/chemistry/proc/immutable_relevant_instant_reactions_on_remove_reagent_ids(list/ids) as /list
	return immutable_relevant_instant_reactions_for_reagent_ids(ids)
