/*
 * Helper file for Exosuit / Mecha code.
 */

// Returns, at least, a usable target body position, for things like guns.

/obj/vehicle/sealed/mecha/proc/get_pilot_zone_sel()
	if(!occupant_legacy || !occupant_legacy.zone_sel || occupant_legacy.stat)
		return BP_TORSO

	return occupant_legacy.zone_sel.selecting
