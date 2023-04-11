/mob/living/update_mobility(blocked, forced)
	// this proc looks mildly heretical and pyramid of doomy
	// for micro-optimization purposes.
	if(IS_DEAD(src))
		blocked |= MOBILITY_FLAGS_REAL | MOBILITY_IS_CONSCIOUS
	else
		if(restrained())
			blocked |= MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP | MOBILITY_CAN_HOLD | MOBILITY_CAN_PULL | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI
			if(pulledby || buckled)
				blocked |= MOBILITY_CAN_MOVE
		for(var/obj/item/grab/G as anything in grabbed_by)
			if(G.stat >= GRAB_AGGRESSIVE)
				blocked |= MOBILITY_CAN_MOVE | MOBILITY_CAN_USE | MOBILITY_CAN_HOLD | MOBILITY_CAN_PICKUP | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI

	. = ..()

	if(!(mobility_flags & MOBILITY_CAN_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_CAN_PULL))
		stop_pulling()

#warn impl

/mob/living/proc/toggle_resting(value)
	#warn impl

/mob/living/proc/set_resting(value)
	#warn impl

/mob/living/proc/resist_a_rest()
	#warn impl

/mob/living/proc/set_intentionally_resting(value, instant)

/**
 * sets our lying value to the correct value,
 * updates icons if necessary,
 * and updates mobility if necessary.
 */
/mob/living/proc/update_lying()

/// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list("l_leg","r_leg"))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)


#warn refactor

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	toggle_resting()
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	update_canmove()
