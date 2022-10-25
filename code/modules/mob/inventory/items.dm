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
 * called when an item is equipped to inventory or picked up
 *
 * @params
 * user - person equipping us
 * slot - slot id we're equipped to
 * flags - inventory operation flags, see defines
 */
/obj/item/proc/equipped(mob/user, slot, flags)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot, flags)
	worn_slot = slot
	if(!(flags & INV_OP_IS_ACCESSORY))
		// todo: shouldn't be in here
		hud_layerise()
		// todo: shouldn't be in here
		if(user)
			user.position_hud_item(src, slot)
			user.client?.screen |= src
	if((slot != SLOT_ID_HANDS) && equip_sound)
		playsound(src, equip_sound, 30, ignore_walls = FALSE)
	user.update_inv_hands()

/**
 * called when an item is unequipped from inventory or moved around in inventory
 *
 * @params
 * user - person unequipping us
 * slot - slot id we're unequipping from
 * flags - inventory operation flags, see defines
 */
/obj/item/proc/unequipped(mob/user, slot, flags)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user, slot, flags)
	worn_slot = null
	if(!(flags & INV_OP_IS_ACCESSORY))
		// todo: shouldn't be in here
		hud_unlayerise()
		// todo: shouldn't be in here
		screen_loc = null
		user?.client?.screen -= src
	if(!(flags & INV_OP_DIRECTLY_DROPPING) && (slot != SLOT_ID_HANDS) && unequip_sound)
		playsound(src, unequip_sound, 30, ignore_walls = FALSE)

/**
 * called when a mob drops an item
 *
 * ! WARNING: You CANNOT assume we are post or pre-move on dropped.
 * ! If unequipped() deletes the item, loc will be null. Sometimes, loc won't change at all!
 *
 * dropping is defined as moving out of both equipment slots and hand slots
 */
/obj/item/proc/dropped(mob/user, flags, atom/newLoc)
	SHOULD_CALL_PARENT(TRUE)
/*
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
*/
	if((item_flags & ITEM_DROPDEL) && !(flags & INV_OP_DELETING))
		qdel(src)

	hud_unlayerise()
	item_flags &= ~IN_INVENTORY

	. = SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user, flags, newLoc)

	if(!(flags & INV_OP_SUPPRESS_SOUND) && isturf(newLoc) && !(. & COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND))
		playsound(src, drop_sound, 30, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc

	return ((. & COMPONENT_ITEM_DROPPED_RELOCATE)? ITEM_RELOCATED_BY_DROPPED : NONE)

/**
 * called when a mob picks up an item
 *
 * picking up is defined as moving into either an equipment slot, or hand slots
 */
/obj/item/proc/pickup(mob/user, flags, atom/oldLoc)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user, flags, oldLoc)
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	hud_layerise()
	item_flags |= IN_INVENTORY
	if(isturf(oldLoc) && !(flags & (INV_OP_SILENT | INV_OP_DIRECTLY_EQUIPPING)))
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
 * returns either an item or a list
 * get_equipped_items() uses this so accessories are included
 */
/obj/item/proc/_inv_return_attached()
	if(worn_over)
		return list(src) + worn_over._inv_return_attached()
	else
		return src

// todo: item should get final say for "soft" aka not-literal-var-overwrite conflicts.

/**
 * checks if a mob can equip us to a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 */
/obj/item/proc/can_equip(mob/M, slot, mob/user, flags)
	if(!equip_check_beltlink(M, slot, user, flags))
		return FALSE
	return TRUE

/**
 * checks if a mob can unequip us from a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 */
/obj/item/proc/can_unequip(mob/M, slot, mob/user, flags)
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
/obj/item/proc/equip_check_beltlink(mob/M, slot, mob/user, flags)
	if(clothing_flags & EQUIP_IGNORE_BELTLINK)
		return TRUE

	if(!ishuman(M))
		return TRUE

	var/mob/living/carbon/human/H = M

	switch(slot)
		if(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_WORN_ID)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_BELT)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_SUIT_STORAGE)
			if(H.semantically_has_slot(SLOT_ID_SUIT) && !H.item_by_slot(SLOT_ID_SUIT))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
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
	if(!worn_slot)
		return
	if(!equip_check_beltlink(M, worn_slot, null, INV_OP_SILENT))
		M.drop_item_to_ground(src)
		return

/**
 * checks if we can fit over something
 */
/obj/item/proc/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	return FALSE

/**
 * call when we fit us over something - item should be already in us
 */
/obj/item/proc/equip_on_worn_over_insert(mob/M, slot, mob/user, obj/item/I, flags)
	if(!(flags & INV_OP_SUPPRESS_WARNING))
		to_chat(M, SPAN_NOTICE("You slip [src] over [I]."))

/**
 * call when we unfit us over something - item should already be out of us
 */
/obj/item/proc/equip_on_worn_over_remove(mob/M, slot, mob/user, obj/item/I, flags)

/**
 * get the mob we're equipped on
 */
/obj/item/proc/worn_mob()
	RETURN_TYPE(/mob)
	return worn_inside?.worn_mob() || (worn_slot? loc : null)

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

/**
 * checks if we're in inventory. if so, returns mob we're in
 * **hands count**
 */
/obj/item/proc/is_in_inventory(include_hands)
	return (worn_slot && ((worn_slot != SLOT_ID_HANDS) || include_hands)) && worn_mob()

/**
 * checks if we're worn. if so, return mob we're in
 *
 * note: this is not the same as is_in_inventory, we check if it's a clothing/worn slot in this case!
 */
/obj/item/proc/is_being_worn()
	if(!worn_slot)
		return FALSE
	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(worn_slot)
	return slot_meta.inventory_slot_flags & INV_SLOT_CONSIDERED_WORN

/**
 * get strip menu options by  href key associated to name.
 */
/obj/item/proc/strip_menu_options(mob/user)
	RETURN_TYPE(/list)
	return list()

/**
 * strip menu act
 *
 * adjacency is pre-checked.
 * return TRUE to refresh
 */
/obj/item/proc/strip_menu_act(mob/user, action)
	return FALSE

/**
 * standard do after for interacting from strip menu
 */
/obj/item/proc/strip_menu_standard_do_after(mob/user, delay)
	. = FALSE
	var/slot = worn_slot
	if(!slot)
		CRASH("no worn slot")
	var/mob/M = worn_mob()
	if(!M)
		CRASH("no worn mob")
	if(!M.strip_interaction_prechecks(user))
		return
	if(!do_after(user, delay, M, FALSE))
		return
	if(slot != worn_slot || M != worn_mob())
		return
	return TRUE
