//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/living/carbon/human/_slot_by_item(obj/item/I)
	if(wear_suit == I)
		return SLOT_ID_SUIT
	else if(w_uniform == I)
		return SLOT_ID_UNIFORM
	else if(shoes == I)
		return SLOT_ID_SHOES
	else if(belt == I)
		return SLOT_ID_BELT
	else if(gloves == I)
		return SLOT_ID_GLOVES
	else if(glasses == I)
		return SLOT_ID_GLASSES
	else if(head == I)
		return SLOT_ID_HEAD
	else if(l_ear == I)
		return SLOT_ID_LEFT_EAR
	else if(r_ear == I)
		return SLOT_ID_RIGHT_EAR
	else if(wear_id)
		return SLOT_ID_WORN_ID
	else if(r_store == I)
		return SLOT_ID_RIGHT_POCKET
	else if(l_store == I)
		return SLOT_ID_LEFT_POCKET
	else if(s_store == I)
		return SLOT_ID_SUIT_STORAGE
	else
		return ..()

/mob/living/carbon/human/_item_by_slot(slot)
	switch(slot)
		if(SLOT_ID_SUIT)
			return wear_suit
		if(SLOT_ID_UNIFORM)
			return w_uniform
		if(SLOT_ID_BELT)
			return belt
		if(SLOT_ID_SHOES)
			return shoes
		if(SLOT_ID_GLOVES)
			return gloves
		if(SLOT_ID_GLASSES)
			return glasses
		if(SLOT_ID_HEAD)
			return head
		if(SLOT_ID_LEFT_EAR)
			return l_ear
		if(SLOT_ID_RIGHT_EAR)
			return r_ear
		if(SLOT_ID_WORN_ID)
			return wear_id
		if(SLOT_ID_RIGHT_POCKET)
			return r_store
		if(SLOT_ID_LEFT_POCKET)
			return l_store
		if(SLOT_ID_SUIT_STORAGE)
			return s_store
		else
			return ..()

/mob/living/carbon/human/_set_inv_slot(slot, obj/item/I, flags)
	switch(slot)
		if(SLOT_ID_SUIT)
			wear_suit = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_wear_suit()
			if(!(flags & INV_OP_NO_LOGIC))
				if(!wear_suit)
					s_store?.reconsider_beltlink()
		if(SLOT_ID_UNIFORM)
			w_uniform = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_w_uniform()
			if(!(flags & INV_OP_NO_LOGIC))
				if(!w_uniform)
					l_store?.reconsider_beltlink()
					r_store?.reconsider_beltlink()
					wear_id?.reconsider_beltlink()
					belt?.reconsider_beltlink()
		if(SLOT_ID_SHOES)
			shoes = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_shoes()
		if(SLOT_ID_BELT)
			belt = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_belt()
		if(SLOT_ID_GLOVES)
			gloves = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_gloves()
		if(SLOT_ID_GLASSES)
			glasses = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_glasses()
		if(SLOT_ID_HEAD)
			head = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_head()
				// todo: only rebuild when needed for HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR
				update_hair(0)
				update_inv_ears()
				update_inv_wear_mask()
		if(SLOT_ID_LEFT_EAR)
			l_ear = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_ears()
		if(SLOT_ID_RIGHT_EAR)
			r_ear = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_ears()
		if(SLOT_ID_WORN_ID)
			wear_id = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_wear_id()
			update_hud_sec_job()
			update_hud_sec_status()
		if(SLOT_ID_RIGHT_POCKET)
			r_store = I
		if(SLOT_ID_LEFT_POCKET)
			l_store = I
		if(SLOT_ID_SUIT_STORAGE)
			s_store = I
			update_inv_s_store()
		else
			return ..()

/mob/living/carbon/human/_get_all_slots(include_restraints)
	. = ..()
	if(wear_suit)
		. += wear_suit.inv_slot_attached()
	if(w_uniform)
		. += w_uniform.inv_slot_attached()
	if(shoes)
		. += shoes.inv_slot_attached()
	if(belt)
		. += belt.inv_slot_attached()
	if(gloves)
		. += gloves.inv_slot_attached()
	if(glasses)
		. += glasses.inv_slot_attached()
	if(head)
		. += head.inv_slot_attached()
	if(l_ear)
		. += l_ear.inv_slot_attached()
	if(r_ear)
		. += r_ear.inv_slot_attached()
	if(wear_id)
		. += wear_id.inv_slot_attached()
	if(r_store)
		. += r_store.inv_slot_attached()
	if(l_store)
		. += l_store.inv_slot_attached()
	if(s_store)
		. += s_store.inv_slot_attached()

/mob/living/carbon/human/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_SUIT,
		SLOT_ID_UNIFORM,
		SLOT_ID_SHOES,
		SLOT_ID_BELT,
		SLOT_ID_GLOVES,
		SLOT_ID_GLASSES,
		SLOT_ID_HEAD,
		SLOT_ID_LEFT_EAR,
		SLOT_ID_RIGHT_EAR,
		SLOT_ID_LEFT_POCKET,
		SLOT_ID_RIGHT_POCKET,
		SLOT_ID_WORN_ID,
		SLOT_ID_SUIT_STORAGE
	)

/mob/living/carbon/human/put_in_left_hand(obj/item/I, force)
	if(!has_organ(BP_L_HAND))
		return FALSE
	return ..()

/mob/living/carbon/human/put_in_right_hand(obj/item/I, force)
	if(!has_organ(BP_R_HAND))
		return FALSE
	return ..()

// todo: this should eventually be on the datum itself probably
/mob/living/carbon/human/inventory_slot_reachability_conflict(obj/item/I, slot, mob/user)
	. = ..()
	if(.)
		return

	var/obj/item/covering
	var/extra_flags

	switch(slot)
		if(SLOT_ID_MASK)
			covering = head
			extra_flags = FACE
		if(SLOT_ID_GLASSES)
			covering = head
			extra_flags = EYES
		if(SLOT_ID_GLOVES, SLOT_ID_UNIFORM)
			covering = wear_suit

	if(!covering)
		return

	if(!(covering.body_cover_flags & (I.body_cover_flags | extra_flags)))
		return

	return covering

/mob/living/carbon/human/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	var/self_equip = user == src

	if(!semantically_has_slot(slot))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] have nowhere to put that!"))
		return FALSE

	// then, check bodyparts
	if(I.clothing_flags & CLOTHING_IGNORE_DELIMB)
		return TRUE
	var/allow_single = (I.clothing_flags & CLOTHING_ALLOW_SINGLE_LIMB)

	var/has_part = TRUE
	var/part_text
	var/override_text
	switch(slot)
		if(SLOT_ID_BACK, SLOT_ID_BELT, SLOT_ID_SUIT, SLOT_ID_LEFT_POCKET, \
			SLOT_ID_RIGHT_POCKET, SLOT_ID_SUIT_STORAGE, SLOT_ID_UNIFORM)
			has_part = has_organ(BP_TORSO)
			part_text = "torso. How?"
		if(SLOT_ID_MASK, SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR, \
			SLOT_ID_GLASSES, SLOT_ID_HEAD)
			has_part = has_organ(BP_HEAD)
			part_text = "head"
		if(SLOT_ID_HANDCUFFED, SLOT_ID_GLOVES)
			if(allow_single)
				has_part = has_organ(BP_L_HAND) || has_organ(BP_R_HAND)
				override_text = SPAN_WARNING("[self_equip? "You" : "They"] need a hand!")
			else
				has_part = has_organ(BP_L_HAND) && has_organ(BP_R_HAND)
				override_text = SPAN_WARNING("[self_equip? "You" : "They"] are missing a hand!")
		if(SLOT_ID_LEGCUFFED, SLOT_ID_SHOES)
			if(allow_single)
				has_part = has_organ(BP_L_FOOT) || has_organ(BP_R_FOOT)
				override_text = SPAN_WARNING("[self_equip? "You" : "They"] need a foot!")
			else
				has_part = has_organ(BP_L_FOOT) && has_organ(BP_R_FOOT)
				override_text = SPAN_WARNING("[self_equip? "You" : "They"] are missing a foot!")

	if(!has_part)
		to_chat(user, override_text || SPAN_WARNING("[self_equip? "You" : "They"] are missing [self_equip? "your" : "their"] [part_text]!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/_semantic_slot_id_check(id)
	. = ..()
	if(!.)
		return
	switch(id)
		if(SLOT_ID_HANDCUFFED)
			return has_hands()
	var/datum/inventory_slot/slot_meta = resolve_inventory_slot(id)
	if(!slot_meta)
		return FALSE
	return !(slot_meta.inventory_slot_flags & INV_SLOT_IS_INVENTORY) || !species || (id in species.inventory_slots)
