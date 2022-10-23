/mob/living/silicon/decoy/Life(seconds, times_fired)
	if((. = ..()))
		return

	if (src.health <= config_legacy.health_threshold_dead && stat != DEAD)
		death()
		return TRUE

/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
