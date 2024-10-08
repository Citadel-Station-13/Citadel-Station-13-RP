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
	// simulated mixtures
	// the trick is the rest of this proc works regardless of if we're in a zone or not,
	// because we're using group multiplier manually with cell unit
	var/datum/gas_mixture/sharing_with_mutable = return_air_mutable()
	// this is with group multiplier taken into account
	var/our_heat_capacity = sharing_with_mutable.heat_capacity_singular() * min(cell_limit, sharing_with_mutable.group_multiplier)
	// limit ratio is applied here,
	// it basically makes the sharer act like it's smaller than it actually is,
	// which makes us undershoot
	var/midpoint_t = ((our_heat_capacity * sharing_with_mutable.temperature) + (heat_capacity * temperature * limit_ratio)) / (heat_capacity * limit_ratio + our_heat_capacity)
	// equalize ratio is a delta-energy modifier
	// we don't want equalize ratio to affect target temperature, we only want it to affect transfer efficiency
	var/delta_e_to_them = (midpoint_t - temperature) * heat_capacity * equalize_ratio
	// impart temperature change on both
	temperature += -delta_e_to_them / our_heat_capacity
	return delta_e_to_them / heat_capacity
