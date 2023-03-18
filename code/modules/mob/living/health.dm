/mob/living/proc/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

/mob/living/proc/update_stat()
	if(stat != DEAD)
		if(is_unconscious())
			set_stat(UNCONSCIOUS)
		else if (status_flags & STATUS_FAKEDEATH)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
		return 1
