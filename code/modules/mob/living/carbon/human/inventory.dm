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
		. += wear_suit._inv_return_attached()
	if(w_uniform)
		. += w_uniform._inv_return_attached()
	if(shoes)
		. += shoes._inv_return_attached()
	if(belt)
		. += belt._inv_return_attached()
	if(gloves)
		. += gloves._inv_return_attached()
	if(glasses)
		. += glasses._inv_return_attached()
	if(head)
		. += head._inv_return_attached()
	if(l_ear)
		. += l_ear._inv_return_attached()
	if(r_ear)
		. += r_ear._inv_return_attached()
	if(wear_id)
		. += wear_id._inv_return_attached()
	if(r_store)
		. += r_store._inv_return_attached()
	if(l_store)
		. += l_store._inv_return_attached()
	if(s_store)
		. += s_store._inv_return_attached()

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

	if(!(covering.body_parts_covered & (I.body_parts_covered | extra_flags)))
		return

	return covering

/mob/living/carbon/human/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	var/self_equip = user == src

	// first, check species
	if(species?.hud?.equip_slots && !(slot in species.hud.equip_slots))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] have nowhere to put that!"))
		return FALSE

	// then, check bodyparts
	if(I.item_flags & EQUIP_IGNORE_DELIMB)
		return
	var/allow_single = (I.item_flags & EQUIP_ALLOW_SINGLE_LIMB)

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
	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(id)
	if(!slot_meta)
		return FALSE
	return !(slot_meta.inventory_slot_flags & INV_SLOT_IS_INVENTORY) || !species || (id in species.hud.gear)

//! old stuff below

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	attempt_smart_equip()

//! old behaviors that i can't be assed to rewrite for now

/mob/living/carbon/human/proc/smart_equipbag() // take most recent item out of bag or place held item in bag
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = item_by_slot(SLOT_ID_BACK)
	if(!equipped_back) // We also let you equip a backpack like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no backpack to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_ID_BACK))
			update_inv_hands()
		return
	if(!istype(equipped_back, /obj/item/storage)) // not a storage item
		if(!thing)
			equipped_back.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in backpack
		var/obj/item/storage/S = equipped_back
		if(!S.can_be_inserted(thing))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
			return
		S.handle_item_insertion(thing, src)
		return
	if(!equipped_back.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your backpack to take out!</span>")
		return
	var/obj/item/stored = equipped_back.contents[equipped_back.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from backpack

/mob/living/carbon/human/proc/smart_equipbelt() // put held thing in belt or take most recent item out of belt
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_belt = item_by_slot(SLOT_ID_BELT)
	if(!equipped_belt) // We also let you equip a belt like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no belt to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_ID_BELT))
			update_inv_hands()
		return
	if(!istype(equipped_belt, /obj/item/storage)) // not a storage item
		if(!thing)
			equipped_belt.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in belt
		var/obj/item/storage/S = equipped_belt
		if(!S.can_be_inserted(thing))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
			return
		S.handle_item_insertion(thing, src)
		return
	if(!equipped_belt.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your belt to take out!</span>")
		return
	var/obj/item/stored = equipped_belt.contents[equipped_belt.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from belt
