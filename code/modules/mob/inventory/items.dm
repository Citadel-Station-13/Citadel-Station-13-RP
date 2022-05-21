/obj/item
	/// currently equipped slot id
	var/current_equipped_slot

/**
 * called when an item is equipped to inventory or picked up
 *
 * @params
 * user - person equipping us
 * slot - slot id we're equipped to
 * accessory - TRUE/FALSE, are we equipped as an accessory?
 * creation - being equipped by a job datum/outfit/etc
 */
/obj/item/proc/equipped(mob/user, slot, accessory, creation)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot, accessory, creation)
	current_equipped_slot = slot
	// current_equipped_slot = get_inventory_slot_datum(slot)
	hud_layerise()
	user.position_hud_item(src,slot)
	if(user.client)
		user.client.screen |= src
	if((slot_flags & slot))
		if(equip_sound)
			playsound(src, equip_sound, 30)
		else
			playsound(src, drop_sound, 30)
	else if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, pickup_sound, 20, preference = /datum/client_preference/pickup_sounds)
	user.update_inv_hands()

/**
 * called when an item is unequipped from inventory or moved around in inventory
 *
 * @params
 * user - person unequipping us
 * slot - slot id we're unequipping from
 * accessory - TRUE/FALSE, are we unequipping from being an accessory or due to our accessory unequipping?
 */
/obj/item/proc/unequipped(mob/user, slot, accessory)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user, slot, accessory)
	current_equipped_slot = null

/**
 * called when a mob drops an item
 *
 * dropping is defined as moving out of both equipment slots and hand slots
 */
/obj/item/proc/dropped(mob/user, accessory, silent)
	SHOULD_CALL_PARENT(TRUE)
/*
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
*/
	if(item_flags & DROPDEL)
		qdel(src)

	item_flags &= ~IN_INVENTORY

	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)
	// if(!silent)
	// 	playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc
	appearance_flags &= ~NO_CLIENT_COLOR

/**
 * called when a mob picks up an item
 *
 * picking up is defined as moving into either an equipment slot, or hand slots
 */
/obj/item/proc/pickup(mob/user, accessory, silent)
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
