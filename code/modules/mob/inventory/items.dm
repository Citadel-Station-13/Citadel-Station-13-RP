/obj/item
	/// currently equipped slot id
	var/current_equipped_slot
	/**
	 * current item we fitted over
	 * ! DANGER: While this is more or less bug-free for "won't lose the item when you unequip/won't get stuck", we
	 * ! do not promise anything for functionality - this is a SNOWFLAKE SYSTEM.
	 */
	var/obj/item/worn_over
	/// current item we're fitted in. this is an atom movable because we also set this to a mob to prevent a hook from firing in forceMove during unequip!
	var/atom/movable/worn_inside

/obj/item/Destroy()
	if(current_equipped_slot)
		var/mob/M = current_equipped_mob()
		if(!ismob(M))
			stack_trace("invalid current equipped slot [current_equipped_slot] on an item not on a mob.")
			return ..()
		M.temporarily_remove_from_inventory(src, TRUE)
	return ..()

/**
 * called when an item is equipped to inventory or picked up
 *
 * @params
 * user - person equipping us
 * slot - slot id we're equipped to
 * accessory - TRUE/FALSE, are we equipped as an accessory?
 * silent - suppress sounds
 * creation - being equipped by a job datum/outfit/etc
 */
/obj/item/proc/equipped(mob/user, slot, accessory, silent, creation)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot, accessory, creation)
	current_equipped_slot = slot
	// current_equipped_slot = get_inventory_slot_datum(slot)
	// todo: shouldn't be in here
	hud_layerise()
	// todo: shouldn't be in here
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
	// todo: shouldn't be in here
	hud_unlayerise()
	// todo: shouldn't be in here
	screen_loc = null

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

	. = SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)

	if(!silent)
		playsound(src, drop_sound, 30, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc

	return ((. & COMPONENT_ITEM_RELOCATED_BY_DROP)? ITEM_RELOCATED_BY_DROPPED : NONE)

/**
 * called when a mob picks up an item
 *
 * picking up is defined as moving into either an equipment slot, or hand slots
 */
/obj/item/proc/pickup(mob/user, accessory, silent, creation)
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

// todo: item should get final say for "soft" aka not-literal-var-overwrite conflicts.

/**
 * checks if a mob can equip us to a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 */
/obj/item/proc/can_equip(mob/M, slot, mob/user, silent, disallow_delay, ignore_fluff)
	if(!equip_check_beltlink(M, slot, user, silent))
		return FALSE
	return TRUE

/**
 * checks if a mob can unequip us from a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 */
/obj/item/proc/can_unequip(mob/M, slot, mob/user, silent, disallow_delay, ignore_fluff)
	return TRUE

/**
 * allow an item in suit storage slot?
 */
/obj/item/proc/can_suit_storage(obj/item/I)
	// todo: this is awful
	return is_type_in_list(I, allowed)

/**
 * checks if we need something to attach to in a certain slot
 */
/obj/item/proc/equip_check_beltlink(mob/M, slot, mob/user, silent)
	if(item_flags & EQUIP_IGNORE_BELTLINK)
		return TRUE

	if(!ishuman(M))
		return TRUE

	var/mob/living/carbon/human/H = M

	switch(slot)
		if(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!silent)
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_WORN_ID)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!silent)
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_BELT)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!silent)
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_SUIT_STORAGE)
			if(H.semantically_has_slot(SLOT_ID_SUIT) && !H.item_by_slot(SLOT_ID_SUIT))
				if(!silent)
					to_chat(H, SPAN_WARNING("You need a suit before you can attach [src]."))
				return FALSE
	return TRUE

/**
 * automatically uneqiup if we're missing beltlink
 */
/obj/item/proc/reconsider_beltlink()
	var/mob/M = loc
	if(!istype(M))
		return
	if(!current_equipped_slot)
		return
	if(!equip_check_beltlink(M, current_equipped_slot, null, TRUE))
		M.drop_item_to_ground(src)
		return

/**
 * checks if we can fit over something
 */
/obj/item/proc/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, silent, disallow_delay, igonre_fluff)
	return FALSE

/**
 * call when we fit us over something - item should be already in us
 */
/obj/item/proc/equip_on_worn_over_insert(mob/M, slot, mob/user, obj/item/I, silent)
	if(!silent)
		to_chat(M, SPAN_NOTICE("You slip [src] over [I]."))

/**
 * call when we unfit us over something - item should already be out of us
 */
/obj/item/proc/equip_on_worn_over_remove(mob/M, slot, mob/user, obj/item/I, silent)

/**
 * get the mob we're equipped on
 */
/obj/item/proc/current_equipped_mob()
	RETURN_TYPE(/mob)
	var/obj/item/I = worn_inside
	return I?.current_equipped_mob() || (current_equipped_slot? (I? I.current_equipped_mob() : loc) : null)

// forcemove hook to ensure proper functionality when inv procs aren't called
/obj/item/forceMove(atom/destination)
	if(current_equipped_slot)
		// inventory handling
		if(destination == loc)
			return ..()
		if(destination == worn_inside)
			return ..()
		var/mob/M = current_equipped_mob()
		if(!ismob(M))
			stack_trace("item forcemove inv hook called without a mob as loc??")
		M.temporarily_remove_from_inventory(src, TRUE)
	return ..()
