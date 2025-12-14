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
 * * you must have already called update_values() on both mixtures!
 *
 * @return TRUE if we are near-equivalent to the other, FALSE if we are still different.
 */
/datum/gas_mixture/proc/share_with_mixture(datum/gas_mixture/other, ratio)
#ifdef CF_ATMOS_XGM_DEBUG_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
#endif
#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	if(!(gas ~= debug_gas_archive))
		stack_trace("gas did not match archive, [json_encode(gas)] vs archived [json_encode(debug_gas_archive)]")
#endif
	// if both of us are empty, bail or division by zero's happen later
	// this proc can handle up to one empty mixture after this check, as this check
	// throws out cases of two empty mixtures
	if(!total_moles && !other.total_moles)
		return

	// tally total group multiplier & volume for further processing
	var/total_effective_volume = src.group_multiplier * src.volume + other.group_multiplier * other.volume

	// get ratio of how much will remain
	var/inverse_ratio = 1 - ratio

	// get ratio of mixture to full volume
	// this does not take group multiplier into account due to thermodynamics calculations later
	var/our_proportion = (src.volume * src.group_multiplier) / (total_effective_volume)
	var/their_proportion = (other.volume * other.group_multiplier) / (total_effective_volume)

	// handle gas & tally heat@m
	var/our_specific_heat = 0
	var/their_specific_heat = 0
	for(var/gas in (src.gas | other.gas))
		// cache existing
		var/mol_existing_A = src.gas[gas]
		var/mol_existing_B = other.gas[gas]
		// tally specific heat while we're at it to save a proccall and more iteration
		var/specific_heat = global.gas_data.specific_heats[gas]
		// if we're empty, we have no specific heat
		if(src.total_moles)
			our_specific_heat += (specific_heat * mol_existing_A) / src.total_moles
		// if they're empty, they have no specific heat
		if(other.total_moles)
			their_specific_heat += (specific_heat * mol_existing_B) / other.total_moles
		// combine both, calculate the amount actualyl being shared, then split to to each by volume
		// need to divide out group multiplier too, as volume takes that into account
		var/combined = (mol_existing_A * src.group_multiplier + mol_existing_B * other.group_multiplier) * ratio
		src.gas[gas] = mol_existing_A * inverse_ratio + (combined * our_proportion) / src.group_multiplier
		other.gas[gas] = mol_existing_B * inverse_ratio + (combined * their_proportion) / other.group_multiplier

	// handle temp
	var/our_heat_capacity = our_specific_heat * src.total_moles * src.group_multiplier
	var/their_heat_capacity = their_specific_heat * other.total_moles * other.group_multiplier
	var/total_heat_capacity = our_heat_capacity + their_heat_capacity
	var/total_energy = our_specific_heat * src.temperature * src.total_moles * src.group_multiplier + their_specific_heat * other.temperature * other.total_moles * other.group_multiplier
	var/total_shared_capacity = total_heat_capacity * ratio
	var/average_temperature = total_energy / total_heat_capacity

	var/our_remaining_capacity = our_heat_capacity * inverse_ratio
	var/their_remaining_capacity = their_heat_capacity * inverse_ratio

	var/our_injected_capacity = total_shared_capacity * our_proportion
	var/our_new_capacity = our_injected_capacity + our_remaining_capacity

	var/their_injected_capacity = total_shared_capacity * their_proportion
	var/their_new_capacity = their_injected_capacity + their_remaining_capacity

	src.temperature = src.temperature * (our_remaining_capacity / our_new_capacity) + average_temperature * (our_injected_capacity / our_new_capacity)
	other.temperature = other.temperature * (their_remaining_capacity / their_new_capacity) + average_temperature * (their_injected_capacity / their_new_capacity)

	// update
	src.update_values()
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

	// update
	update_values()

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
