/**
 * smart equips an item - puts in a slot or tries to put it in storage.
 */
/mob/proc/smart_equip(obj/item/I)
	if(equip_to_appropriate_slot(I, INV_OP_SUPPRESS_WARNING))
		return TRUE
	if(equip_to_slot_if_possible(I, /datum/inventory_slot/abstract/put_in_storage_try_active, INV_OP_SUPPRESS_WARNING))
		return TRUE
	to_chat(src, SPAN_WARNING("You have nowhere to put [I]!"))
	return FALSE

/**
 * call this one instead of smart_equip directly from verbs.
 */
/mob/proc/attempt_smart_equip(obj/item/I = get_active_held_item(), silent = FALSE)
	if(!I)
		if(!silent)
			to_chat(src, SPAN_WARNING("You are not holding anything to equip!"))
		return FALSE

	if(!is_holding(I))
		if(!silent)
			to_chat(src, SPAN_WARNING("You must be holding [I] to equip it!"))
		return FALSE

	return smart_equip(I)

/**
 * kicks out all physical restraints on us
 */
/mob/proc/remove_all_restraints()
	drop_slots_to_ground(list(SLOT_ID_HANDCUFFED, SLOT_ID_LEGCUFFED), INV_OP_FORCE)
	var/obj/item/suit_check = item_by_slot_id(SLOT_ID_SUIT)
	if(istype(suit_check, /obj/item/clothing/suit/straight_jacket))
		drop_item_to_ground(suit_check, INV_OP_FORCE)
	// guess at if it's a bad thing
	// todo: actual flag like BUCKLING_IS_CONSIDERED_RESTRICTING or something
	if(buckled?.buckle_flags & (BUCKLING_NO_DEFAULT_RESIST | BUCKLING_NO_DEFAULT_UNBUCKLE))
		unbuckle(BUCKLE_OP_FORCE)
