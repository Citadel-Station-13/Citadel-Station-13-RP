/mob/living/carbon/is_in_critical()
	return !IS_DEAD(src) && (health < config_legacy.health_threshold_crit)
