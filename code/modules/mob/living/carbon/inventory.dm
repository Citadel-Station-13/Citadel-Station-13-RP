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
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_handcuffed()
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
			. += handcuffed._inv_return_attached()
		if(legcuffed)
			. += legcuffed._inv_return_attached()

/mob/living/carbon/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_HANDCUFFED,
		SLOT_ID_LEGCUFFED
	)
