//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Used to share a certain temperature & heat capacity's thermal energy with us.
 *
 * * This proc returns the thermal energy change to apply to the sharer. This means if we heat up,
 *   we will return a negative amount because the sharer is cooling!
 * * If it returns 1000, 1000J was imparted onto the sharer during the share.
 * * Be very, very, very careful with this proc, as this will immediately slam
 *   into the zone for simulated turfs with no regards for area or any sanity limits.
 * * At '1' share_ratio, the sharer will be brought to the same resultant temperature as us if
 *   all of the thermal energy change is imparted back to it.
 * * share and total energy are different because a heat exchanger pipe only should ever
 *   share the thermal energy actually available in its 70 liters rather than being more
 *   powerful the bigger its parent pipeline is, but we need to hint that we're allowed to
 *   'overshoot' the actual thermal energy change (including even to below TCMB!!) if there's
 *   actually a lot more energy available to it than it's willing to share.
 *
 * @params
 * * temperature - the temperature of the sharer
 * * heat_capacity - the total specific heat of the sharer
 * * share_energy - the thermal energy able to be shared this call. this is not an absolute value,
 *                  this is the thermal energy available in the part of the sharer that's being shared.
 * * total_energy - the total thermal energy available to the sharer. this is not
 *                  always the same as limit_thermal_energy, like in pipeline situations.
 * * share_ratio - the % of temperature difference to impart on us (and reflexively to the sharer).
 *                 Be very, very careful when setting high values of this!
 * * cell_limit - the maximum effective volume in cells of the share. If we're in a zone with
 *                10 tiles and share_volume is only 2, we will at most equalize the energy
 *                in 1/5 of our zone. This is to artificially limit the effectiveness
 *                of exchanger pipes so they're not exchanging with the entire room.
 *
 * @return the thermal energy change to the sharer
 */
/turf/proc/air_thermal_superconduction(temperature, heat_capacity, share_energy, total_energy, share_ratio, cell_limit)
	// unsimulated turfs
	var/datum/gas_mixture/sharing_with_immutable = return_air_immutable()
	// as unsimulated, our heat capacity is unbounded and limited to the input cell limit
	var/our_heat_capacity = sharing_with_immutable.heat_capacity_singular() * cell_limit
	// get midpoint temperature with (our energy + their energy) / (combined capacity)
	var/midpoint_t = ((our_heat_capacity * sharing_with_immutable.temperature) + (heat_capacity * temperature)) \
		/ (our_heat_capacity + heat_capacity)
	// we can entirely skip our own temperature change as we're unsimulated, and only do theirs.
	var/their_energy_change = (midpoint_t - temperature) * heat_capacity
	return (midpoint_t - temperature) * heat_capacity




	var/delta_t = (sharing_with_immutable.temperature - temperature) * share_ratio
	var/delta_e = delta_t * heat_capacity
	if(delta_e > 0)
		return delta_e // don't need to limit it
	return clamp(
		delta_t * heat_capacity,
	)

/turf/simulated/air_thermal_superconduction(temperature, heat_capacity, share_energy, total_energy, share_ratio, cell_limit)
	var/datum/gas_mixture/sharing_with_mutable = return_air_mutable()

#warn impl all
