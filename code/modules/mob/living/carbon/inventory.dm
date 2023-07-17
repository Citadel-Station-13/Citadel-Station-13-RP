//* Abstraction *//

/mob/living/carbon/_slot_by_item(obj/item/I)
	if(handcuffed == I)
		return SLOT_ID_HANDCUFFED
	if(legcuffed == I)
		return SLOT_ID_LEGCUFFED
	return ..()

/mob/living/carbon/_item_by_slot(slot)
	switch(slot)
		if(SLOT_ID_HANDCUFFED)
			return handcuffed
		if(SLOT_ID_LEGCUFFED)
			return legcuffed
		else
			return ..()

/mob/living/carbon/_set_inv_slot(slot, obj/item/I, flags)
	switch(slot)
		if(SLOT_ID_HANDCUFFED)
			handcuffed = I
			if(!(flags & INV_OP_NO_LOGIC))
				buckled?.buckled_reconsider_restraints()
			// uh oh shitcode alert; call update handcuffed instead
			update_handcuffed()
			// if(!(flags & INV_OP_NO_UPDATE_ICONS))
			// 	update_inv_handcuffed()
		if(SLOT_ID_LEGCUFFED)
			legcuffed = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_legcuffed()
		else
			return ..()

/mob/living/carbon/_get_all_slots(include_restraints)
	. = ..()
	if(include_restraints)
		if(handcuffed)
			. += handcuffed.inv_slot_attached()
		if(legcuffed)
			. += legcuffed.inv_slot_attached()

/mob/living/carbon/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_HANDCUFFED,
		SLOT_ID_LEGCUFFED
	)

//* Hands *//

/mob/living/carbon/proc/get_active_hand_organ_key()
	return get_hand_organ_key(active_hand)

/mob/living/carbon/proc/get_active_hand_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return get_organ(get_hand_organ_key(active_hand))

/mob/living/carbon/proc/get_hand_organ_key(index)
	#warn impl

/mob/living/carbon/proc/get_hand_organ(index)
	return get_organ(get_hand_organ_key(index))

/mob/living/carbon/proc/is_hand_functional(index)
	var/obj/item/organ/external/part = get_hand_organ(index)
	#warn impl

/mob/living/carbon/proc/get_hand_index_of_organ(obj/item/organ/external/organ)
	#warn impl

/mob/living/carbon/proc/get_active_arm_organ_key()
	return get_arm_organ_key(active_arm)

/mob/living/carbon/proc/get_active_arm_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return get_organ(get_arm_organ_key(active_hand))

/mob/living/carbon/proc/get_arm_organ_key(index)
	#warn impl

/mob/living/carbon/proc/get_arm_organ(index)
	return get_organ(get_arm_organ_key(index))
