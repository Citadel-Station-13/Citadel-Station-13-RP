/mob/living/carbon/is_in_critical()
	return !IS_DEAD(src) && (health < config_legacy.health_threshold_crit)

/mob/living/carbon/revive(force, full_heal)
	. = ..()
	if(!.)
		return
	#warn impl

/mob/living/carbon/rejuvenate(fix_missing, reset_to_slot)
	. = ..()
	if(!.)
		return
	// shock
	shock_stage = 0
	traumatic_shock = 0
	// clear reagents
	// todo: only bad reagents
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	#warn impl
