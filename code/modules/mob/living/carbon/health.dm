/mob/living/carbon/is_in_critical()
	return !IS_DEAD(src) && (health < getCritHealth())

/mob/living/carbon/rejuvenate(fix_missing, reset_to_slot, restore_nutrition = TRUE)
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
	// redo graphics
	rebuild_standing_overlays()
