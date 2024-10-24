/**
 * Checks if we are within acceptable like-ness of another gasmixture to suspend processing or merge.
 *
 * @return TRUE if we are equal enough, otherwise FALSE
 */
/datum/gas_mixture/proc/compare(datum/gas_mixture/sample, var/vacuum_exception = 0)
	if(!sample)
		return FALSE

	// check vacuum exception bullshit
	if(vacuum_exception && ((!total_moles) ^ (!sample.total_moles)))
		return FALSE

	// check temperature
	if(abs(temperature - sample.temperature) >= MINIMUM_MEANINGFUL_TEMPERATURE_DELTA)
		return FALSE

	// check moles
	for(var/id in gas)
		if(abs(gas[id] - sample.gas[id]) >= MINIMUM_MEANINGFUL_MOLES_DELTA)
			return FALSE

	// check pressure
	return abs(return_pressure() - sample.return_pressure()) < MINIMUM_MEANINGFUL_PRESSURE_DELTA

/**
 * Checks if we are within acceptable like-ness of a description of a gasmixture to suspend processing or merge.
 *
 * @return TRUE if we are equal enough, otherwise FALSE
 */
/datum/gas_mixture/proc/compare_virtual(list/gases, volume, temperature)
	// check temperature
	if(abs(src.temperature - temperature) > MINIMUM_MEANINGFUL_TEMPERATURE_DELTA)
		return FALSE

	// check moles
	for(var/id in gas)
		if(abs(gases[id] - gas[id]) > MINIMUM_MEANINGFUL_MOLES_DELTA)
			return FALSE

	// check pressure
	var/their_pressure = 0
	for(var/id in gases)
		their_pressure += gases[id]
	their_pressure = (their_pressure * R_IDEAL_GAS_EQUATION * temperature) / volume
	return abs(return_pressure() - their_pressure) < MINIMUM_MEANINGFUL_PRESSURE_DELTA
