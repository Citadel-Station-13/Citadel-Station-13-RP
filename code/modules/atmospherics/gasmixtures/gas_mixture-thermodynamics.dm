//-----------------------------------------------------------------------------//
/**
 * Thermodynamics Helpers
 */
//-----------------------------------------------------------------------------//

/**
 * Returns the heat capacity of the gas mix based on the specific heat of the gases and their moles.
 *
 * * Takes group_multiplier into account.
 *
 * @return our heat capacity in J/K
 */
/datum/gas_mixture/proc/heat_capacity()
	. = 0
	for(var/g in gas)
		. += global.gas_data.specific_heats[g] * gas[g]
	. *= group_multiplier

/**
 * Returns the heat capacity of the gas mix based on the specific heat of the gases and their moles.
 *
 * * Does not take group_multiplier into account.
 *
 * @return our heat capacity in J/K
 */
/datum/gas_mixture/proc/heat_capacity_singular()
	. = 0
	for(var/g in gas)
		. += global.gas_data.specific_heats[g] * gas[g]

/**
 * returns the specific heat per mol of gas mix
 *
 * * does not take group multiplier into account.
 * * this exists to not have overly large numbers in critical areas where precision matters
 * * you must have already called update_values() beforehand!
 *
 * @return J/K*mol; energy in joules input to heat this mixture by one degree for every mol this mixture has.
 */
/datum/gas_mixture/proc/specific_heat()
#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	ASSERT(gas ~= debug_gas_archive)
#endif
	. = 0
	for(var/id in gas)
		. += global.gas_data.specific_heats[id] * (gas[id] / total_moles)

/**
 * Adjusts thermal energy in joules.
 *
 * * Takes group_multiplier into account.
 *
 * @return Joules actually changed, as we cannot go below TCMB.
 */
/datum/gas_mixture/proc/adjust_thermal_energy(joules)
	if(!total_moles)
		return 0
	var/capacity = heat_capacity()
	if(joules < 0)
		joules = max(joules, -(temperature - TCMB) * capacity)
	temperature += joules / capacity
	return joules

/**
 * Gets thermal energy change to get to a specific temperature.
 *
 * * Takes group_multiplier into account.
 * * Cannot go below TCMB.
 *
 * @return Thermal energy change needed in Joules (J) to get to a certain temperature.
 */
/datum/gas_mixture/proc/get_thermal_energy_change(target)
	return heat_capacity() * (max(target, TCMB) - temperature)

/**
 * Gets thermal energy change to get to a specific temperature.
 *
 * * Does not take group_multiplier into account.
 * * Cannot go below TCMB.
 *
 * @return Thermal energy change needed in Joules (J) to get to a certain temperature.
 */
/datum/gas_mixture/proc/get_thermal_energy_change_singular(target)
	return heat_capacity_singular() * (max(target, TCMB) - temperature)
