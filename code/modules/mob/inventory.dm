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
			#warn nuke this from orbit this ENTIRE FUCKNIG PROC from orbit
			S.handle_item_insertion(src, M)
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
	#warn MAKE SURE THIS, AND ALL PUT IN HAND PROCS FORCEMOVE STUFF.
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
	I.hud_unlayerise()
	I.dropped(src)
	return FALSE

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return 1
	var/slot = get_inventory_slot(I)
	return slot && I.mob_can_unequip(src, slot)

//Attemps to remove an object on a mob.
/mob/proc/______remove_from_mob(var/obj/O, var/atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.hud_unlayerise()
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
			#warn dropped check for qdeleted
			I.dropped(src)
	return 1

