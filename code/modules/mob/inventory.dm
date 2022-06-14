/mob
	var/obj/item/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(var/slot)
	var/obj/item/W = get_active_held_item()

	var/obj/item/E = item_by_slot(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

/* Inventory manipulation */

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
	if(src != M.get_active_held_item())
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
	possible += M.get_inactive_held_item()

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

