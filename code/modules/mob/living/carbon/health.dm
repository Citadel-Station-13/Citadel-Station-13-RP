/mob/living/carbon/is_in_critical()
	return !IS_DEAD(src) && (health < CONFIG_GET(number/health_threshold_crit))
