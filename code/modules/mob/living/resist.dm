/mob/living/verb/resist()
	set name = "Resist"
	set category = VERB_CATEGORY_IC

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		if(CHECK_MOBILITY(src, MOBILITY_CAN_RESIST))
			// this means execute both and get as boolean
			// this is done so resist doesn't always invoke clickcd
			if(resist_grab() | process_resist())
				setClickCooldownLegacy(20)

// todo: refactor
// todo: resist doing normal clickcd is kinda weird
/**
 * @return TRUE if we should apply resist delay
 */
/mob/living/proc/process_resist()
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_RESIST))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_MOB_PROCESS_RESIST) & COMPONENT_MOB_RESIST_INTERRUPT)
		return TRUE

	//unbuckling yourself
	if(buckled)
		resist_buckle()
		return TRUE

	//Breaking out of a locker?
	if(isobj(loc))
		var/obj/C = loc
		C.contents_resist(src)
		return TRUE

	if(resist_fire())
		return TRUE

	if(resist_restraints())
		return TRUE

	if(resist_a_rest())
		return FALSE

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
		. = TRUE
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return
