/**
 * Attempt to drain power from this atom
 *
 * *Uses universal units.*
 *
 * @params
 * - actor - thing draining, can be null
 * - amount - amount to drain in kilojoules
 * - flags
 *
 * @return Amount drained
 */
/atom/proc/drain_energy(datum/actor, amount, flags)
	return 0

/**
 * checks if we support generic power draining
 *
 * @params
 * - actor - thing draining, can be null
 * - flags
 *
 * @return TRUE/FALSE
 */
/atom/proc/can_drain_energy(datum/actor, flags)
	return FALSE

// below may be bad ideas, idk yet. COMSIG_USE_CELL_UNITS? COMSIG_GENERIC_USE_POWER? COMSIG_GENERIC_USE_ENERGY?
// TODO: generic use_power() proc with scales.
// TODO: generic use_energy() proc with scales.
// TODO: machinery components for backup batteries?? apc link?? grid link??
