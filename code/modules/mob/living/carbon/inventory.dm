//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
			. += handcuffed._inv_return_attached()
		if(legcuffed)
			. += legcuffed._inv_return_attached()

/mob/living/carbon/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_HANDCUFFED,
		SLOT_ID_LEGCUFFED
	)

//* carry weight

/mob/living/carbon/carry_weight_to_penalty(amount)
	// https://www.desmos.com/calculator/5o2cx7grbo
	var/carry_strength = physiology.carry_strength + physiology.carry_weight_add
	if(amount < carry_strength)
		return 1
	var/carry_factor = physiology.carry_factor * physiology.carry_weight_factor
	return (1 / (1 + NUM_E ** (carry_factor * (CARRY_WEIGHT_SCALING / carry_strength) * (amount - carry_strength + CARRY_WEIGHT_BIAS * carry_strength) - 5))) * CARRY_WEIGHT_ASYMPTOTE + CARRY_WEIGHT_ASYMPTOTE

/mob/living/carbon/carry_encumbrance_to_penalty(amount)
	// https://www.desmos.com/calculator/5o2cx7grbo
	var/carry_strength = physiology.carry_strength
	if(amount < carry_strength)
		return 1
	var/carry_factor = physiology.carry_factor
	return (1 / (1 + NUM_E ** (carry_factor * (CARRY_WEIGHT_SCALING / carry_strength) * (amount - carry_strength + CARRY_WEIGHT_BIAS * carry_strength) - 5))) * (1 - CARRY_WEIGHT_ASYMPTOTE) + CARRY_WEIGHT_ASYMPTOTE

/mob/living/carbon/get_item_slowdown()
	. = ..()
	if(!isnull(species))
		. *= species.item_slowdown_mod
