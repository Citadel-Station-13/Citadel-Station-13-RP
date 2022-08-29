#warn finish
//! file contains wrappers and hooks
/mob/living/carbon/human/drag_drop_buckle_interaction(atom/A, mob/user)
	if(!ismob(A))
		// first of all, if it's not a mob, kick it down
		return ..()
	// we're going to do a snowflaked Funny:
	// if we don't have a human riding filter, assume an admin is bussing(tm) and we should stop caring
	if(!LoadComponent(/datum/component/riding_filter/mob/human))
		return ..()
	// do standard stuff
	var/mob/buckling = A
	if(buckling == user)
		// prechecks
		if(a_intent != INTENT_HELP || buckling.a_intent != INTENT_HELP)
			return
		if(lying || buckling.lying)
			return
		carry_piggyback(buckling)
	else


/mob/living/carbon/human/proc/carry_piggyback(mob/living/carbon/other, instant = FALSE, delay_mod = 1, loc_check = TRUE)
	if(loc_check && !Adjacent(other))
		return FALSE


/mob/living/carbon/human/proc/carry_fireman(mob/living/carbon/other, instant = FALSE, delay_mod = 1, loc_check = TRUE)
	if(loc_check && !Adjacent(other))
		return FALSE

