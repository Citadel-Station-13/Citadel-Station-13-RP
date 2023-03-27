/mob/living/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

/mob/living/update_stat()
	if(stat == DEAD)
		return stat
	if(is_unconscious() || is_sleeping() || (status_flags & STATUS_FAKEDEATH))
		. = UNCONSCIOUS
	else
		. = CONSCIOUS
	if(. != stat)
		set_stat(.)
