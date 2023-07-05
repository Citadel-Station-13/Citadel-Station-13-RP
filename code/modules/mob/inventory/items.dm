/obj/item
	/// currently equipped slot id
	var/worn_slot
	/**
	 * current item we fitted over
	 * ! DANGER: While this is more or less bug-free for "won't lose the item when you unequip/won't get stuck", we
	 * ! do not promise anything for functionality - this is a SNOWFLAKE SYSTEM.
	 */
	var/obj/item/worn_over
	/**
	 * current item we're fitted in.
	 */
	var/obj/item/worn_inside
	/// suppress auto inventory hooks in forceMove
	var/worn_hook_suppressed = FALSE

/obj/item/Destroy()
	if(worn_slot && !worn_hook_suppressed)
		var/mob/M = worn_mob()
		if(!ismob(M))
			stack_trace("invalid current equipped slot [worn_slot] on an item not on a mob.")
			return ..()
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_DELETING)
	return ..()

/**
 * get the slowdown we incur when we're worn
 */
/obj/item/proc/get_equipment_speed_mod()
	return slowdown

/**
 * update our worn icon if we can
 */
/obj/item/proc/update_worn_icon()
	if(!worn_slot)
		return	// acceptable
	var/mob/M = worn_mob()
	ASSERT(M)	// not acceptable
	switch(worn_slot)
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
 * automatically unequip if we're missing beltlink
 */
/obj/item/proc/reconsider_beltlink()
	var/mob/M = loc
	if(!istype(M))
		return
	if(!worn_slot)
		return
	if(!equip_check_beltlink(M, worn_slot, null, INV_OP_SILENT))
		M.drop_item_to_ground(src)
		return

// doMove hook to ensure proper functionality when inv procs aren't called
/obj/item/doMove(atom/destination)
	if(worn_slot && !worn_hook_suppressed)
		// inventory handling
		if(destination == worn_inside)
			return ..()
		var/mob/M = worn_mob()
		if(!ismob(M))
			worn_slot = null
			worn_hook_suppressed = FALSE
			stack_trace("item forcemove inv hook called without a mob as loc??")
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
	return ..()

// todo: this is fucking awful
/obj/item/Move(atom/newloc, direct, glide_size_override)
	if(!worn_slot)
		return ..()
	var/mob/M = worn_mob()
	if(istype(M))
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
	else
		stack_trace("item Move inv hook called without a mob as loc??")
		worn_slot = null
	. = ..()
	if(!. || (loc == M))
		// kick them out
		forceMove(M.drop_location())
