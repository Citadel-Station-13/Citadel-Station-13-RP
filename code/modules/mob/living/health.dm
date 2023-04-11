//? Body Temperature

/**
 * adjust body temperature
 */
/mob/living/proc/adjust_bodytemperature(amt)
	bodytemperature += amt

/**
 * get normal bodytemperature
 */
/mob/living/proc/nominal_bodytemperature()
	return T20C

/**
 * stabliize bodytemperature towards normal
 */
/mob/living/proc/normalize_bodytemperature(adj, mult)
	var/diff = nominal_bodytemperature() - bodytemperature
	var/adjust = SIGN(diff) * min(adj, abs(diff))
	adjust_bodytemperature(adjust + (diff - adjust) * mult)
