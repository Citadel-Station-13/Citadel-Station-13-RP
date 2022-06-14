#warn refactor everything
/atom/movable/screen/inventory

/atom/movable/screen/inventory/proc/check_inventory_usage(mob/user)
	if(!user.canClick())
		return FALSE
	if(user.stunned || user.paralysis || user.weakened || user.stat)
		return FALSE
	return TRUE

/atom/movable/screen/inventory/slot
	/// the ID of this slot
	var/slot_id

/atom/movable/screen/inventory/slot/Click()
	if(!check_inventory_usage(usr))
		return

	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
		if("swap")
			usr.swap_hand()
		if("hand")
			usr.swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)
	return 1

// Hand slots are special to handle the handcuffs overlay
/atom/movable/screen/inventory/hand
	/// hand index
	var/index
	var/image/handcuff_overlay

/atom/movable/screen/inventory/hand/Click()
	if(!check_inventory_usage(usr))
		return

/atom/movable/screen/inventory/hand/update_icon()
	..()
	if(!hud)
		return
	if(!handcuff_overlay)
		var/state = (hud.l_hand_hud_object == src) ? "l_hand_hud_handcuffs" : "r_hand_hud_handcuffs"
		handcuff_overlay = image("icon"='icons/mob/screen_gen.dmi', "icon_state"=state)
	overlays.Cut()
	if(hud.mymob && iscarbon(hud.mymob))
		var/mob/living/carbon/C = hud.mymob
		if(C.handcuffed)
			overlays |= handcuff_overlay
