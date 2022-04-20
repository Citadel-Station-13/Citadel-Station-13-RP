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
