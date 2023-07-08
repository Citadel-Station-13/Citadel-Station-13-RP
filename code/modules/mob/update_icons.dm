//Most of these are defined at this level to reduce on checks elsewhere in the code.
//Having them here also makes for a nice reference list of the various overlay-updating procs available

/mob/proc/regenerate_icons()		//Update every aspect of the mob's icons (expensive, resist the urge to use unless you need it)
	return

/mob/proc/update_icons()
	update_icon() //Ugh.
	return

// Obsolete
/mob/proc/update_icons_layers()
	return

/mob/proc/update_icons_huds()
	return

/mob/proc/update_icons_body()
	return

// End obsolete

/mob/proc/update_hud()
	return

/mob/proc/update_inv_handcuffed()
	return

/mob/proc/update_inv_legcuffed()
	return

/mob/proc/update_inv_back()
	return

/mob/proc/update_inv_hand(index)
	return

/mob/proc/update_inv_wear_mask()
	return

/mob/proc/update_inv_wear_suit()
	return

/mob/proc/update_inv_w_uniform()
	return

/mob/proc/update_inv_belt()
	return

/mob/proc/update_inv_head()
	return

/mob/proc/update_inv_gloves()
	return

/mob/proc/update_mutations()
	return

/mob/proc/update_inv_wear_id()
	return

/mob/proc/update_inv_shoes()
	return

/mob/proc/update_inv_glasses()
	return

/mob/proc/update_inv_s_store()
	return

/mob/proc/update_inv_pockets()
	return

/mob/proc/update_inv_ears()
	return

/mob/proc/update_targeted()
	return

/mob/proc/update_hair()

/mob/proc/update_eyes()

//* Helpers - These call other update procs. *//

/mob/proc/update_inv_hands()
	for(var/i in 1 to length(held_items))
		update_inv_hand(i)

/mob/proc/update_inv_active_hand()
	return update_inv_hand(active_hand)
