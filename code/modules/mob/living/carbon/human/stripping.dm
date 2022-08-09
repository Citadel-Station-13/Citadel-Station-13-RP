/mob/living/carbon/human/proc/handle_strip_from_held(index, mob/living/user)
	if(!handle_strip_prechecks(user))
		return

	// todo: multihand support
	if((index < 1) || (index > 2))
		return

	var/obj/item/I = get_held_item_of_index(index)
	var/obj/item/held = user.get_active_held_item()
	if(!I && !held)
		return

	if(!handle_strip_generic(I, user, index))
		return

	if(I)
		if(drop_item_to_ground(I, user = user))
			add_attack_logs(user, src, "Removed [I] from hand index [index]")
		else
			add_attack_logs(user, src, "Failed to remove [I] from hand index [index]")
	else
		if(put_in_hand(held, index))
			add_attack_logs(user, src, "Put [held] in hand index [index]")
		else
			add_attack_logs(user, src, "Failed to put [held] in hand index [index]")

/mob/living/carbon/human/proc/handle_strip_from_slot(slot, mob/living/user)
	if(!handle_strip_prechecks(user))
		return

	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
	if(!slot_meta)
		return

	var/obj/item/I = item_by_slot(slot)
	var/obj/item/held = user.get_active_held_item()
	if(!I && !held)
		return

	if(!handle_strip_generic(I, user, slot))
		return

	if(I)
		if(drop_item_to_ground(I, user = user))
			add_attack_logs(user, src, "Removed [I] from slot [slot]")
		else
			add_attack_logs(user, src, "Failed to remove [I] from slot [slot]")
	else
		if(equip_to_slot_if_possible(held, slot))
			add_attack_logs(user, src, "Put [held] in slot [slot]")
		else
			add_attack_logs(user, src, "Failed to put [held] in slot [slot]")

/mob/living/carbon/human/proc/handle_strip_prechecks(mob/user)
	if(user.incapacitated() || !user.Adjacent(src))
		user << browse(null, "window=mob[name]")
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/handle_strip_generic(obj/item/I, mob/living/user, slot_id_or_index)
	var/obj/item/held = user.get_active_held_item()
	var/stripping = !!I
	if(!stripping && !user.can_unequip(held))
		return FALSE

	if(stripping)
		visible_message(
			SPAN_DANGER("[user] is trying to remove [src]'s [I.name]!"),	// I.name to force non-auto-parsed behavior
			SPAN_DANGER("[user] is trying to remove your [I.name]!")		// ditto
		)
	else
		switch(slot_id_or_index)
			if(SLOT_ID_MASK)
				visible_message(SPAN_DANGER("[user] is trying to put \a [held] in [src]'s mouth!"))
			else
				visible_message(SPAN_DANGER("[user] is trying to put \a [held] on [src]!"))

	if(!do_after(user, HUMAN_STRIP_DELAY, src))
		return FALSE

	if(!stripping && !user.is_holding(held))
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/handle_strip_misc(action, mob/living/user)
	switch(action)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("pockets")
			visible_message("<span class='danger'>\The [user] is trying to empty \the [src]'s pockets!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				empty_pockets(user)
			return
		if("splints")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s splints!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				remove_splints(user)
			return
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				toggle_sensors(user)
			return
		if("internals")
			visible_message("<span class='danger'>\The [usr] is trying to set \the [src]'s internals!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY,src))
				toggle_internals(user)
			return
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !LAZYLEN(suit.accessories))
				return
			var/obj/item/clothing/accessory/A = suit.accessories[1]
			if(!istype(A))
				return
			visible_message("<span class='danger'>\The [usr] is trying to remove \the [src]'s [A.name]!</span>")

			if(!do_after(user,HUMAN_STRIP_DELAY,src))
				return

			if(!A || suit.loc != src || !(A in suit.accessories))
				return

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message("<span class='danger'>\The [user] tears off \the [A] from [src]'s [suit.name]!</span>")
			add_attack_logs(user,src,"Stripped [A.name] off [suit.name]")
			A.on_removed(user)
			suit.accessories -= A
			update_inv_w_uniform()
			return

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, "<span class='warning'>\The [src] has nothing in their pockets.</span>")
		return
	if(r_store)
		drop_item_to_ground(r_store)
	if(l_store)
		drop_item_to_ground(l_store)
	visible_message("<span class='danger'>\The [user] empties \the [src]'s pockets!</span>")

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, "<span class='warning'>\The [src] is not wearing a suit with sensors.</span>")
		return
	if (suit.has_sensor >= 2)
		to_chat(user, "<span class='warning'>\The [src]'s suit sensor controls are locked.</span>")
		return
	add_attack_logs(user,src,"Adjusted suit sensor level")
	suit.set_sensors(user)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, "<span class='warning'>You cannot remove the splints - [src]'s [suit] is supporting some of the breaks.</span>")
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/obj/item/organ/external/o in organs)
			if (o && o.splinted)
				var/obj/item/S = o.splinted
				if(istype(S) && S.loc == o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
					S.add_fingerprint(user)
					if(o.remove_splint())
						user.put_in_active_hand(S)
						removed_splint = 1
		if(removed_splint)
			visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has no splints to remove.</span>")

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Check for airtight mask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/tank))
			internal = back
		else if(istype(s_store, /obj/item/tank))
			internal = s_store
		else if(istype(belt, /obj/item/tank))
			internal = belt

	if(internal)
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
	else
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")

#warn put in inventory, slot enumeration, etc
/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated()  || !user.Adjacent(src))
		return

	var/obj/item/clothing/under/suit = null
	if (istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	for(var/entry in species.hud.gear)
		var/list/slot_ref = species.hud.gear[entry]
		if((slot_ref["slot"] in list(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET)))
			continue
		var/obj/item/thing_in_slot = item_by_slot(slot_ref["slot"])
		dat += "<BR><B>[slot_ref["name"]]:</b> <a href='?src=\ref[src];strip_slot=[slot_ref["slot"]]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"

	dat += "<BR><HR>"

	if(has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref[src];strip_held=[1]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref[src];strip_held=[2]'>[istype(r_hand) ? r_hand : "nothing"]</A>"

	// Do they get an option to set internals?
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
			dat += "<BR><A href='?src=\ref[src];strip_misc=internals'>Toggle internals.</A>"

	// Other incidentals.
	if(istype(suit) && suit.has_sensor == 1)
		dat += "<BR><A href='?src=\ref[src];strip_misc=sensors'>Set sensors</A>"
	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];strip_slot=[SLOT_ID_HANDCUFFED]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref[src];strip_slot=[SLOT_ID_LEGCUFFED]'>Legcuffed</A>"

	if(suit && LAZYLEN(suit.accessories))
		dat += "<BR><A href='?src=\ref[src];strip_misc=tie'>Remove accessory</A>"
	dat += "<BR><A href='?src=\ref[src];strip_misc=splints'>Remove splints</A>"
	dat += "<BR><A href='?src=\ref[src];strip_misc=pockets'>Empty pockets</A>"
	dat += "<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>"

	user << browse(dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

/mob/living/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];strip_slot=[SLOT_ID_MASK]'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];strip_hand=[1]'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];strip_hand=[2]'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];strip_misc=[SLOT_ID_BACK]'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];strip_misc=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];strip_misc=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return
