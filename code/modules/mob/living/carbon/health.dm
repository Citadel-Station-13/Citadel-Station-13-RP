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
	// organs
	// todo: this is obviously bad logic but whatever, we will eventually want separate handling for the two maybe
	if(fix_missing || reset_to_slot)
		restore_organs()
	// shock
	shock_stage = 0
	traumatic_shock = 0
	// clear reagents
	// todo: only bad reagents
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	#warn impl

/mob/living/carbon/restore_organs()
	for(var/obj/item/organ/external/current_organ in organs)
		current_organ.rejuvenate_legacy(ignore_prosthetic_prefs)
	#warn impl?
