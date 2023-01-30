/mob/living/get_active_held_item()
	RETURN_TYPE(/obj/item)
	return hand? l_hand : r_hand

/mob/living/get_inactive_held_item()
	RETURN_TYPE(/obj/item)
	return hand? r_hand : l_hand

/mob/living/get_left_held_item()
	RETURN_TYPE(/obj/item)
	return l_hand

/mob/living/get_right_held_item()
	RETURN_TYPE(/obj/item)
	return r_hand

/mob/living/get_held_index(obj/item/I)
	if(l_hand == I)
		return 1
	else if(r_hand == I)
		return 2

/mob/living/get_held_items()
	RETURN_TYPE(/list)
	. = list()
	if(l_hand)
		. += l_hand
	if(r_hand)
		. += r_hand

/mob/living/hands_full()
	return l_hand && r_hand

/mob/living/put_in_active_hand(obj/item/I, flags)
	return hand? put_in_left_hand(I, flags) : put_in_right_hand(I, flags)

/mob/living/put_in_inactive_hand(obj/item/I, flags)
	return hand? put_in_right_hand(I, flags) : put_in_left_hand(I, flags)

/mob/living/get_held_item_of_index(index)
	RETURN_TYPE(/obj/item)
	switch(index)
		if(1)
			return l_hand
		if(2)
			return r_hand

/mob/living/get_number_of_hands()
	return 2

/mob/living/put_in_left_hand(obj/item/I, flags)
	if(!I)
		return TRUE
	if(!has_hands)
		return FALSE
	if(l_hand)
		if(flags & INV_OP_FORCE)
			drop_item_to_ground(l_hand, flags)
		if(l_hand)	// incase drop item fails which is potentially possible
			return FALSE
	if(!_common_handle_put_in_hand(I, flags))
		return FALSE
	l_hand = I
	log_inventory("[key_name(src)] put [I] in hand 1")
	l_hand.update_twohanding()
	l_hand.update_held_icon()
	// ! WARNING: snowflake - at time of equipped, vars aren't set yet.
	position_hud_item(l_hand, SLOT_ID_HANDS)
	update_inv_l_hand()
	return TRUE

/mob/living/put_in_right_hand(obj/item/I, flags)
	if(!I)
		return TRUE
	if(!has_hands)
		return FALSE
	if(r_hand)
		if(flags & INV_OP_FORCE)
			drop_item_to_ground(r_hand, flags)
		if(r_hand)	// incase drop item fails which is potentially possible
			return FALSE
	if(!_common_handle_put_in_hand(I, flags))
		return FALSE
	r_hand = I
	log_inventory("[key_name(src)] put [I] in hand 1")
	r_hand.update_twohanding()
	r_hand.update_held_icon()
	// ! WARNING: snowflake - at time of equipped, vars aren't set yet.
	position_hud_item(r_hand, SLOT_ID_HANDS)
	update_inv_r_hand()
	return TRUE

/mob/living/proc/_common_handle_put_in_hand(obj/item/I, flags)
	// let's not do that if it's deleted!
	if(I && QDELETED(I))
		to_chat(src, SPAN_DANGER("A deleted item [I] ([REF(I)]) was sent into inventory hand procs with flags [flags]. Report this line to coders immediately."))
		to_chat(src, SPAN_DANGER("The inventory system will attempt to reject the bad equip. Glitches may occur."))
		return FALSE
	if(!(I.interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH))
		I.add_fingerprint(src)
	else
		I.add_hiddenprint(src)
	var/existing_slot = is_in_inventory(I)
	if(existing_slot)
		// handle item reequip can fail.
		return _handle_item_reequip(I, SLOT_ID_HANDS, existing_slot, flags)
	// newly equipped
	var/atom/oldLoc = I.loc
	if(I.loc != src)
		I.forceMove(src)
	if(I.loc != src)
		return FALSE
	I.pickup(src, flags, oldLoc)
	I.equipped(src, SLOT_ID_HANDS, flags)
	return TRUE

/mob/living/put_in_hand(obj/item/I, index, flags)
	// TODO: WHEN MULTIHAND IS DONE, BESURE TO MAKE THIS HAVE THE LOGIC I PUT INI PUT IN L/R HANDS!!
	switch(index)
		if(1)
			return put_in_left_hand(I, flags)
		if(2)
			return put_in_right_hand(I, flags)

/mob/living/_unequip_held(obj/item/I, flags)
	if(l_hand == I)
		l_hand = null
	else if(r_hand == I)
		r_hand = null
	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hands()

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
		. += back._inv_return_attached()
	if(wear_mask)
		. += wear_mask._inv_return_attached()

/mob/living/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_BACK,
		SLOT_ID_MASK
	)

/mob/living/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	if ((!( istype(l_hand, /obj/item/grab) ) && !( istype(r_hand, /obj/item/grab) )))
		if (!( L ))
			return null
		else
			return L.container
	else
		if (!( L ))
			L = new /obj/effect/list_container/mobl( null )
			L.container += src
			L.master = src
		if (istype(l_hand, /obj/item/grab))
			var/obj/item/grab/G = l_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (istype(r_hand, /obj/item/grab))
			var/obj/item/grab/G = r_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (!( flag ))
			if (L.master == src)
				var/list/temp = list(  )
				temp += L.container
				//L = null
				qdel(L)
				return temp
			else
				return L.container
	return

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

/mob/living/get_number_of_hands()
	return has_hands? 2 : 0

/mob/living/has_hands()
	return has_hands
