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

//* Hands *//

/mob/proc/swap_hand(to_index)
	var/obj/item/was_active = length(held_items) <= active_hand? held_items[active_hand] : null
	var/old_index = active_hand

	if(isnull(to_index))
		if(active_hand >= length(held_items))
			active_hand = length(held_items)? 1 : null
		else
			++active_hand
	else
		if(to_index > length(held_items))
			return FALSE
		active_hand = to_index

	. = TRUE

	hands_hud?.swap_active_hand(old_index, to_index)

	//! LEGACY
	// We just swapped hands, so the thing in our inactive hand will notice it's not the focus
	if(!isnull(was_active))
		if(was_active.zoom)
			was_active.zoom()
	//! End

/mob/proc/get_active_hand_organ_key()
	return null

/mob/proc/get_active_hand_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return null

/mob/proc/get_hand_organ_key(index)
	return null

/mob/proc/get_hand_organ(index)
	return null

/mob/proc/is_hand_functional(index, manipulation_level)
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

/mob/proc/get_hand_fail_message(index, manipulation_level)
	return "You try to move your [get_generalized_hand_name(index)], and should be able to, but can't. Report this to coders!"

/mob/proc/get_generalized_hand_name(index)
	var/number_on_side = round(index / 2)
	return "[index % 2? "left" : "right"] hand[number_on_side > 1 && " #[number_on_side]"]"

//* Hands - Helpers *//

/mob/proc/standard_hand_usability_check(atom/target, hand_index, manipulation_level)
	if(!is_hand_functional(hand_index, manipulation_level))
		action_feedback(SPAN_WARNING(get_hand_fail_message(hand_index, manipulation_level)), target)

//* Carry Weight

/mob/proc/update_carry_slowdown()
	return

/mob/proc/update_item_slowdown()
	return
