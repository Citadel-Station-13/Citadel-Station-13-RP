/mob/living/carbon/human/rejuvenate(fix_missing, reset_to_slot)
	. = ..()
	if(!.)
		return
	// blood
	restore_blood()
	fixblood()
