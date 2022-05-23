/mob
	var/obj/item/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(var/slot)
	var/obj/item/W = get_active_hand()

	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

/* Inventory manipulation */

/mob/proc/put_in_hands(obj/item/W as obj, del_on_fail = 0, disable_warning = 1, redraw_mob = 1)
	if(equip_to_slot_if_possible(W, slot_l_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	else if(equip_to_slot_if_possible(W, slot_r_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	return 0

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W as obj, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1)
	if(!W)
		return 0
	if(!W.mob_can_equip(src, slot, disable_warning)) //Previously did not propagate disable_warning. I can't imagine why not.
		if(del_on_fail)
			qdel(W)

		else
			if(!disable_warning)
				to_chat(src, "<font color='red'>You are unable to equip that.</font>") //Only print if del_on_fail is false
		return 0

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	return 1

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W as obj, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return 1

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return 1

	return 0

/obj/item/proc/equip_to_best_slot(mob/M)
	if(src != M.get_active_hand())
		to_chat(M, "<span class='warning'>You are not holding anything to equip!</span>")
		return FALSE

	if(M.equip_to_appropriate_slot(src))
		M.update_inv_l_hand()
		M.update_inv_r_hand()
		return TRUE
	//else
		//if(equip_delay_self)
		//	return

	//I can't believe I'm using colon operators but this is needed until component storage is done or atleast the slot refactor..
	var/list/obj/item/possible = list(M.s_active)
	if(M.vars.Find("belt"))
		possible += M:belt
	if(M.vars.Find("back"))
		possible += M:back
	possible += M.get_inactive_hand()

	for(var/i in possible)
		if(!i)
			continue
		var/obj/item/storage/S = i
		if(!istype(S))
			continue
		if(S.can_be_inserted(src, TRUE))
			S.handle_item_insertion(src)
			return TRUE

	to_chat(M, "<span class='warning'>You are unable to equip that!</span>")
	return FALSE

/mob/proc/equip_to_storage(obj/item/newitem)
	return 0

/* Hands */

//Puts the item our active hand if possible. Failing that it tries other hands. Returns TRUE on success.
//If both fail it drops it on the floor and returns FALSE.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE, forced = FALSE)
	if(!I)
		return FALSE

	// If the item is a stack and we're already holding a stack then merge
	if (istype(I, /obj/item/stack))
		var/obj/item/stack/I_stack = I
		var/obj/item/stack/active_stack = get_active_hand()

		if (I_stack.zero_amount())
			return FALSE

		if (merge_stacks)
			if (istype(active_stack) && istype(I_stack, active_stack.stacktype))
				if (I_stack.merge(active_stack))
					to_chat(usr, "<span class='notice'>Your [active_stack.name] stack now contains [active_stack.get_amount()] [active_stack.singular_name]\s.</span>")
					return TRUE
			else
				var/obj/item/stack/inactive_stack = get_inactive_hand()
				if (istype(inactive_stack) && istype(I_stack, inactive_stack.stacktype))
					if (I_stack.merge(inactive_stack))
						to_chat(usr, "<span class='notice'>Your [inactive_stack.name] stack now contains [inactive_stack.get_amount()] [inactive_stack.singular_name]\s.</span>")
						return TRUE

/*
	if(put_in_active_hand(I, forced))
		return TRUE
*/

	if(put_in_active_hand(I))
		update_inv_l_hand()
		update_inv_r_hand()
		return TRUE
	else if(put_in_inactive_hand(I))
		update_inv_l_hand()
		update_inv_r_hand()
		return TRUE

/*
	var/hand = get_empty_held_index_for_side("l")
	if(!hand)
		hand =  get_empty_held_index_for_side("r")
	if(hand)
		if(put_in_hand(I, hand, forced))
			return TRUE
*/

	if(del_on_fail)
		qdel(I)
		return FALSE
	I.forceMove(drop_location())
	I.reset_plane_and_layer()
	I.dropped(src)
	return FALSE

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.

/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W)
		remove_from_mob(W, target)
		if(!(W && W.loc))
			return 1 // self destroying objects (tk, grabs)
		return 1
	return 0

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return 0
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return 1
	var/slot = get_inventory_slot(I)
	return slot && I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = 0
	for(var/s in 1 to SLOT_TOTAL)
		if(get_equipped_item(s) == I)
			slot = s
			break
	return slot


//This differs from remove_from_mob() in that it checks if the item can be unequipped first.
/mob/proc/unEquip(obj/item/I, force = 0, target) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!(force || canUnEquip(I)))
		return FALSE
	drop_from_inventory(I, target)
	return TRUE


//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(var/obj/O, var/atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(target)
			I.forceMove(target)
		else
			I.dropInto(drop_location())
		if(I.current_equipped_slot)
			I.unequipped(src, I.current_equipped_slot)
		if(target != src)
			I.dropped(src)
	return 1

