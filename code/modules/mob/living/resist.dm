/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		setClickCooldown(20)
		resist_grab()
		if(CHECK_MOBILITY(src, MOBILITY_CAN_RESIST))
			process_resist()

/mob/living/proc/process_resist()
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_RESIST))
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_PROCESS_RESIST) & COMPONENT_MOB_RESIST_INTERRUPT)
		return

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
		return

	if(resist_restraints())
		return

	if(isbelly(loc))
		var/obj/belly/B = loc
		B.relay_resist(src)
		return

	if(resist_a_rest())
		return

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return
