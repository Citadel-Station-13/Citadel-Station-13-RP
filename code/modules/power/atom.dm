/**
 * Attempt to drain power from this atom
 *
 * @params
 * - acter - thing draining, can be null
 * - amount - amount to drain
 * - flags
 *
 * @return Amount drained
 */
/atom/proc/drain_power(datum/acter, amount, flags)
	return 0

/**
 * checks if we support generic power draining
 *
 * @params
 * - acter - thing draining, can be null
 * - flags
 *
 * @return TRUE/FALSE
 */
/atom/proc/can_drain_power(datum/acter, flags)
	return FALSE
