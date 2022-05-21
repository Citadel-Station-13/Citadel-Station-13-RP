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

/mob/proc/drop_item_to_ground

/mob/proc/transfer_item_to_loc

/mob/proc/temporarily_remove_from_inventory

/mob/proc/equip_to_slot_if_possible

/**
 * get all equipped items
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/get_equipped_items(include_inhands, include_restraints)

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
 * null if not in inventory. inhands don't count as inventory.
 */
/mob/proc/slot_by_item(obj/item/I)

/mob/proc/_equip_to_slot(obj/item/I, slot)

/mob/proc/_unequip(obj/item/I)

/mob/proc/_unequip_slot(slot)

/mob/proc/_slot_by_item(obj/item/I)

/mob/proc/_item_by_slot(slot)
	return
