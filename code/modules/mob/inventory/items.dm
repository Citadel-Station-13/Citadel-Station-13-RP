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
 * silent - suppress sounds
 */
/obj/item/proc/equipped(mob/user, slot, accessory, creation, silent)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot, accessory, creation)
	current_equipped_slot = slot
	// current_equipped_slot = get_inventory_slot_datum(slot)
	hud_layerise()
	user.position_hud_item(src,slot)
	if(user.client)
		user.client.screen |= src
	if(slot != SLOT_ID_HANDS)
		if(equip_sound)
			playsound(src, equip_sound, 30, ignore_walls = FALSE)
	user.update_inv_hands()

/**
 * called when an item is unequipped from inventory or moved around in inventory
 *
 * @params
 * user - person unequipping us
 * slot - slot id we're unequipping from
 * accessory - TRUE/FALSE, are we unequipping from being an accessory or due to our accessory unequipping?
 * silent - suppress sounds
 */
/obj/item/proc/unequipped(mob/user, slot, accessory, silent)
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

	hud_unlayerise()
	item_flags &= ~IN_INVENTORY

	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)
	if(!silent)
		playsound(src, drop_sound, 30, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc

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
	hud_layerise()
	item_flags |= IN_INVENTORY
	if(!silent)
		playsound(src, pickup_sound, 20, ignore_walls = FALSE)

/**
 * get the slowdown we incur when we're worn
 */
/obj/item/proc/get_equipment_speed_mod()
	return slowdown

/**
 * update our worn icon if we can
 */
/obj/item/proc/update_worn_icon()
	if(!current_equipped_slot)
		return	// acceptable
	ASSERT(ismob(loc))	 // not acceptable
	var/mob/M = loc
	switch(current_equipped_slot)
		if(SLOT_ID_BACK)
			M.update_inv_back()
		if(SLOT_ID_BELT)
			M.update_inv_belt()
		if(SLOT_ID_GLASSES)
			M.update_inv_glasses()
		if(SLOT_ID_GLOVES)
			M.update_inv_gloves()
		if(SLOT_ID_HANDCUFFED)
			M.update_inv_handcuffed()
		if(SLOT_ID_HANDS)
			M.update_inv_hands()
		if(SLOT_ID_HEAD)
			M.update_inv_head()
		if(SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR)
			M.update_inv_ears()
		if(SLOT_ID_MASK)
			M.update_inv_wear_mask()
		if(SLOT_ID_SHOES)
			M.update_inv_shoes()
		if(SLOT_ID_SUIT)
			M.update_inv_wear_suit()
		if(SLOT_ID_SUIT_STORAGE)
			M.update_inv_s_store()
		if(SLOT_ID_UNIFORM)
			M.update_inv_w_uniform()
		if(SLOT_ID_WORN_ID)
			M.update_inv_wear_id()

/**
 * returns either an item or a list
 * get_equipped_items() uses this so accessories are included
 */
/obj/item/proc/_inv_return_attached()
	return src


#warn refactor
//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Should probably move the bulk of this into mob code some time, as most of it is related to the definition of slots and not item-specific
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(!slot)
		return 0
	if(!M)
		return 0

	if(!ishuman(M)) return 0

	var/mob/living/carbon/human/H = M
	var/list/mob_equip = list()
	#warn abstract check goes before equip slots
	if(H.species.hud && H.species.hud.equip_slots)
		mob_equip = H.species.hud.equip_slots

	if(H.species && !(slot in mob_equip))
		return 0

	//First check if the item can be equipped to the desired slot.
	if("[slot]" in slot_flags_enumeration)
		var/req_flags = slot_flags_enumeration["[slot]"]
		if(!(req_flags & slot_flags))
			return 0

	//Next check if the slot is accessible.
	var/mob/_user = disable_warning? null : H
	if(!H.slot_is_accessible(slot, src, _user))
		return 0

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(SLOT_ID_WORN_ID)
			if(!H.w_uniform && (SLOT_ID_UNIFORM in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
		if(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET)
			if(!H.w_uniform && (SLOT_ID_UNIFORM in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
			if(slot_flags & SLOT_DENYPOCKET)
				return 0
			if( w_class > ITEMSIZE_SMALL && !(slot_flags & SLOT_POCKET) )
				return 0
		if(SLOT_ID_SUIT_STORAGE)
			if(!H.wear_suit && (SLOT_ID_SUIT in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a suit before you can attach this [name].</span>")
				return 0
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(usr, "<span class='warning'>You somehow have a suit with no defined allowed items for suit storage, stop that.</span>")
				return 0
			if( !(istype(src, /obj/item/pda) || istype(src, /obj/item/pen) || is_type_in_list(src, H.wear_suit.allowed)) )
				return 0
		if(slot_in_backpack) //used entirely for equipping spawned mobs or at round start
			var/allow = 0
			if(H.back && istype(H.back, /obj/item/storage/backpack))
				var/obj/item/storage/backpack/B = H.back
				if(B.can_be_inserted(src,1))
					allow = 1
			if(!allow)
				return 0
		if(slot_tie)
			var/allow = 0S
			for(var/obj/item/clothing/C in H.worn_clothing)	//Runs through everything you're wearing, returns if you can't attach the thing
				if(C.can_attach_accessory(src))
					allow = 1
					break
			if(!allow)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You're not wearing anything you can attach this [name] to.</span>")
				return 0
	return 1

#warn refactor
/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!canremove)
		return 0
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1
