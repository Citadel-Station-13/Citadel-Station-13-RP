/atom/movable/screen/inventory
	name = "inv box"

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

	usr.attack_ui(slot_id)

// Hand slots are special to handle the handcuffs overlay
/atom/movable/screen/inventory/hand
	/// hand index
	var/index
	/// are we the left hand
	var/is_left_hand = FALSE
	/// current handcuffed overlay
	var/image/handcuff_overlay

/atom/movable/screen/inventory/hand/Click()
	usr.activate_hand_of_index(index)

/atom/movable/screen/inventory/hand/update_icon()
	..()
	if(!hud)
		return
	if(!handcuff_overlay)
		handcuff_overlay = image(
			"icon" = 'icons/mob/screen_gen.dmi',
			"icon_state" = "[is_left_hand? "l_hand" : "r_hand"]_hud_handcuffs"
		)
	overlays.Cut()
	if(iscarbon(hud?.mymob))
		var/mob/living/carbon/C = hud.mymob
		if(C.handcuffed)
			overlays += handcuff_overlay

/atom/movable/screen/inventory/hand/left
	name = "l_hand"
	is_left_hand = TRUE

/atom/movable/screen/inventory/hand/right
	name = "r_hand"
	is_left_hand = FALSE

/atom/movable/screen/inventory/swap_hands
	name = "swap hands"

/atom/movable/screen/inventory/swap_hands/Click()
	usr.swap_hand()
