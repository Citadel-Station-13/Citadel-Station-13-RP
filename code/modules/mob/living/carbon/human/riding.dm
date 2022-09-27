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
		// if taur, skip to component
		if(isTaurTail(tail_style))
			return ..()
		// prechecks
		if(a_intent != INTENT_HELP || buckling.a_intent != INTENT_HELP)
			return FALSE
		if(lying || buckling.lying)
			return FALSE
		if(grab_state(buckling) != GRAB_PASSIVE)
			to_chat(user, SPAN_WARNING("[src] must be grabbing you passively for you to climb on."))
			return TRUE
		carry_piggyback(buckling)
	else if(user == src)
		// prechecks
		if(a_intent != INTENT_GRAB)
			return FALSE
		if(!buckling.lying)
			to_chat(user, SPAN_WARNING("[buckling] must be laying down if you want to carry them!"))
			return TRUE
		if(grab_state(buckling) != GRAB_PASSIVE)
			to_chat(user, SPAN_WARNING("You must be grabbing [buckling] passively to carry them."))
			return TRUE
		carry_fireman(buckling)
	return FALSE

/mob/living/carbon/human/click_unbuckle_interaction(mob/user)
	if(user != src)
		return FALSE
	// we can kick people off ourselves, others have to push us down or disarm offhands.
	return ..()

/mob/living/carbon/human/proc/carry_piggyback(mob/living/carbon/other, instant = FALSE, delay_mod = 1, loc_check = TRUE)
	if(loc_check && !Adjacent(other))
		return FALSE
	other.visible_message(
		SPAN_NOTICE("[other] starts climbing onto [src]!"),
		SPAN_NOTICE("You start climbing onto [src]!")
	)
	if(!instant && !do_after(other, HUMAN_PIGGYBACK_DELAY * delay_mod, src, FALSE))
		return FALSE
	user_buckle_mob(other, BUCKLE_OP_DEFAULT_INTERACTION | BUCKLE_OP_SILENT, other, BUCKLE_SEMANTIC_HUMAN_PIGGYBACK)
	other.visible_message(
		SPAN_NOTICE("[other] climbs onto [src]!"),
		SPAN_NOTICE("You climb onto [src]!")
	)

/mob/living/carbon/human/proc/carry_fireman(mob/living/carbon/other, instant = FALSE, delay_mod = 1, loc_check = TRUE)
	if(loc_check && !Adjacent(other))
		return FALSE
	visible_message(
		SPAN_NOTICE("[src] starts picking up [other] over [p_their()] shoulders!"),
		SPAN_NOTICE("You start picking up [other] over your shoulders!")
	)
	if(!instant && !do_after(src, HUMAN_FIREMAN_DELAY * delay_mod, other, FALSE))
		return FALSE
	user_buckle_mob(other, BUCKLE_OP_DEFAULT_INTERACTION | BUCKLE_OP_SILENT, other, BUCKLE_SEMANTIC_HUMAN_FIREMAN)
	visible_message(
		SPAN_NOTICE("[src] picks [other] up over [p_their()] shoulders!"),
		SPAN_NOTICE("You pick [other] up over your shoulders!")
	)

/mob/living/carbon/human/buckle_lying(mob/M)
	var/semantic = buckled_mobs[M]
	return semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? 90 : 0
