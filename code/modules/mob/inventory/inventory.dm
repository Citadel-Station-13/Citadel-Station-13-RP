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
		if(!ispath(slot, /datum/inventory_slot_meta_abstract))
			stack_trace("invalid slot: [slot]")
		else
			stack_trace("attempted usage of slot id in abstract insertion converted successfully")
	. = FALSE
	switch(slot)
		if(/datum/inventory_slot_meta/abstract/left_hand)

		if(/datum/inventory_slot_meta/abstract/right_hand)

		if(/datum/inventory_slot_meta/abstract/put_in_belt)

		if(/datum/inventory_slot_meta/abstract/put_in_backpack)

		if(/datum/inventory_slot_meta/abstract/put_in_hands)

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
 * gets the item in a slot
 * null if not in inventory. inhands don't count as inventory.
 */
/mob/proc/item_by_slot(slot)

/**
 * returns if we have something equipped
 * inhands don't count
 */
/mob/proc/is_in_inventory(obj/item/i)

/**
 * get slot of item if it's equipped.
 * null if not in inventory. inhands don't count as inventory.
 */
/mob/proc/slot_by_item(obj/item/I)

/mob/proc/_equip_to_slot(obj/item/I, slot)

/mob/proc/_unequip(obj/item/I)

/mob/proc/_unequip_slot(slot)

/mob/proc/_item_in_slot(slot)
