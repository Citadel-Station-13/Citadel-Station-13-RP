GLOBAL_REAL(gas_data, /datum/gas_data)

/**
 * master datum holding all atmospherics gas data
 * all lists should be accessed directly for speed
 * all lists are keyed by id
 */
/datum/gas_data
	//! gas data
	//? intrinsics
	/// ids; associative list to the instantiated datum
	var/list/gases = list()
	/// names
	var/list/names = list()
	/// flags
	var/list/flags = list()
	/// groups
	var/list/groups = list()
	//? physics
	/// specific heat
	var/list/specific_heats = list()
	/// molar masses
	var/list/molar_masses = list()
	//? reagents
	/// reagents: id = (reagentid, base amount, minimum moles, mole factor, max amount)
	/// this is a sparse lookup, not all gases are in here.
	var/list/reagents = list()
	//? visuals
	#warn wip lmao visuals need slight rework
	//? reactions
	var/list/rarities = list()

	//! gas cache lists
	/// list of lists of gas ids by flag
	var/list/gas_by_flag = list()
	/// list of lists of gas ids by group
	var/list/gas_by_group = list()

	//! global data
	/// next random gas id
	var/static/next_procedural_gas_id = 0

/datum/gas_data/New()
	#warn register hardcoded gas datums

/datum/gas_data/proc/rebuild_caches()

/datum/gas_data/proc/build_hardcoded()

#warn impl

/datum/gas_data/proc/register_gas(datum/gas/G)
	ASSERT(G.id)
	ASSERT(!gases[G.id])
	_register_gas(G)

/datum/gas_data/proc/_register_gas(datum/gas/G)
	//? intrinsics
	gases[G.id] = G
	names[G.id] = G.name
	flags[G.id] = G.gas_flags
	groups[G.id] = G.gas_groups
	//? physics
	specific_heats[G.id] = G.specific_heat
	molar_masses[G.id] = G.molar_mass
	//? reagents
	if(G.gas_reagent_id)
		reagents[G.id] = list(
			G.gas_reagent_id,
			G.gas_reagent_amount,
			G.gas_reagent_threshold
			G.gas_reagent_factor,
			G.gas_reagent_max
		)
	else
		reagents -= G.id
	//? visuals
	//? reactions
	rarities[G.id] = G.rarity
	//? rebuild cheap cache lists
	//* gas groups
	LAZYINITLIST(gas_by_group[G.gas_group])
	LAZYOR(gas_by_group[G.gas_group], G.id)
	//* gas flags
	for(var/bit in bitfield2list(G.gas_flags))
		LAZYINITLIST(gas_by_flag, "[bit]")
		LAZYOR(gas_flags["[bit]"], G.id)
