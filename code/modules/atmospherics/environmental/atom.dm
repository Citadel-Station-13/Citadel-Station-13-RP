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
