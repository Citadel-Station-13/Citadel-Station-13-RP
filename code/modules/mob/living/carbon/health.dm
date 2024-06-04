/mob/living/carbon/is_in_critical()
	return !IS_DEAD(src) && (health < config_legacy.health_threshold_crit)

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
	reagents_bloodstream.clear()
	reagents_ingested.clear()
	// todo: organs
	for(var/obj/item/organ/external/ext in organs)
		ext.reagents_dermal.clear()
	// redo graphics
	rebuild_standing_overlays()
