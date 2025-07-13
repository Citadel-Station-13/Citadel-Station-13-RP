//* Radiation *//

/**
 * inflicts radiation.
 * will not heal it.
 *
 * TODO: don't check armor here, whatever's calling this should check it
 *
 * @params
 * - amt - how much
 * - check_armor - do'th we care about armor?
 * - def_zone - zone to check if we do
 */
/mob/living/proc/afflict_radiation(amt, run_armor, def_zone)
	if(amt <= 0)
		return
	if(run_armor)
		amt *= 1 - ((legacy_mob_armor(def_zone, ARMOR_RAD)) / 100)
	radiation += max(0, RAD_MOB_ADDITIONAL(amt, radiation))

/**
 * heals radiation.
 *
 * @params
 * - amt - how much
 */
/mob/living/proc/cure_radiation(amt)
	if(amt <= 0)
		return
	radiation = max(0, radiation - amt)
