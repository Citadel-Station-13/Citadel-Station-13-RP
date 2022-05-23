/**
 * handles the insertion
 * item can be moved or not moved before calling
 *
 * slot must be a typepath
 *
 * @return true/false based on if it worked
 */
/mob/proc/handle_abstract_slot_insertion(obj/item/I, slot, force)
	if(!ispath(slot, /datum/inventory_slot_meta/abstract))
		slot = resolve_inventory_slot_meta(slot)?.type
		if(!ispath(slot, /datum/inventory_slot_meta/abstract))
			stack_trace("invalid slot: [slot]")
		else
			stack_trace("attempted usage of slot id in abstract insertion converted successfully")
	. = FALSE
	switch(slot)
		if(/datum/inventory_slot_meta/abstract/left_hand)
			return put_in_l_hand(I, force)
		if(/datum/inventory_slot_meta/abstract/right_hand)
			return put_in_r_hand(I, force)
		if(/datum/inventory_slot_meta/abstract/put_in_belt)

		if(/datum/inventory_slot_meta/abstract/put_in_backpack)

		if(/datum/inventory_slot_meta/abstract/put_in_hands)
			return put_in_hands(I, force = force)
		if(/datum/inventory_slot_meta/abstract/put_in_storage)

		if(/datum/inventory_slot_meta/abstract/attach_as_accessory)

		else
			CRASH("Invalid abstract slot [slot]")


#warn impl

/**
 * drops an item to ground
 */
/mob/proc/drop_item_to_ground(obj/item/I, force)
	return _unequip_item(I, force, drop_location())

/**
 * transfers an item somewhere
 */
/mob/proc/transfer_item_to_loc(obj/item/I, newloc, force)
	ASSERT(newloc)
	return _unequip_item(I, force, newloc)

/**
 * transfers an item into nullspace
 */
/mob/proc/transfer_item_to_nullspace(obj/item/I, force)
	return _unequip_item(I, force, null)

/**
 * removes an item from inventory. does NOT move it.
 * item MUST be qdel'd or moved after this if it returns TRUE!
 */
/mob/proc/temporarily_remove_from_inventory(obj/item/I, force)
	return _unequip_item(I, force, FALSE)

/**
 * handles internal logic of unequipping an item
 *
 * @params
 * - I - item
 * - force - ignore nodrop/other restrictions
 * - newloc - where to transfer to. null for nullspace, FALSE for don't transfer
 * - swapping - swapping clothes, don't drop pockets/whatnot
 * - silent - don't display warnings
 *
 * @return TRUE/FALSE for success
 */
/mob/proc/_unequip_item(obj/item/I, force, newloc, swapping, silent)
	PROTECTED_PROC(TRUE)
	if(!I)
		return TRUE
	if(!force && HAS_TRAIT(I, TRAIT_NODROP))
		return FALSE

	var/hand = get_held_index(I)
	if(hand)
		_unequip_held(I, TRUE)
	else
		_unequip_slot(I.current_equipped_slot, TRUE)
		I.unequipped(src, I.current_equipped_slot)

	. = TRUE

	if(I)
		if(client)
			client.screen -= I
		if(!(I.flags & DROPDEL))
			if(newloc == null)
				I.moveToNullspace()
			else if(newloc != FALSE)
				I.forceMove(newloc)
		I.dropped(src)

/**
 * equips an item to a slot if possible
 *
 * @params
 * - I - item
 * - slot - the slot
 * - silent - don't show this mob warnings when failing
 * - update_icons - redraw slot icons?
 * - ignore_fluff - ignore silly roleplay fluff like not being able to reach/self equip delays
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_if_possible(obj/item/I, slot, silent, update_icons, ignore_fluff)


/mob/proc/equip_to_slot_or_del(obj/item/I, slot, silent, update_icons, ignore_fluff)
	. = equip_to_slot_if_possible(I, slot, silent, update_icons, ignore_fluff)
	if(!.)
		qdel(I)

#warn impl
/mob/proc/_equip_item(obj/item/I, slot, silent, update_icons, ignore_fluff)
	#warn this handles stuff like calling equipped/unequipped on slot swaps, etc

/**
 * get all equipped items
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/get_equipped_items(include_inhands, include_restraints)
	return get_held_items() + _get_all_slots(include_restraints)

/**
 * wipe our inventory
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/delete_inventory(include_inhands = TRUE, include_restraints = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		qdel(I)

/**
 * drops everything in our inventory
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 * force - ignore nodrop and all that
 */
/mob/proc/drop_inventory(include_inhands = TRUE, include_restraints = TRUE, force = TRUE)


/**
 * gets the item in a slot
 * null if not in inventory. inhands don't count as inventory here, use held item procs.
 */
/mob/proc/item_by_slot(slot)
	return _item_by_slot(slot)	// why the needless indirection? so people don't override this for slots!

/**
 * returns if we have something equipped - the slot if it is, null if not
 *
 * SLOT_ID_HANDS if in hands
 */
/mob/proc/is_in_inventory(obj/item/I)
	return (I.loc == src) && I.current_equipped_slot
	// we use entirely cached vars for speed.
	// if this returns bad data well fuck you, don't break equipped()/unequipped().

/**
 * get slot of item if it's equipped.
 * null if not in inventory. SLOT_HANDS if held.
 */
/mob/proc/slot_by_item(obj/item/I)
	return is_in_inventory(I)		// short circuited to that too
									// if equipped/unequipped didn't set current_equipped_slot well jokes on you lmfao

/**
 * THESE PROCS MUST BE OVERRIDDEN FOR NEW SLOTS ON MOBS
 * yes, i managed to shove all behaviors that needed overriding into 5 procs
 * not including _unequip_held since hands should be generic anyways
 * you're
 * welcome.
 *
 * These are UNSAFE PROCS.
 */

#warn impl these

/mob/proc/_equip_slot(obj/item/I, slot, update_icons)

/mob/proc/_unequip_slot(slot, update_icons)

/mob/proc/_unequip_held(obj/item/I, update_icons)

/**
 * ""expensive"" proc that scans for the real slot of an item
 * usually used when safety checks detect something is amiss
 */
/mob/proc/_slot_by_item(obj/item/I)

/mob/proc/_item_by_slot(slot)
	return

/mob/proc/_get_all_slots(include_restraints)
	return list()
