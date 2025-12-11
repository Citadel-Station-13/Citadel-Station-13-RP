
/**
 * Returns true if this atom has gravity for the passed in turf
 *
 * Gravity situations:
 * * No gravity if you're not in a turf
 * * No gravity if this atom is in is a space turf
 * * Gravity if the area it's in always has gravity
 * * Gravity if there's a gravity generator on the z level
 * * Gravity if the Z level has an SSMappingTrait for ZTRAIT_GRAVITY
 * * otherwise no gravity
 */
/atom/proc/has_gravity(turf/T = get_turf(src))
	if(!T)
		return FALSE
	return T.has_gravity()

/**
 * no-op for most atoms; triggers things like floating animations.
 */
/atom/proc/update_gravity()
	return
