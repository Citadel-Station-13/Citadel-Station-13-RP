PROCESSING_SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 10
	subsystem_flags = SS_BACKGROUND|SS_POST_FIRE_TIMING
	init_order = INIT_ORDER_CHEMISTRY

	/// id to instance dict of reagents
	var/list/reagent_lookup = list()

	var/list/chemical_reactions = list()
	var/list/chemical_reactions_by_reagent = list()


/datum/controller/subsystem/processing/chemistry/Recover()
	chemical_reactions = SSchemistry.chemical_reactions
	reagent_lookup = SSchemistry.reagent_lookup

// honestly hate that we have to do this but some things INITIALIZE_IMMEDIATE so uh fuck me I guess!
/datum/controller/subsystem/processing/chemistry/PreInit(recovering)
	initialize_chemical_reactions()
	initialize_chemical_reagents()
	return ..()

/**
 * Chemical Reactions - Initialises all /datum/chemical_reaction into a list
 * It is filtered into multiple lists within a list.
 * For example:
 * - chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
 * - Note that entries in the list are NOT duplicated. So if a reaction pertains to
 * - more than one chemical it will still only appear in only one of the sublists.
 */
/datum/controller/subsystem/processing/chemistry/proc/initialize_chemical_reactions()
	var/paths = subtypesof(/datum/chemical_reaction)
	chemical_reactions = list()
	chemical_reactions_by_reagent = list()

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path
		chemical_reactions += D
	tim_sort(chemical_reactions, GLOBAL_PROC_REF(chemical_reaction_priority))
	for(var/datum/chemical_reaction/D as anything in chemical_reactions)
		if(!length(D.required_reagents))
			continue
		var/reagent_id = D.required_reagents[1]
		LAZYINITLIST(chemical_reactions_by_reagent[reagent_id])
		chemical_reactions_by_reagent[reagent_id] += D

/// Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/processing/chemistry/proc/initialize_chemical_reagents()
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
 * fetches the instance of a reagent
 *
 * do not edit the returned instance, it is global!
 */
/datum/controller/subsystem/processing/chemistry/proc/get_reagent(datum/reagent/id_or_path)
	return reagent_lookup[ispath(id_or_path)? initial(id_or_path.id) : id_or_path]
