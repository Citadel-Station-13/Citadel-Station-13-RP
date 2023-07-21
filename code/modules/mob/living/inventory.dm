
/mob/living/get_number_of_hands()
	return 2

/mob/living/get_number_of_hands()
	return has_hands? 2 : 0

/mob/living/has_hands()
	return has_hands

#warn parse above

//* Abstraction *//

/mob/living/_slot_by_item(obj/item/I)
	if(back == I)
		return SLOT_ID_BACK
	else if(wear_mask == I)
		return SLOT_ID_MASK
	return ..()

/mob/living/_item_by_slot(slot)
	switch(slot)
		if(SLOT_ID_MASK)
			return wear_mask
		if(SLOT_ID_BACK)
			return back
		else
			return ..()

/mob/living/_set_inv_slot(slot, obj/item/I, flags)
	switch(slot)
		if(SLOT_ID_BACK)
			back = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_back()
		if(SLOT_ID_MASK)
			wear_mask = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_wear_mask()
				// todo: only rebuild when needed for BLOCKHAIR|BLOCKHEADHAIR
				update_hair(0)
				update_inv_ears()
			if(!(flags & INV_OP_NO_LOGIC))
				if(!wear_mask)
					// todo: why are internals code shit
					if(internal)
						internal = null
						if(internals)
							internals.icon_state = "internal0"
		else
			return ..()

/mob/living/_get_all_slots(include_restraints)
	. = ..()
	if(back)
		. += back.inv_slot_attached()
	if(wear_mask)
		. += wear_mask.inv_slot_attached()

/mob/living/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_BACK,
		SLOT_ID_MASK
	)

//* Init *//

/mob/living/init_inventory()
	inventory = new(src)

//* Misc - Legacy *//

/mob/living/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(world.time <= next_click) // This isn't really a 'click' but it'll work for our purposes.
		return

	next_click = world.time + 1

	if(istype(loc,/obj/mecha))
		return

	get_active_held_item()?.attack_self(src)

/mob/living/abiotic(full_body)
	if(full_body)
		if(item_considered_abiotic(wear_mask))
			return TRUE
		if(item_considered_abiotic(back))
			return TRUE

	for(var/obj/item/I as anything in get_held_items())
		if(item_considered_abiotic(I))
			return TRUE

	return FALSE
