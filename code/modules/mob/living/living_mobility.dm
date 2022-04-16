
//Stuff like mobility flag updates, resting updates, etc.

//Force-set resting variable, without needing to resist/etc.
/mob/living/proc/set_resting(new_resting, silent = FALSE, updating = TRUE)
	if(new_resting != resting)
		if(resting && HAS_TRAIT(src, TRAIT_MOBILITY_NOREST)) //forcibly block resting from all sources - BE CAREFUL WITH THIS TRAIT
			return
		resting = new_resting
		if(!silent)
			to_chat(src, "<span class='notice'>You are now [resting? "resting" : "getting up"].</span>")
		if(resting == 1)
			SEND_SIGNAL(src, COMSIG_LIVING_RESTING)
		update_resting(updating)

/**
 * handles all mobility_flag updates
 */
/mob/living/proc/update_mobility()

/mob/living/update_canmove()
	// TEMPORARY PATCH UNTIL MOBILITY FLAGS
	if(restrained())
		stop_pulling()
	// End
	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = 1
	else
		if(istype(buckled, /obj/vehicle))
			var/obj/vehicle/V = buckled
			if(is_physically_disabled())
				lying = 0
				canmove = 1
				if(!V.riding_datum) // If it has a riding datum, the datum handles moving the pixel_ vars.
					pixel_y = V.mob_offset_y - 5
			else
				if(buckled.buckle_lying != -1)
					lying = buckled.buckle_lying
				canmove = 1
				if(!V.riding_datum) // If it has a riding datum, the datum handles moving the pixel_ vars.
					pixel_y = V.mob_offset_y
		else if(buckled)
			anchored = 1
			canmove = 0
			if(istype(buckled))
				if(buckled.buckle_lying != -1)
					lying = buckled.buckle_lying
				if(buckled.buckle_movable)
					anchored = 0
					canmove = 1
		else
			lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			canmove = !incapacitated(INCAPACITATION_DISABLED)

	if(lying)
		density = 0
		if(l_hand)
			unEquip(l_hand)
		if(r_hand)
			unEquip(r_hand)
		for(var/obj/item/holder/H in get_mob_riding_slots())
			unEquip(H)
		update_water() // Submerges the mob.
	else
		density = initial(density)

	for(var/obj/item/grab/G in grabbed_by)
		if(G.state >= GRAB_AGGRESSIVE)
			canmove = 0
			break

	if(lying != lying_prev)
		lying_prev = lying
		update_transform()
		//VOREStation Add
		if(lying && LAZYLEN(buckled_mobs))
			for(var/rider in buckled_mobs)
				var/mob/living/L = rider
				if(buckled_mobs[rider] != "riding")
					continue // Only boot off riders
				if(riding_datum)
					riding_datum.force_dismount(L)
				else
					unbuckle_mob(L)
				L.Stun(5)
		//VOREStation Add End

	return canmove
