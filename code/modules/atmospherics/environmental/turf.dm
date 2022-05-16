// everything relating to turfs for atmospherics - environmental
/turf
	CanAtmosPass = ATMOS_PASS_PROC
	CanAtmosPassVertical = ATMOS_PASS_PROC
	/// our air mixture, if any - this refers **just** to ours, not our zone.
	var/datum/gas_mixture/air

/**
 * semantically means "we can pass to them", not "they can pass to us"
 * use CheckAirBlock instead
 */
/turf/CanAtmosPass(turf/T, d)
	if(blocks_air)
		return ATMOS_PASS_AIR_BLOCKED
	var/v = dir & (UP|DOWN)
	switch(v)
		if(UP)
			if(!(z_flags & Z_AIR_UP))
				return ATMOS_PASS_AIR_BLOCKED
		if(DOWN)
			if(!(z_flags & Z_AIR_DOWN))
				return ATMOS_PASS_AIR_BLOCKED
	if(T == src)
		// at this point nothing should be blocking us --> us
		return ATMOS_PASS_NOT_BLOCKED
	// we only care about objects, compiler fastpath
	// plus, wtf are you doing using /atom/movable to block atmos??
	for(var/obj/O in contents)
		. = v? CANVERTICALATMOSPASS(O, T, dir) : CANATMOSPASS(O, T, dir)
		if(. != ATMOS_PASS_NOT_BLOCKED)
			return
	// at this point . will be atmos pass not blocked and we already checked ourselves so we're gucci with returning .

/turf/proc/CheckAirBlock(turf/other)
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
			if(!air)
				make_air()
			c_copy_air()
			return air
	else
		if(!air)
			make_air()
		return air
