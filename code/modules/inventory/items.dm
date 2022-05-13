/obj/item
	/// currently equipped slot
	var/current_equipped_slot

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	current_equipped_slot = slot
	// current_equipped_slot = get_inventory_slot_datum(slot)
	hud_layerise()
	user.position_hud_item(src,slot)
	if(user.client)
		user.client.screen |= src
	if(user.pulling == src)
		user.stop_pulling()
	if((slot_flags & slot))
		if(equip_sound)
			playsound(src, equip_sound, 30)
		else
			playsound(src, drop_sound, 30)
	else if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, pickup_sound, 20, preference = /datum/client_preference/pickup_sounds)
	user.update_inv_hands()

/// Called when a mob drops an item.
/obj/item/proc/dropped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)
/*
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
*/
	if(item_flags & DROPDEL)
		qdel(src)

	item_flags &= ~IN_INVENTORY

	var/old_slot = current_equipped_slot
	current_equipped_slot = null
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user, old_slot)
	// if(!silent)
	// 	playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc
	appearance_flags &= ~NO_CLIENT_COLOR

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	item_flags |= IN_INVENTORY

/**
 * get the slowdown we incur when we're worn
 */
/obj/item/proc/get_equipment_speed_mod()
	return slowdown
