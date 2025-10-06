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
 * * For multi-tile objects, you must call this on all old and new locs. This is tricky with the current Moved() system.
 */
/atom/proc/air_update_self()
	return

/turf/air_update_self()
	queue_zone_update()

// todo: refactor return_air to just call return_air_mutable

/**
 * returns a mutable gas mixture, or null
 * this does not take into account volume, and for ZAS, can return a whole room's air
 * for operations that care about this, prefer using other procs!
 */
/atom/proc/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.return_air()

/**
 * returns a gas mixture; this mixture must never be mutated
 *
 * this allows us to micro-optimize accesses without activating zones.
 */
/atom/proc/return_air_immutable()
	RETURN_TYPE(/datum/gas_mixture)
	return return_air()

/**
 * returns a gas mixture; this mixture may, but does not necessarily have to be mutated.
 *
 * this should always trigger updates/checks like making a zone active
 */
/atom/proc/return_air_mutable()
	RETURN_TYPE(/datum/gas_mixture)
	return return_air()
