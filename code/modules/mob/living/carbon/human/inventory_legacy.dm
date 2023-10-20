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
