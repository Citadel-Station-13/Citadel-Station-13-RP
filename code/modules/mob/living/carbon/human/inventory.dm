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

/mob/living/carbon/human/_set_inv_slot(slot, obj/item/I, update_icons)
	switch(slot)
		if(SLOT_ID_SUIT)
			wear_suit = I
			if(update_icons)
				update_inv_wear_suit()
		if(SLOT_ID_UNIFORM)
			w_uniform = I
			if(update_icons)
				update_inv_w_uniform()
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
		. += wear_suit
	if(w_uniform)
		. += w_uniform
	if(shoes)
		. += shoes
	if(belt)
		. += belt
	if(gloves)
		. += gloves
	if(glasses)
		. += glasses
	if(head)
		. += head
	if(l_ear)
		. += l_ear
	if(r_ear)
		. += r_ear
	if(wear_id)
		. += wear_id
	if(r_store)
		. += r_store
	if(l_store)
		. += l_store
	if(s_store)
		. += s_store

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

/mob/living/carbon/human/proc/has_organ(name)
	var/obj/item/organ/external/O = organs_by_name[name]
	return (O && !O.is_stump())

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
		if(slot_l_hand)
			return has_organ(BP_L_HAND)
		if(slot_r_hand)
			return has_organ(BP_R_HAND)
		if(SLOT_ID_BELT)
			return has_organ(BP_TORSO)
		if(SLOT_ID_WORN_ID)
			// the only relevant check for this is the uniform check
			return 1
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
		if(SLOT_ID_SUIT_STORE)
			return has_organ(BP_TORSO)
		if(slot_in_backpack)
			return 1
		if(slot_tie)
			return 1

/obj/item/var/suitlink = 1 //makes belt items require a jumpsuit- set individual items to suitlink = 0 to allow wearing on belt slot without suit

/mob/living/carbon/human/u_equip(obj/W as obj)
	if(!W)	return 0

	if (W == wear_suit)
		if(s_store)
			drop_from_inventory(s_store)
		worn_clothing -= wear_suit
		wear_suit = null
		update_inv_wear_suit()
	else if (W == w_uniform)
		if (r_store)
			drop_from_inventory(r_store)
		if (l_store)
			drop_from_inventory(l_store)
		if (wear_id)
			drop_from_inventory(wear_id)
		if (belt && belt.suitlink == 1)
			worn_clothing -= belt
			drop_from_inventory(belt)
		worn_clothing -= w_uniform
		w_uniform = null
		update_inv_w_uniform()
	else if (W == gloves)
		worn_clothing -= gloves
		gloves = null
		update_inv_gloves()
	else if (W == glasses)
		worn_clothing -= glasses
		glasses = null
		update_inv_glasses()
	else if (W == head)
		worn_clothing -= head
		head = null
		if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & (HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR))
				update_hair(0)	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
		update_inv_head()
	else if (W == l_ear)
		l_ear = null
		update_inv_ears()
	else if (W == r_ear)
		r_ear = null
		update_inv_ears()
	else if (W == shoes)
		worn_clothing -= shoes
		shoes = null
		update_inv_shoes()
	else if (W == belt)
		worn_clothing -= belt
		belt = null
		update_inv_belt()
	else if (W == wear_mask)
		worn_clothing -= wear_mask
		wear_mask = null
		if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
				update_hair(0)	//rebuild hair
				update_inv_ears(0)
		if(internal)
			if(internals)
				internals.icon_state = "internal0"
			internal = null
		update_inv_wear_mask()
	else if (W == r_hand)
		r_hand = null
		if(l_hand)
			l_hand.update_twohanding()
			l_hand.update_held_icon()
			update_inv_l_hand()
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		if(r_hand)
			r_hand.update_twohanding()
			r_hand.update_held_icon()
			update_inv_l_hand()
		update_inv_l_hand()
	else
		return 0

	update_action_buttons()
	return 1



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot)

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
	switch(slot)
		if(SLOT_ID_BACK)
			src.back = W
			W.equipped(src, slot)
			worn_clothing += back
			update_inv_back()
		if(SLOT_ID_MASK)
			src.wear_mask = W
			if(wear_mask.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
				update_hair()	//rebuild hair
				update_inv_ears()
			W.equipped(src, slot)
			worn_clothing += wear_mask
			update_inv_wear_mask()
		if(SLOT_ID_HANDCUFFED)
			src.handcuffed = W
			update_handcuffed()
		if(SLOT_ID_LEGCUFFED)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed()
		if(slot_l_hand)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand()
		if(slot_r_hand)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand()
		if(SLOT_ID_BELT)
			src.belt = W
			W.equipped(src, slot)
			worn_clothing += belt
			update_inv_belt()
		if(SLOT_ID_WORN_ID)
			src.wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id()
			update_hud_sec_job()
			update_hud_sec_status()
		if(SLOT_ID_LEFT_EAR)
			src.l_ear = W
			if(l_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.forceMove(src)
				src.r_ear = O
				O.hud_layerise()
			W.equipped(src, slot)
			update_inv_ears()
		if(SLOT_ID_RIGHT_EAR)
			src.r_ear = W
			if(r_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.forceMove(src)
				src.l_ear = O
				O.hud_layerise()
			W.equipped(src, slot)
			update_inv_ears()
		if(SLOT_ID_GLASSES)
			src.glasses = W
			W.equipped(src, slot)
			update_inv_glasses()
		if(SLOT_ID_GLOVES)
			src.gloves = W
			W.equipped(src, slot)
			worn_clothing += glasses
			update_inv_gloves()
		if(SLOT_ID_HEAD)
			src.head = W
			if(head.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR|HIDEMASK))
				update_hair()	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
			if(istype(W,/obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			worn_clothing += head
			update_inv_head()
		if(SLOT_ID_SHOES)
			src.shoes = W
			W.equipped(src, slot)
			worn_clothing += shoes
			update_inv_shoes()
		if(SLOT_ID_SUIT)
			src.wear_suit = W
			W.equipped(src, slot)
			worn_clothing += wear_suit
			update_inv_wear_suit()
		if(SLOT_ID_UNIFORM)
			src.w_uniform = W
			W.equipped(src, slot)
			worn_clothing += w_uniform
			update_inv_w_uniform()
		if(SLOT_ID_LEFT_POCKET)
			src.l_store = W
			W.equipped(src, slot)
			//update_inv_pockets() //Doesn't do anything
		if(SLOT_ID_RIGHT_POCKET)
			src.r_store = W
			W.equipped(src, slot)
			//update_inv_pockets() //Doesn't do anything
		if(SLOT_ID_SUIT_STORE)
			src.s_store = W
			W.equipped(src, slot)
			update_inv_s_store()
		if(slot_in_backpack)
			if(src.get_active_held_item() == W)
				src.remove_from_mob(W)
			W.forceMove(back)
		#warn move to handle_abstract_slot_insertion
		if(slot_tie)
			for(var/obj/item/clothing/C in worn_clothing)
				if(istype(W, /obj/item/clothing/accessory))
					var/obj/item/clothing/accessory/A = W
					if(C.attempt_attach_accessory(A, src))
						return
		else
			to_chat(src, "<font color='red'>You are trying to equip this item to an unsupported inventory slot. How the heck did you manage that? Stop it...</font>")
			return

	if((W == src.l_hand) && (slot != slot_l_hand))
		src.l_hand = null
		update_inv_l_hand() //So items actually disappear from hands.
	else if((W == src.r_hand) && (slot != slot_r_hand))
		src.r_hand = null
		update_inv_r_hand()

	W.hud_layerise()

	if(W.action_button_name)
		update_action_buttons()

	if(W.zoom)
		W.zoom()

	W.in_inactive_hand(src)

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

/mob/living/carbon/human/get_equipped_item(var/slot)
	switch(slot)
		if(SLOT_ID_BACK)       return back
		if(SLOT_ID_LEGCUFFED)  return legcuffed
		if(SLOT_ID_HANDCUFFED) return handcuffed
		if(SLOT_ID_LEFT_POCKET)    return l_store
		if(SLOT_ID_RIGHT_POCKET)    return r_store
		if(SLOT_ID_MASK)  return wear_mask
		if(slot_l_hand)     return l_hand
		if(slot_r_hand)     return r_hand
		if(SLOT_ID_WORN_ID)    return wear_id
		if(SLOT_ID_GLASSES)    return glasses
		if(SLOT_ID_GLOVES)     return gloves
		if(SLOT_ID_HEAD)       return head
		if(SLOT_ID_SHOES)      return shoes
		if(SLOT_ID_BELT)       return belt
		if(SLOT_ID_SUIT)  return wear_suit
		if(SLOT_ID_UNIFORM)  return w_uniform
		if(SLOT_ID_SUIT_STORE)    return s_store
		if(SLOT_ID_LEFT_EAR)      return l_ear
		if(SLOT_ID_RIGHT_EAR)      return r_ear
	return ..()

/mob/living/carbon/human/put_in_l_hand(var/obj/item/W)
	if(!..() || l_hand)
		return 0
	W.forceMove(src)
	l_hand = W
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return 1

/mob/living/carbon/human/put_in_r_hand(var/obj/item/W)
	if(!..() || r_hand)
		return 0
	W.forceMove(src)
	r_hand = W
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return 1

/* nah no dcs storage.. yet.
/mob/living/carbon/human/proc/smart_equipbag() // take most recent item out of bag or place held item in bag
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = get_item_by_slot(ITEM_SLOT_BACK)
	if(!equipped_back) // We also let you equip a backpack like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no backpack to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, ITEM_SLOT_BACK))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_back, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_back.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in backpack
		if(!SEND_SIGNAL(equipped_back, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
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
	var/obj/item/equipped_belt = get_item_by_slot(ITEM_SLOT_BELT)
	if(!equipped_belt) // We also let you equip a belt like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no belt to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, ITEM_SLOT_BELT))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_belt, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_belt.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in belt
		if(!SEND_SIGNAL(equipped_belt, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(!equipped_belt.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your belt to take out!</span>")
		return
	var/obj/item/stored = equipped_belt.contents[equipped_belt.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from belt
*/

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
		S.handle_item_insertion(thing)
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
		S.handle_item_insertion(thing)
		return
	if(!equipped_belt.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your belt to take out!</span>")
		return
	var/obj/item/stored = equipped_belt.contents[equipped_belt.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from belt
