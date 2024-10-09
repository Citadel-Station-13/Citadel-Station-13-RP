//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Used to share a certain temperature & heat capacity's thermal energy with us.
 *
 * * This proc returns the temperature change to apply to the sharer. This means if we heat up,
 *   we will return a negative amount because the sharer is cooling!
 * * If it returns 10, 10 degrees K was imparted onto the sharer during the share.
 * * You can get thermal energy given / taken by multiplying the return with the heat capacity you passed in.
 * * Be very, very, very careful with this proc, as this will immediately slam
 *   into the zone for simulated turfs with no regards for area or any sanity limits.
 * * At '1' share_ratio, the sharer will be brought to the same resultant temperature as us if
 *   all of the thermal energy change is imparted back to it.
 * * limit_ratio is provided so you can limit the amount of energy transferred to a single segment
 *   of say, a heat exchanging pipeline, as while the entire pipeline has a lot of heat capacity,
 *   an individual pipe segment does not.
	// * someone please help do the algebra and see equalize_ratio and limit_ratio aren't just able to be collapsed into one term
 *
 * @params
 * * temperature - the temperature of the sharer
 * * heat_capacity - the specific heat of the sharer in J / K
 * * limit_ratio - a multiplier for the part of 'heat_capacity' that can be drawn from / added to this tick.
 * * equalize_ratio - a limit to delta-energy; 0.5 means only transfer up to 50% of the energy needed to equalize.
 *                 Be very, very careful when setting high values of this!
 * * cell_limit - the maximum effective volume in cells of the share. If we're in a zone with
 *                10 tiles and share_volume is only 2, we will at most equalize the energy
 *                in 1/5 of our zone. This is to artificially limit the effectiveness
 *                of exchanger pipes so they're not exchanging with the entire room.
 *
 * @return the temperature change to the sharer
 */
/turf/proc/air_thermal_superconduction(temperature, heat_capacity, limit_ratio, equalize_ratio, cell_limit)
	#warn fix
	// unsimulated mixtures
	var/datum/gas_mixture/sharing_with_immutable = return_air_immutable()
	var/midpoint_t
	var/our_heat_capacity = sharing_with_immutable.heat_capacity_singular()
	// to avoid precision issues, we divide their capacity by cell limit instead of expand our capacity.
	midpoint_t = ((our_heat_capacity * sharing_with_immutable.temperature) + ((heat_capacity / cell_limit) * temperature)) \
		/ (our_heat_capacity + (heat_capacity / cell_limit))
	// if this was an actual simulated turf, we'd need to calculate the change
	// with equalize ratio, and then limit it with limit ratio
	//
	// since this is unsimulated, limit ratio is effectively just a secondary
	// equalize ratio, as the total temperature change is tempered by the
	// limit ratio limiting the availability of thermal energy to effect that change
	// (we don't change but the opposite & equal change to the sharer still happens)
	return (midpoint_t - temperature) * equalize_ratio * limit_ratio

/turf/simulated/air_thermal_superconduction(temperature, heat_capacity, limit_ratio, equalize_ratio, cell_limit)
	#warn fix
	// simulated mixtures
	// the trick is the rest of this proc works regardless of if we're in a zone or not,
	// because we're using group multiplier manually with cell unit
	var/datum/gas_mixture/sharing_with_mutable = return_air_mutable()
	// don't grab full heat capacity, that's a floating point precision issue
	var/our_singular_heat_capacity = sharing_with_mutable.heat_capacity_singular()
	// instead, just get how much bigger than a single tile we *should* be
	var/our_size_multiplier = min(sharing_with_mutable.group_multiplier, cell_limit)
	// and divide it out of their heat capacity,
	// effectively making us relatively bigger than them
	// also apply limit ratio here to make them even smaller than they are
	var/their_effective_capacity = (heat_capacity / our_size_multiplier) * limit_ratio
	// get the temperature 'goal'
	var/midpoint_t = ((our_singular_heat_capacity * sharing_with_mutable.temperature) + (their_effective_capacity * temperature)) / (their_effective_capacity + our_singular_heat_capacity)
	// equalize ratio is a delta-energy modifier
	// we don't want equalize ratio to affect the 'true' target temperature,
	// only how much is actually transferred
	// we also don't want to not multiply full energy transfer because it'll get precision issues
	var/temperature_change_to_them = (midpoint_t - temperature) * equalize_ratio
	// impart temperature change on us
	sharing_with_mutable.temperature += (-temperature_change_to_them * (their_effective_capacity / our_singular_heat_capacity)) / our_size_multiplier
	// return temperature change to them
	return temperature_change_to_them * (their_effective_capacity / heat_capacity)
