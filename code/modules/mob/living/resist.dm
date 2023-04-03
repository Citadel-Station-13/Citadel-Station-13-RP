/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		setClickCooldown(20)
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//unbuckling yourself
	if(buckled)
		resist_buckle()
		return TRUE

	//Breaking out of a locker?
	if(isobj(loc))
		var/obj/C = loc
		C.contents_resist(src)
		return TRUE

	else if(canmove)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else
			resist_restraints()

	else if(canmove)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else
			resist_restraints()

	if(attempt_vr(src,"vore_process_resist",args))
		return TRUE

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
