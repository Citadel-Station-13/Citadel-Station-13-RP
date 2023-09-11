//* External hooks for guns *//

/**
 * Inflicts gun recoil onto this atom
 *
 * @params
 * * amount - amount of recoil to inflict
 * * shake - screenshake forced, instead of automatically calculating it
 */
/atom/movable/proc/inflict_gun_recoil(amount, shake)
	return

/**
 * Get aiming instability as a number
 *
 * @params
 * * gun - the gun asking
 */
/atom/movable/proc/query_gun_instability(obj/item/gun/gun)
	return 0
