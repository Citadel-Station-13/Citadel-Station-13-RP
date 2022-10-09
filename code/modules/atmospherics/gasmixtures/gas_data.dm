GLOBAL_DATUM_INIT(gas_data, /datum/gas_data, new)

/**
 * master datum holding all atmospherics gas data
 * all lists should be accessed directly for speed
 * all lists are keyed by id
 */
/datum/gas_data
	//! gas data
	/// ids; associative list to the instantiated datum
	var/list/gases
	/// names
	var/list/names
	/// specific heat
	var/list/specific_heats
	/// molar masses
	var/list/molar_masses
	/// flags
	var/list/gas_flags

	//! gas cache lists
	/// list of lists of gas ids by flag
	var/list/gas_by_flag
	///

	//! global data
	/// next random gas id
	var/static/next_procedural_gas_id = 0


#warn impl
