//-----------------------------------------------------------------------------//
/**
 * Hooks for environmental systems to manipualte their gas mixtures.
 *
 * This is currently for ZAS.
 * This probably only makes sense on ZAS, because proc overhead from these existing on ZAS isn't a huge deal.
 */
//-----------------------------------------------------------------------------//

/**
 * Default share gas implementation - shares with another gas_mixture non-canonically
 * based on connecting tiles. Is just a wrapper to use a lookup table.
 */
/datum/gas_mixture/proc/environmental_share_simulated(datum/gas_mixture/other, tiles)
#ifdef CF_ATMOS_XGM_DEBUG_ASSERTIONS
	ASSERT(tiles > 0)
#endif
	var/static/list/lookup_table = list(
		0.3,
		0.4,
		0.48,
		0.54,
		0.6,
		0.66
	)
	if(tiles <= 0)
		CRASH("sharing with tiles < 0 is a waste of time")
	return share_with_mixture(other, lookup_table[min(tiles, 6)])

/**
 * default implementation to equalize with an unsimulated space
 * by default, this will ramp up equalization to match our room, so we can't
 * overpower say, 1 tile of unsimulated with a massive room.
 */
/datum/gas_mixture/proc/environmental_share_unsimulated(datum/gas_mixture/unsimulated)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	var/computed_multiplier = max(group_multiplier, unsimulated.group_multiplier)
	return share_with_immutable(unsimulated.gas, computed_multiplier, unsimulated.temperature, sharing_lookup_table[min(unsimulated.group_multiplier, 6)])

/**
 * equalize with another mixture
 *
 * * both mixtures must be simulated / non-immutable
 */
/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_MOLES_TO_DISSIPATE)
		gas.Cut()
		sharer.gas.Cut()

	for(var/g in gas|sharer.gas)
		var/comb = gas[g] + sharer.gas[g]
		comb /= volume + sharer.volume
		gas[g] = comb * volume
		sharer.gas[g] = comb * sharer.volume

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	update_values()
	sharer.update_values()

	return 1
