//? Health / Stat

/mob/living/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

/mob/living/update_stat(forced, update_mobility)
	if(stat == DEAD)
		return stat
	if(is_unconscious() || is_sleeping() || (status_flags & STATUS_FAKEDEATH))
		. = UNCONSCIOUS
	else
		. = CONSCIOUS
	. = max(., isnull(forced)? initial(stat) : forced)
	if(. != stat)
		set_stat(., update_mobility)

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
