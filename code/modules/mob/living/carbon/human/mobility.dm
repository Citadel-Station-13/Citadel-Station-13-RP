/mob/living/carbon/human/update_mobility(blocked, forced)
	if(wearing_rig?.ai_can_move_suit(check_for_ai = TRUE))
		// there are no brakes on this train
		forced |= MOBILITY_FLAGS_REAL
	return ..()
