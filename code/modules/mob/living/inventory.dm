/mob/living/get_active_held_item()
	return hand? l_hand : r_hand

/mob/living/get_inactive_held_item()
	return hand? r_hand : l_hand

/mob/living/get_held_index(obj/item/I)
	if(l_hand == I)
		return 1
	else if(r_hand == I)
		return 2

/mob/living/get_held_items()
	. = list()
	if(l_hand)
		. += l_hand
	if(r_hand)
		. += r_hand

/mob/living/hands_full()
	return l_hand && r_hand

/mob/living/put_in_active_hawd(obj/item/I, force)
	return hand? put_in_l_hand(I, force) : put_in_r_hand(I, force)

/mob/living/put_in_inactive_hand(obj/item/I, force)
	return hand? put_in_r_hand(I, force) : put_in_l_hand(I, force)

/mob/living/get_held_item_of_index(index)
	switch(index)
		if(1)
			return l_hand
		if(2)
			return r_hand

/mob/living/get_number_of_hands()
	return 2

#warn impl

#warn has_hands var or something else?
/mob/living/put_in_l_hand(obj/item/I, force)

/mob/living/put_in_r_hand(obj/item/I, force)

/mob/living/put_in_hand(obj/item/I, index, force)
	switch(index)
		if(1)
			return put_in_l_hand(I, force)
		if(2)
			return put_in_r_hand(I, force)

/mob/living/_unequip_held(obj/item/I, update_icons)
	if(l_hand == I)
		l_hand = null
	else if(r_hand == I)
		r_hand = null
	if(update_icons)
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

/mob/living/_set_inv_slot(slot, obj/item/I, update_icons)
	switch(slot)
		if(SLOT_ID_BACK)
			back = I
			if(update_icons)
				update_inv_back()
		if(SLOT_ID_MASK)
			wear_mask = I
			if(update_icons)
				update_inv_wear_mask()
		else
			return ..()

/mob/living/_get_all_slots(include_restraints)
	. = ..()
	if(back)
		. += back
	if(wear_mask)
		. += wear_mask



#warn parse below



/mob/living/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/storage))
		var/obj/item/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, 1))
			newitem.forceMove(src.back)
			return 1

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if (S.can_be_inserted(newitem, 1))
			newitem.forceMove(S)
			return 1
	return 0


/mob/living/proc/update_held_icons()
	if(l_hand)
		l_hand.update_held_icon()
	if(r_hand)
		r_hand.update_held_icon()

/mob/living/u_equip(obj/W as obj)
	if (W == r_hand)
		r_hand = null
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand()
	else if (W == back)
		back = null
		update_inv_back()
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask()
	return

/mob/living/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand) return l_hand
		if(slot_r_hand) return r_hand
		if(SLOT_ID_BACK) return back
		if(SLOT_ID_MASK) return wear_mask
	return null

/mob/living/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

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

	if(istype(loc,/obj/mecha)) return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	return

/mob/living/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1
	return 0
