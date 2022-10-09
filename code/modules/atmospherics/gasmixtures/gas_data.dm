GLOBAL_DATUM_INIT(gas_data, /datum/gas_data, new)

/**
 * master datum holding all atmospherics gas data
 * all lists should be accessed directly for speed
 * all lists are keyed by id
 */
/datum/gas_data
	//! gas data
	/// ids; associative list to the instantiated datum
	var/list/gases = list()
	/// names
	var/list/names = list()
	/// specific heat
	var/list/specific_heats = list()
	/// molar masses
	var/list/molar_masses = list()
	/// flags
	var/list/flags = list()
	/// groups
	var/list/groups = list()

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

/datum/gas_data/proc/register_gas(datum/gas/G)

/datum/gas_data/proc/_register_gas(datum/gas/G)

#warn impl
