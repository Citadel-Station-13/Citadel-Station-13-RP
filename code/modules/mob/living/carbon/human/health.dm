/mob/living/carbon/human/revive(force, full_heal)
	. = ..()
	if(!.)
		return
	#warn impl

/mob/living/carbon/human/rejuvenate(fix_missing, reset_to_slot)
	. = ..()
	if(!.)
		return
	// blood
	restore_blood()
