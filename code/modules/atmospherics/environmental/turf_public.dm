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
	CRASH("How was /area reached?")

/turf/remove_moles(moles)
	RETURN_TYPE(/datum/gas_mixture)
	return return_air()?.remove(moles)

/**
 * removes a gas mixture of x volume
 */
/atom/proc/remove_volume(liters)
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.remove_volume(liters)

/area/remove_volume(liters)
	CRASH("How was /area reached?")

/turf/remove_volume(liters)
	RETURN_TYPE(/datum/gas_mixture)
	return return_air()?.remove_volume(liters)

/**
 * add/remove thermal energy from air
 */
/atom/proc/add_thermal_energy(joules)
	return loc?.add_thermal_energy(joules)

/area/add_thermal_energy(joules)
	CRASH("How was /area reached?")

/turf/add_thermal_energy(joules)
	return_air().add_thermal_energy(joules)

/**
 * get thermal energy needed for our air to be x temperature
 */
/atom/proc/get_thermal_energy_change(target_temperature)
	return loc?.get_thermal_energy_change(target_temperature)

/area/get_thermal_energy_change(target_temperature)
	CRASH("How was /area reached?")

/turf/get_thermal_energy_change(target_temperature)
	return return_air()?.get_thermal_energy_change(target_temperature) || 0

/**
 * remove CELL_VOLUME's worth of air
 */
/atom/proc/remove_cell_volume()
	RETURN_TYPE(/datum/gas_mixture)
	return remove_volume(CELL_VOLUME)

/**
 * remove a multiple of CELL_VOLUME's worth of air
 */
/atom/proc/remove_cell_volumes(multiplier = 1)
	RETURN_TYPE(/datum/gas_mixture)
	return remove_volume(CELL_VOLUME * multiplier)

/**
 * return pressure of air
 */
/atom/proc/return_pressure()
	return loc?.return_pressure()

/area/return_pressure()
	CRASH("How was /area reached?")

/turf/return_pressure()
	return return_air().return_pressure()

/**
 * gets a **copy** (read: changing this won't affect turf) of a cell volume's worth of air
 */
/atom/proc/copy_cell_volume()
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.copy_cell_volume()

/area/copy_cell_volume()
	CRASH("How was /area reached?")

/turf/copy_cell_volume()
	return return_air().get_single_tile()

/**
 * return temperature of air
 */
/atom/proc/return_temperature()
	return loc?.return_temperature()

/area/return_tempreature()
	CRASH("How was /area reacheD?")

/turf/return_temperature()
	return return_air().temperature
