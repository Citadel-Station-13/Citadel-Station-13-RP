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
	// viruses
	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)
	// shock
	shock_stage = 0
	traumatic_shock = 0
	// clear reagents
	// todo: only bad reagents
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	// todo: organs
