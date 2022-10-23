/atom
	var/CanAtmosPass = ATMOS_PASS_NOT_BLOCKED
	var/CanAtmosPassVertical = ATMOS_PASS_VERTICAL_DEFAULT

/atom/proc/CanAtmosPass(turf/T, d)
	switch (CanAtmosPass)
		if (ATMOS_PASS_PROC)
			return ATMOS_PASS_NOT_BLOCKED
		if (ATMOS_PASS_DENSITY)
			return density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED
		else
			return CanAtmosPass

/**
 * call when we ourselves need to update our air pass
 */
/atom/proc/air_update_turf()

/turf/air_update_turf()
	queue_zone_update()

/atom/movable/air_update_turf()
	update_nearby_tiles()

/**
 * call when we move to update our air pass
 */
/atom/proc/air_update_turf_moved(turf/oldLoc)

/turf/air_update_turf_moved()
	queue_zone_update()

/atom/movable/air_update_turf_moved()
	update_nearby_tiles()

/**
 * superconduction - not yet implemented
 */

/*

/**
 * do we block thermal conduction?
 *
 * @params
 * a - temperature of one side
 * b - temperature of other side
 */
/atom/movable/proc/BlockThermalConductivity(a, b)
	return FALSE

*/
