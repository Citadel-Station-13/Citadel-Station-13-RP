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
 * acts on all locs we currently occupy - this means that you must call this before and after move
 * in some cases
 *
 * if you're an one tile object calling from Moved(), consider just calling air_update_self()
 * on old and new locs; it's cheaper.
 *
 * works for multi-tile objects
 */
/atom/proc/air_update_turf()

/turf/air_update_turf()
	queue_zone_update()

/atom/movable/air_update_turf()
	update_nearby_tiles()


/**
 * call on oldloc and newloc when moving a potentially air-blocking obj
 *
 * *warning*: only works for non-multi-tile objects!
 */
/atom/proc/air_update_self()
	return

/turf/air_update_self()
	queue_zone_update()

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
