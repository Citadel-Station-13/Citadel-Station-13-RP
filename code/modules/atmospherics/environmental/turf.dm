// everything relating to turfs for atmospherics - environmental
/turf
	/// our air mixture, if any - this refers **just** to ours, not our zone.
	var/datum/gas_mixture/air

/**
 * returns a mutable gas mixture, or null
 * this does not take into account volume, and for ZAS, can return a whole room's air
 * for operations that care about this, prefer using other procs!
 */
/atom/proc/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.return_air()

/area/return_air()
	CRASH("How was /area reached?")

/turf/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	//Create gas mixture to hold data for passing
	var/datum/gas_mixture/GM = new
	GM.copy_from_turf(src)
	return GM

// ATMOS_TODO: remove /unsimulated
/turf/simulated/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	if(zone)
		if(!zone.invalid)
			air_master.mark_zone_update(zone)
			return zone.air
		else
			if(!air)
				make_air()
			c_copy_air()
			return air
	else
		if(!air)
			make_air()
		return air
