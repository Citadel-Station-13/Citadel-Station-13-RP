//-----------------------------------------------------------------------------//
/**
 * Sharing - pretty much just a fancy name for 'mix with this other mixture'.
 *
 * This 'other mixture' is able to be a real mixture, or an immutable descriptor of a mixture
 * that we equalize with for things like planetary atmos.
 */
//-----------------------------------------------------------------------------//

/**
 * Shares a ratio of the combined gas of two gas mixtures
 *
 * todo: this should return TRUE if something changed, FALSE otherwise.
 *
 * * non canonical, e.g. A shares with B --> A shares with C != A shares with C --> A shares with B
 * * this also assumes equal weighting, e.g. 0.5 ratio means take half of us and half of them, mix it, and put it back in.
 *
 * @return TRUE if we are near-equivalent to the other, FALSE if we are still different.
 */
/datum/gas_mixture/proc/share_with_mixture(datum/gas_mixture/other, ratio)
#ifdef CF_ATMOS_DEBUG_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
	// todo: volume based, not group multiplier based. is it worth it?
	ASSERT(volume == other.volume)
#endif
	// collect
	var/list/their_gas = other.gas
	var/list/our_gas = gas

	var/our_size = src.group_multiplier
	var/their_size = other.group_multiplier
	var/total_size = our_size + their_size

	var/our_capacity = heat_capacity()
	var/their_capacity = heat_capacity()

	// compute
	var/list/avg_gas = list()
	for(var/id in our_gas)
		avg_gas[id] += our_gas[id] * our_size

	for(var/id in their_gas)
		avg_gas[id] += their_gas[id] * their_size

	for(var/id in avg_gas)
		avg_gas[id] /= total_size

	// equalize
	var/intact_ratio = 1 - ratio
	var/avg_amt
	for(var/id in avg_gas)
		// set moles by ratio
		// lists are cached, so directly set
		avg_amt = avg_gas[id]
		// i don't know what these do but they work (probably)
		our_gas[id] = (our_gas[id] - avg_amt) * intact_ratio + avg_amt
		their_gas[id] = (their_gas[id] - avg_amt) * intact_ratio + avg_amt

	// update
	update_values()
	other.update_values()

	// if empty
	if(!total_moles)
		return compare(other)

	// thermodynamics:
	// i don't know what these do but they work (probably)
	var/avg_temperature = (temperature * our_capacity + other.temperature * their_capacity) / (our_capacity + their_capacity)
	temperature = (temperature - avg_temperature) * intact_ratio + avg_temperature
	other.temperature = (other.temperature - avg_temperature) * intact_ratio + avg_temperature

	// return if we equalized fully
	return compare(other)

/**
 * equalizes x% of our gas with an unsimulated mixture.
 *
 * ! warning: this assumes the virtual mixture is the same volume as us, for optimization
 *
 * todo: this should return TRUE if something changed, FALSE otherwise.
 *
 * @params
 * - gases - gases of the other mixture
 * - group_multiplier - how big the other mixture is pretending to be
 * - temperature - how hot the other mixture is
 * - ratio - how much of the **total** mixture will be equalized
 *
 * @return TRUE if we are near-equivalent to the other, FALSE if we are still different.
 */
/datum/gas_mixture/proc/share_with_immutable(list/gases, group_multiplier, temperature, ratio)
#ifdef CF_ATMOS_DEBUG_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
	ASSERT(temperature >= TCMB)
	ASSERT(group_multiplier >= 1)
#endif
	// let's not break the input list
	//! IF YOU DO NOT KNOW WHY WE ARE COPYING, DO NOT TAKE THIS OUT.
	gases = gases.Copy()
	// collect
	var/list/our_gas = gas
	var/our_capacity = heat_capacity()

	// compute
	var/their_capacity = 0
	for(var/id in gases)
		// in the same loop, we'll calculate their total capacity, at the same time expanding their moles to the true value
		their_capacity += global.gas_data.specific_heats[id] * gases[id] * group_multiplier
		gases[id] *= group_multiplier

	for(var/id in our_gas)
		// now add ours
		gases[id] += our_gas[id] * src.group_multiplier

	for(var/id in gases)
		// now shrink to the average
		gases[id] /= (src.group_multiplier + group_multiplier)

	// update
	update_values()

	if(!total_moles)
		return compare_virtual(gases, src.volume, temperature)

	// calculate avg temperature
	var/avg_temperature = (src.temperature * our_capacity + temperature * their_capacity) / (our_capacity + their_capacity)

	// equalize
	var/intact_ratio = 1 - ratio
	var/avg_amt
	for(var/id in gases)
		// set moles by ratio
		// lists are cached, so directly set
		avg_amt = gases[id]
		// i don't know what these do but they work (probably)
		our_gas[id] = (our_gas[id] - avg_amt) * intact_ratio + avg_amt

	// thermodynamics:
	// i don't know what these do but they work (probably)
	src.temperature = (src.temperature - avg_temperature) * intact_ratio + avg_temperature

	// return if we equalized fully
	return compare_virtual(gases, src.volume, temperature)

/**
 * Share heat with another gasmixture.
 *
 * * Unweighted. 0.5 means take half of our mixture, half of their mixture, and equalize temperature between those parts.
 * * Takes into account group multiplier. Does not allow limiting to a specific volume of such mixtures at this time.
 *
 * @return TRUE if the share did anything significant.
 */
/datum/gas_mixture/proc/share_heat_with_mixture(datum/gas_mixture/other, ratio)
	if(!total_moles || !other.total_moles)
		return TRUE

	var/our_heat_capacity = heat_capacity()
	var/their_heat_capacity = other.heat_capacity()
	var/combined_heat_capacity = our_heat_capacity + their_heat_capacity

	var/our_old_temperature = temperature
	var/their_old_temperature = other.temperature

	var/our_thermal_energy = our_heat_capacity * temperature
	var/their_thermal_energy = their_heat_capacity * other.temperature

	var/combined_share_energy = our_thermal_energy * ratio + their_thermal_energy * ratio
	var/target_share_temperature = combined_share_energy / (combined_heat_capacity * ratio)
	var/inverse_ratio = 1 - ratio

	// tl;dr
	// 1. keep the parts of energy that isn't being shared
	// 2. divide the combined share energy down half, giving each half of it to the part of the mixture being shared
	// 3. combine the two sets of energy for the two mixtures to get the two new temperatures.
	temperature = ((our_thermal_energy * inverse_ratio) + (target_share_temperature * our_heat_capacity * ratio)) / our_heat_capacity
	other.temperature = ((their_thermal_energy * inverse_ratio) + (target_share_temperature * their_heat_capacity * ratio)) / their_heat_capacity

	return abs(our_old_temperature - temperature) > 0.001 || abs(their_old_temperature - other.temperature) > 0.001
	#warn test
