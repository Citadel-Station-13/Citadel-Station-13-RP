/// This is a generic proc that should be called by other ling armor procs to equip them.
/mob/proc/changeling_generic_armor(armor_type, helmet_type, boot_type, chem_cost)

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		chem_cost = 0

	var/datum/changeling/changeling = changeling_power(chem_cost, 1, 100, CONSCIOUS)

	if(!changeling)
		return

	//First, check if we're already wearing the armor, and if so, take it off.
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		M.visible_message(
			SPAN_WARNING("[M] casts off their [M.wear_suit.name]!"),
			SPAN_WARNING("We cast off our [M.wear_suit.name]"),
			SPAN_HEAR("You hear the organic matter ripping and tearing!"),
		)
		if(istype(M.wear_suit, armor_type))
			qdel(M.wear_suit)
		if(istype(M.head, helmet_type))
			qdel(M.head)
		if(istype(M.shoes, boot_type))
			qdel(M.shoes)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		M.update_inv_shoes()
		return 1

	if(M.head || M.wear_suit) //Make sure our slots aren't full
		to_chat(src, SPAN_WARNING("We require nothing to be on our head, and we cannot wear any external suits, or shoes."))
		return 0

	var/obj/item/clothing/suit/A = new armor_type(src)
	src.equip_to_slot_or_del(A, SLOT_ID_SUIT)

	var/obj/item/clothing/suit/H = new helmet_type(src)
	src.equip_to_slot_or_del(H, SLOT_ID_HEAD)

	var/obj/item/clothing/shoes/B = new boot_type(src)
	src.equip_to_slot_or_del(B, SLOT_ID_SHOES)

	src.mind.changeling.chem_charges -= chem_cost
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	M.update_inv_shoes()
	return 1

/mob/proc/changeling_generic_equip_all_slots(list/stuff_to_equip, cost)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	var/success = 0

	//First, check if we're already wearing the armor, and if so, take it off.

	if(M.mind.changeling.armor_deployed)
		if(M.head && stuff_to_equip["head"])
			if(istype(M.head, stuff_to_equip["head"]))
				qdel(M.head)
				success = 1

		if(M.wear_id && stuff_to_equip["wear_id"])
			if(istype(M.wear_id, stuff_to_equip["wear_id"]))
				qdel(M.wear_id)
				success = 1

		if(M.wear_suit && stuff_to_equip["wear_suit"])
			if(istype(M.wear_suit, stuff_to_equip["wear_suit"]))
				qdel(M.wear_suit)
				success = 1

		if(M.gloves && stuff_to_equip["gloves"])
			if(istype(M.gloves, stuff_to_equip["gloves"]))
				qdel(M.gloves)
				success = 1
		if(M.shoes && stuff_to_equip["shoes"])
			if(istype(M.shoes, stuff_to_equip["shoes"]))
				qdel(M.shoes)
				success = 1

		if(M.belt && stuff_to_equip["belt"])
			if(istype(M.belt, stuff_to_equip["belt"]))
				qdel(M.belt)
				success = 1

		if(M.glasses && stuff_to_equip["glasses"])
			if(istype(M.glasses, stuff_to_equip["glasses"]))
				qdel(M.glasses)
				success = 1

		if(M.wear_mask && stuff_to_equip["wear_mask"])
			if(istype(M.wear_mask, stuff_to_equip["wear_mask"]))
				qdel(M.wear_mask)
				success = 1

		if(M.back && stuff_to_equip["back"])
			if(istype(M.back, stuff_to_equip["back"]))
				for(var/atom/movable/AM in M.back.contents) //Dump whatever's in the bag before deleting.
					AM.forceMove(src.loc)
				qdel(M.back)
				success = 1

		if(M.w_uniform && stuff_to_equip["w_uniform"])
			if(istype(M.w_uniform, stuff_to_equip["w_uniform"]))
				qdel(M.w_uniform)
				success = 1

		if(success)
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			visible_message(
				SPAN_WARNING("[src] pulls on their clothes, peeling it off along with parts of their skin attached!"),
				SPAN_NOTICE("We remove and deform our equipment."),
				SPAN_HEAR("You hear the horrible sound of ripping skin."),
			)
		M.mind.changeling.armor_deployed = 0
		return success

	else

		to_chat(M, SPAN_NOTICE("We begin growing our new equipment..."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, TRUE)

		var/list/grown_items_list = list()

		var/t = stuff_to_equip["head"]
		if(!M.head && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_HEAD)
			grown_items_list.Add("a helmet")
			success = 1

		t = stuff_to_equip["w_uniform"]
		if(!M.w_uniform && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_UNIFORM)
			grown_items_list.Add("a uniform")
			success = 1

		t = stuff_to_equip["gloves"]
		if(!M.gloves && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_GLOVES)
			grown_items_list.Add("some gloves")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1

		t = stuff_to_equip["shoes"]
		if(!M.shoes && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_SHOES)
			grown_items_list.Add("shoes")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1

		t = stuff_to_equip["belt"]
		if(!M.belt && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_BELT)
			grown_items_list.Add("a belt")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1

		t = stuff_to_equip["glasses"]
		if(!M.glasses && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_GLASSES)
			grown_items_list.Add("some glasses")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1

		t = stuff_to_equip["wear_mask"]
		if(!M.wear_mask && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_MASK)
			grown_items_list.Add("a mask")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1

		t = stuff_to_equip["back"]
		if(!M.back && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_BACK)
			grown_items_list.Add("a backpack")
			success = 1

		t = stuff_to_equip["wear_suit"]
		if(!M.wear_suit && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_SUIT)
			grown_items_list.Add("an exosuit")
			success = 1

		t = stuff_to_equip["wear_id"]
		if(!M.wear_id && t)
			var/obj/item/I = new t
			ADD_TRAIT(I, TRAIT_NODROP, CHANGELING_TRAIT)
			M.equip_to_slot_or_del(I, SLOT_ID_WORN_ID)
			grown_items_list.Add("an ID card")
			playsound(src, 'sound/effects/splat.ogg', 30, TRUE)
			success = 1

		var/feedback = english_list(grown_items_list, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )

		to_chat(M, SPAN_NOTICE("We have grown [feedback]."))

		if(success)
			M.mind.changeling.armor_deployed = 1
			M.mind.changeling.chem_charges -= 10
		return success

/// This is a generic proc that should be called by other ling weapon procs to equip them.
/mob/proc/changeling_generic_weapon(weapon_type, make_sound = TRUE, cost = 20)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if(M.hands_full()) //Make sure our hands aren't full.
		to_chat(src, SPAN_WARNING("Our hands are full.  Drop something first."))
		return 0

	var/obj/item/W = new weapon_type(src)
	src.put_in_hands(W)

	src.mind.changeling.chem_charges -= cost
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, TRUE)
	return 1
