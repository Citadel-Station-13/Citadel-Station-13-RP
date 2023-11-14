/**
 * Get logical step in dir for a turf
 */
/datum/controller/subsystem/mapping/proc/GetVirtualStep(turf/A, dir)
	return get_step(A, dir)
	// todo: impl
	// #warn impl also make sure border is 2 from edge aka 1 from edge is hte teleport loc
