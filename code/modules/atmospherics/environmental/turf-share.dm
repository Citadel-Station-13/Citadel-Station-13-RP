//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Used to share a certain temperature & heat capacity's thermal energy with us.
 *
 * * This proc returns the thermal energy change to apply to the sharer.
 * * If it returns 1000, 1000J was imparted onto the sharer during the share.
 * * Be very, very, very careful with this proc, as this will immediately slam
 *   into the zone for simulated turfs with no regards for area or any sanity limits.
 *
 * @params
 * * temperature - the temperature of the sharer
 * * heat_capacity - the heat capacity of the sharer
 * * share_ratio - the % of temperature difference to impart on us (and reflexively to the sharer).
 *                 Be very, very careful when setting high values of this!
 *
 * @return the thermal energy change to the sharer
 */
/turf/proc/air_thermal_superconduction(temperature, heat_capacity, share_ratio)
	return 0

/turf/simulated/air_thermal_superconduction(temperature, heat_capacity, share_ratio)
	var/datum/gas_mixture/sharing_with_mutable = return_air_mutable()

/turf/unsimulated/air_thermal_superconduction(temperature, heat_capacity, share_ratio)
	var/datum/gas_mixture/sharing_with_immutable = return_air_immutable()


#warn impl all
