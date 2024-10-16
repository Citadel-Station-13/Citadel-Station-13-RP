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
 * TODO: this should return TRUE if something changed, FALSE otherwise.
 *
 * * non canonical, e.g. A shares with B --> A shares with C != A shares with C --> A shares with B
 * * this also assumes equal weighting, e.g. 0.5 ratio means take half of us and half of them, mix it, and put it back in.
 *
 * @return TRUE if we are near-equivalent to the other, FALSE if we are still different.
 */
/datum/gas_mixture/proc/share_with_mixture(datum/gas_mixture/other, ratio)
#ifdef CF_ATMOS_XGM_DEBUG_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
#endif

	#warn prune

	var/total_group_multiplier = src.group_multiplier + other.group_multiplier
	var/total_effective_volume = src.group_multiplier * src.volume + other.group_multiplier * other.volume
	var/inverse_ratio = 1 - ratio

	// get scalers
	var/our_scaler = (src.volume * src.group_multiplier) / (total_effective_volume)
	var/their_scaler = (other.volume * other.group_multiplier) / (total_effective_volume)

	// get pre-transfer capacities
	var/our_capacity_singular = src.heat_capacity_singular()
	var/their_capacity_singular = other.heat_capacity_singular()

	// handle gas
	for(var/gas in gas | other.gas)
		var/avg_per_singular = src.gas[gas] * our_scaler + other.gas[gas] * their_scaler
		src.gas[gas] = src.gas[gas] * inverse_ratio + avg_per_singular * ratio
		other.gas[gas] = other.gas[gas] * inverse_ratio + avg_per_singular * ratio

	// handle temp

	var/our_remaining_capacity = our_capacity_singular * inverse_ratio
	var/their_remaining_capacity = their_capacity_singular * inverse_ratio

	var/total_effective_capacity = our_capacity_singular * src.group_multiplier + their_capacity_singular * other.group_multiplier
	var/average_injected_temperature = (our_capacity_singular * temperature * src.group_multiplier + their_capacity_singular * other.temperature * other.group_multiplier) / total_effective_capacity

	var/our_injected_capacity = total_effective_capacity * ratio * (src.group_multiplier / total_group_multiplier)
	var/their_injected_capacity = total_effective_capacity * ratio * (other.group_multiplier / total_group_multiplier)

	src.temperature = ((temperature * our_remaining_capacity) + (our_injected_capacity * average_injected_temperature)) / (our_remaining_capacity + our_injected_capacity)
	other.temperature = ((temperature * their_remaining_capacity) + (their_injected_capacity * average_injected_temperature)) / (their_remaining_capacity + their_injected_capacity)

	// update
	update_values()
	other.update_values()

	// return if we equalized fully
	return compare(other)

// TODO: a proc for sharing with non-equal-volume mixtures; unit test it!

/**
 * equalizes x% of our gas with an unsimulated mixture.
 *
 * ! warning: this assumes the virtual mixture is the same volume as us, for optimization
 *
 * TODO: this should return TRUE if something changed, FALSE otherwise.
 * TODO: unit test
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
#ifdef CF_ATMOS_XGM_DEBUG_ASSERTIONS
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

	temperature = ((our_thermal_energy * inverse_ratio) + (target_share_temperature * our_heat_capacity * ratio)) / our_heat_capacity
	other.temperature = ((their_thermal_energy * inverse_ratio) + (target_share_temperature * their_heat_capacity * ratio)) / their_heat_capacity

	return abs(our_old_temperature - temperature) > 0.001 || abs(their_old_temperature - other.temperature) > 0.001
