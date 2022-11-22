// everything relating to turfs for atmospherics - environmental
/turf
	CanAtmosPass = ATMOS_PASS_PROC
	CanAtmosPassVertical = ATMOS_PASS_PROC
	/// our air mixture, if any - this refers **just** to ours, not our zone.
	var/datum/gas_mixture/air
#ifdef ZAS_BREAKPOINT_HOOKS
	/// verbosity for zas debugging
	var/zas_verbose = FALSE
#endif

/**
 * semantically means "we can pass to them", not "they can pass to us"
 * use CheckAirBlock instead
 */
/turf/CanAtmosPass(turf/T, d)
	if(blocks_air)
		return ATMOS_PASS_AIR_BLOCKED
	if(T == src)
		//! warning: this does break some ZAS functionality but honestly blocking self to self is a stupid and expensive concept to maintain.
		return ATMOS_PASS_NOT_BLOCKED
	var/v = d & (UP|DOWN)
	if(v)
		switch(d)
			if(UP)
				if(!(z_flags & Z_AIR_UP))
					return ATMOS_PASS_AIR_BLOCKED
			if(DOWN)
				if(!(z_flags & Z_AIR_DOWN))
					return ATMOS_PASS_AIR_BLOCKED
		. = ATMOS_PASS_NOT_BLOCKED
		for(var/atom/movable/AM as anything in contents)
			. = min(., CANVERTICALATMOSPASS(AM, T, d))
			if(. == ATMOS_PASS_AIR_BLOCKED)
				// can't go lower than this
				return
	else
		. = ATMOS_PASS_NOT_BLOCKED
		for(var/atom/movable/AM as anything in contents)
			. = min(., CANATMOSPASS(AM, T, d))
			if(. == ATMOS_PASS_AIR_BLOCKED)
				// can't go lower than this
				return

/turf/proc/CheckAirBlock(turf/other)
	if(other == src)
		return CanAtmosPass(src, NONE)
	var/d = other.z == z? get_dir(src, other) : get_dir_multiz(src, other)
	var/o = REVERSE_DIR(d)
	return min(CanAtmosPass(other, d), other.CanAtmosPass(src, o))

/**
 * heuristically grab nearby adjacent tiles
 */
/turf/proc/AtmosAdjacencyFloodfillHeuristic(amount, radius)
	. = list()
	amount = clamp(amount, 0, 100)
	if(!amount)
		return
	var/list/turfs = list(src = TRUE)
	var/i = 1
	while(i <= turfs.len)
		var/turf/check = turfs[i]
		. += check
		for(var/d in GLOB.cardinal)
			var/turf/potential = get_step(check, d)
			if(turfs[potential])
				continue
			if(get_dist(src, potential) > radius)
				continue
			if(CheckAirBlock(potential) == ATMOS_PASS_AIR_BLOCKED)
				continue
			turfs += potential
		++i
		if(i > amount)
			return

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

/**
 * queues us for a zone rebuild
 */
/turf/proc/queue_zone_update()
	if(turf_flags & TURF_ZONE_REBUILD_QUEUED)
		return
	turf_flags |= TURF_ZONE_REBUILD_QUEUED
	SSair.mark_for_update(src)

/**
 * LEGACY BELOW
 */

// ATMOS_TODO: remove /unsimulated
/turf/simulated/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	if(zone)
		if(!zone.invalid)
			air_master.mark_zone_update(zone)
			return zone.air
		else
			c_copy_air()
			zone = null		// immediately detach
			return air
	else
		if(!air)
			make_air()
		return air
