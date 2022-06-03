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

/mob/living/carbon/human/_set_inv_slot(slot, obj/item/I, update_icons, logic)
	switch(slot)
		if(SLOT_ID_SUIT)
			wear_suit = I
			if(update_icons)
				update_inv_wear_suit()
			if(logic)
				if(!wear_suit)
					if(s_store)
						drop_item_to_ground(s_store, TRUE)
		if(SLOT_ID_UNIFORM)
			w_uniform = I
			if(update_icons)
				update_inv_w_uniform()
			if(logic)
				if(!w_uniform)
					if(r_store)
						drop_item_to_ground(r_store, TRUE)
					if(l_store)
						drop_item_to_ground(l_store, TRUE)
					if(wear_id && !(wear_id.item_flags & EQUIP_IGNORE_BELTLINK))
						drop_item_to_ground(wear_id, TRUE)
					if(belt && !(belt.item_flags & EQUIP_IGNORE_BELTLINK))
						drop_item_to_ground(belt, TRUE)
		if(SLOT_ID_SHOES)
			shoes = I
			if(update_icons)
				update_inv_shoes()
		if(SLOT_ID_BELT)
			belt = I
			if(update_icons)
				update_inv_belt()
		if(SLOT_ID_GLOVES)
			gloves = I
			if(update_icons)
				update_inv_gloves()
		if(SLOT_ID_GLASSES)
			glasses = I
			if(update_icons)
				update_inv_glasses()
		if(SLOT_ID_HEAD)
			head = I
			if(update_icons)
				update_inv_head()
				// todo: only rebuild when needed for HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR
				update_hair(0)
				update_inv_ears()
				update_inv_wear_mask()
		if(SLOT_ID_LEFT_EAR)
			l_ear = I
			if(update_icons)
				update_inv_ears()
		if(SLOT_ID_RIGHT_EAR)
			r_ear = I
			if(update_icons)
				update_inv_ears()
		if(SLOT_ID_WORN_ID)
			wear_id = I
			if(update_icons)
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

/mob/living/carbon/human/put_in_left_hand(obj/item/I, force)
	if(!has_organ(BP_L_HAND))
		return FALSE
	return ..()

/mob/living/carbon/human/put_in_right_hand(obj/item/I, force)
	if(!has_organ(BP_R_HAND))
		return FALSE
	return ..()

#warn everything below this line needs evaluated

/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.
*/

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_held_item()
		if(I)
			I.equip_to_best_slot(H)

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot]))
			return slot
	if (del_on_fail)
		qdel(W)
	return null

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(SLOT_ID_BACK)
			return has_organ(BP_TORSO)
		if(SLOT_ID_MASK)
			return has_organ(BP_HEAD)
		if(SLOT_ID_HANDCUFFED)
			return has_organ(BP_L_HAND) && has_organ(BP_R_HAND)
		if(SLOT_ID_LEGCUFFED)
			return has_organ(BP_L_FOOT) && has_organ(BP_R_FOOT)
		if(SLOT_ID_BELT)
			return has_organ(BP_TORSO)
		if(SLOT_ID_LEFT_EAR)
			return has_organ(BP_HEAD)
		if(SLOT_ID_RIGHT_EAR)
			return has_organ(BP_HEAD)
		if(SLOT_ID_GLASSES)
			return has_organ(BP_HEAD)
		if(SLOT_ID_GLOVES)
			return has_organ(BP_L_HAND) || has_organ(BP_R_HAND)
		if(SLOT_ID_HEAD)
			return has_organ(BP_HEAD)
		if(SLOT_ID_SHOES)
			return has_organ(BP_L_FOOT) || has_organ(BP_R_FOOT)
		if(SLOT_ID_SUIT)
			return has_organ(BP_TORSO)
		if(SLOT_ID_UNIFORM)
			return has_organ(BP_TORSO)
		if(SLOT_ID_LEFT_POCKET)
			return has_organ(BP_TORSO)
		if(SLOT_ID_RIGHT_POCKET)
			return has_organ(BP_TORSO)
		if(SLOT_ID_SUIT_STORAGE)
			return has_organ(BP_TORSO)





//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot)

#warn convert remaining behaviors

	if(!slot)
		return
	if(!istype(W))
		return
	if(!has_organ_for_slot(slot))
		return
	#warn abstract check goes before equip slots
	if(!species || !species.hud || !(slot in species.hud.equip_slots))
		return

	W.forceMove(src)

	W.hud_layerise()

	if(W.action_button_name)
		update_action_buttons()

	if(W.zoom)
		W.zoom()

	return 1

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(SLOT_ID_MASK)
			covering = src.head
			check_flags = FACE
		if(SLOT_ID_GLASSES)
			covering = src.head
			check_flags = EYES
		if(SLOT_ID_GLOVES, SLOT_ID_UNIFORM)
			covering = src.wear_suit

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, "<span class='warning'>\The [covering] is in the way.</span>")
		return 0
	return 1


/mob/living/carbon/human/put_in_left_hand(var/obj/item/W)
	if(!..() || l_hand)
		return 0
	W.forceMove(src)
	l_hand = W
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return 1

/mob/living/carbon/human/put_in_right_hand(var/obj/item/W)
	if(!..() || r_hand)
		return 0
	W.forceMove(src)
	r_hand = W
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return 1

/mob/living/carbon/human/proc/smart_equipbag() // take most recent item out of bag or place held item in bag
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = get_equipped_item(SLOT_ID_BACK)
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
	var/obj/item/equipped_belt = get_equipped_item(SLOT_ID_BELT)
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
