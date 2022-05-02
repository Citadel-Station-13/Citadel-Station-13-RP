/**
 * updates all mobility flags
 */
/mob/proc/update_mobility()
	// this is hard overridden in /living
	// most mobs don't ever have mobility flags
	mobility_flags = NONE
