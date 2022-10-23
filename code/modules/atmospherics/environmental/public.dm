// when writing atmos machinery, prefer using these procs
// this lets us somewhat separate API from implemenetation of the environmental module.
// a lot of things are on atom instead, since stuff like breathing should work with inside, say, bluespace bodybags.
// these procs should *all* be agnostic to whether we're using tile or zone atmos
// 		* this means, that, things like return_air() will never be in this, because return_air() must return a mutable mixture
//      	and doing that is dangerous other than for machines that check volume, etc.
//			instead, we will have things like copy_cell_volume(), remove_cell_volume(), which are immutable but are agnostic
//      * procs in here are by that mentality, babyproofed.
//		* by no means are things like return_air() banned - they're just unpreferred because then changes to environmental
//			will affect how machines work.

/**
 * merges all gases from giver into us
 * giver is untouched
 */
/atom/proc/assume_air(datum/gas_mixture/giver)
	return_air()?.merge(giver)

/**
 * spawns air from a gas string
 * this is a turf proc because i want people to understand what they're doing instead of blindly using it,
 * as return_air() has many different connotations
 */
/turf/proc/spawn_air(gas_string)
	var/datum/gas_mixture/G = new
	G.parse_gas_string(gas_string)
	assume_air(G)

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
	return return_air()?.remove(moles)

/**
 * removes a gas mixture of x volume
 */
/atom/proc/remove_volume(liters)
	RETURN_TYPE(/datum/gas_mixture)
	return return_air()?.remove_volume(liters)

/**
 * add/remove thermal energy from air
 */
/atom/proc/adjust_thermal_energy(joules)
	return return_air()?.adjust_thermal_energy(joules)

/**
 * get thermal energy needed for our air to be x temperature
 */
/atom/proc/get_thermal_energy_change(target_temperature)
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
	return return_air()?.return_pressure()

/**
 * gets a **copy** (read: changing this won't affect turf) of a cell volume's worth of air
 */
/atom/proc/copy_cell_volume()
	RETURN_TYPE(/datum/gas_mixture)
	return return_air().copy_single_tile()

/**
 * return temperature of air
 */
/atom/proc/return_temperature()
	return return_air()?.temperature

/**
 * gets moles of gas in a single turf's worth of air
 * inefficient; use copy_cell_volume() if you're getting more than 2-3 gases!
 */
/atom/proc/get_cell_moles(gasid)
	return copy_cell_volume()?.gas[gasid]

/**
 * gets full gas list of all gases in a single turf's worth of air
 */
/atom/proc/get_cell_gases()
	return copy_cell_volume()?.gas.Copy()
