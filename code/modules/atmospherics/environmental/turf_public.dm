// when writing atmos machinery, prefer using these procs
// this lets us somewhat separate API from implemenetation of the environmental module.
// a lot of things are on atom instead, since stuff like breathing should work with inside, say, bluespace bodybags.

/**
 * merges all gases from giver into us
 * giver is untouched
 */
/atom/proc/assume_air(datum/gas_mixture/giver)
	return_air()?.merge(giver)

/**
 * adds x moles of a specific gasid at y temperature
 * for mass adds, use assume_air with a mixture instead for performance.
 */
/atom/proc/assume_gas(gasid, moles, temp)
	if(isnull(temp))
		return_air()?.adjust_gas(gasid, moles)
	else
		return_air()?.adjust_gas_temp(gasid, moles, temp)

/**
 * removes a gas mixture of x moles
 */
/atom/proc/remove_moles(moles)
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.remove_moles(moles)

/area/remove_moles(moles)
	return

/turf/remove_moles(moles)
	return return_air()?.remove(moles)

/**
 * removes a gas mixture of x volume
 */
/atom/proc/remove_volume(liters)
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.remove_volume(liters)

/area/remove_volume(liters)
	return

/turf/remove_volume(liters)
	return return_air()?.remove_volume(liters)

/**
 * removes a gas mixture of a ratio from 0 to 1
 */
/atom/proc/remove_ratio(ratio)
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.remove_air_ratio(ratio)

/area/remove_ratio(ratio)
	return

/turf/remove_ratio(ratio)
	return return_air()?.remove_ratio(ratio)

/**
 * add/remove thermal energy from air
 */
/atom/proc/add_thermal_energy(joules)
	return loc?.add_thermal_energy(joules)

/area/add_thermal_energy(joules)
	return

/turf/add_thermal_energy(joules)
	return_air().add_thermal_energy(joules)

/**
 * get thermal energy needed for our air to be x temperature
 */
/atom/proc/get_thermal_energy_change(target_temperature)
	return loc?.get_thermal_energy_change(target_temperature)

/area/get_thermal_energy_change(target_temperature)
	return

/turf/get_thermal_energy_change(target_temperature)
	return return_air()?.get_thermal_energy_change(target_temperature) || 0
