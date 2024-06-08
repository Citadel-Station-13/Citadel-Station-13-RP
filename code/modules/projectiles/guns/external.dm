//* External hooks for guns *//

/**
 * Inflicts gun recoil onto this atom
 *
 * @params
 * * amount - amount of recoil to inflict
 * * shake - screenshake amount
 */
/atom/movable/proc/inflict_gun_recoil(amount, shake)
	return

/**
 * Get aiming instability as a number
 *
 * @params
 * * gun - the gun asking
 * * gun_instability - the instability the gun currently has
 *
 * @return total instability to use for a shot
 */
/atom/movable/proc/query_gun_instability(obj/item/gun/gun, gun_instability)
	return gun_instability

#warn hook on /mob
