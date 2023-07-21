// todo: see all this? needs to be decided what to do with and shoved into the inventory handling system proper once evaluated.

/mob
	var/obj/item/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(var/slot)
	var/obj/item/W = get_active_held_item()

	var/obj/item/E = item_by_slot(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

//! helpers below

/**
 * smart equips an item - puts in a slot or tries to put it in storage.
 */
/mob/proc/smart_equip(obj/item/I)
	if(equip_to_appropriate_slot(I, INV_OP_SUPPRESS_WARNING))
		return TRUE
	if(equip_to_slot_if_possible(I, /datum/inventory_slot_meta/abstract/put_in_storage_try_active, INV_OP_SUPPRESS_WARNING))
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
	var/obj/item/suit_check = item_by_slot(SLOT_ID_SUIT)
	if(istype(suit_check, /obj/item/clothing/suit/straight_jacket))
		drop_item_to_ground(suit_check, INV_OP_FORCE)
	// guess at if it's a bad thing
	// todo: actual flag like BUCKLING_IS_CONSIDERED_RESTRICTING or something
	if(buckled?.buckle_flags & (BUCKLING_NO_DEFAULT_RESIST | BUCKLING_NO_DEFAULT_UNBUCKLE))
		unbuckle(BUCKLE_OP_FORCE)

//* Hands *//

/mob/proc/swap_hand(to_index)
	#warn impl

/mob/proc/get_active_hand_organ_key()
	return null

/mob/proc/get_active_hand_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return null

/mob/proc/get_hand_organ_key(index)
	return null

/mob/proc/get_hand_organ(index)
	return null

/mob/proc/is_hand_functional(index, fine_manipulation)
	return TRUE

/mob/proc/get_hand_index_of_organ(obj/item/organ/external/organ)
	return null

/mob/proc/get_active_arm_organ_key()
	return null

/mob/proc/get_active_arm_organ()
	return null

/mob/proc/get_arm_organ_key(index)
	return null

/mob/proc/get_arm_organ(index)
	return null

/mob/proc/get_hand_fail_message(index)
	return "You try to move your [get_generalized_hand_name(index)], and should be able to, but can't. Report this to coders!"

/mob/proc/get_generalized_hand_name(index)
	var/number_on_side = round(index / 2)
	return "[index % 2? "left" : "right"] hand[number_on_side > 1 && " #[number_on_side]"]"
