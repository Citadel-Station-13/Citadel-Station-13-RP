//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Abstraction procs
 *
 * With these, you can implement different inventory handling per mob
 * These should usually not be called by non-mobs / items / etc.
 *
 * Core abstraction should never be called from outside
 * Optional abstraction can be called with the caveat that you should be very careful in doing so.
 */

//* Core Abstraction *//

/**
 * THESE PROCS MUST BE OVERRIDDEN FOR NEW SLOTS ON MOBS
 * yes, i managed to shove all basic behaviors that needed overriding into 5-6 procs
 * you're
 * welcome.
 *
 * These are UNSAFE PROCS.
 *
 * oh and can_equip_x* might need overriding for complex mobs like humans but frankly
 * sue me, there's no better way right now.
 */

/**
 * sets a slot to icon or null
 *
 * some behaviors may be included other than update icons
 * even update icons is unpreferred but we're stuck with this for now.
 *
 * todo: logic should be moved out of the proc, but where?
 *
 * @params
 * slot - slot to set
 * I - item or null
 * update_icons - update icons immediately?
 * logic - apply logic like dropping stuff from pockets when unequippiing a jumpsuit imemdiately?
 */
/mob/proc/_set_inv_slot(slot, obj/item/I, flags)
	. = INVENTORY_SLOT_DOES_NOT_EXIST
	CRASH("Attempting to set inv slot of [slot] to [I] went to base /mob. You probably had someone assigning to a nonexistant slot!")

/**
 * ""expensive"" proc that scans for the real slot of an item
 * usually used when safety checks detect something is amiss
 */
/mob/proc/_slot_by_item(obj/item/I)

/**
 * doubles as slot detection
 * returns -1 if no slot
 * YES, MAGIC VALUE BUT SOLE USER IS 20 LINES ABOVE, SUE ME.
 */
/mob/proc/_item_by_slot(slot) as /obj/item
	return INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_get_all_slots(include_restraints)
	return list()

/**
 * return all slot ids we implement
 */
/mob/proc/_get_inventory_slot_ids()
	return list()

/**
 * override this if you need to make a slot not semantically exist
 * useful for other species that don't have a slot so you don't have jumpsuit requirements apply
 */
/mob/proc/_semantic_slot_id_check(id)
	return TRUE

//* Optional Behaviors *//

/**
 * checks for slot conflict
 */
/mob/proc/inventory_slot_conflict_check(obj/item/I, slot, flags)
	var/obj/item/conflicting = _item_by_slot(slot)
	if(conflicting)
		if((flags & (INV_OP_CAN_DISPLACE | INV_OP_IS_FINAL_CHECK)) == (INV_OP_CAN_DISPLACE | INV_OP_IS_FINAL_CHECK))
			drop_item_to_ground(conflicting, INV_OP_FORCE)
			if(_item_by_slot(slot))
				return CAN_EQUIP_SLOT_CONFLICT_HARD
		else
			return CAN_EQUIP_SLOT_CONFLICT_HARD
	switch(slot)
		if(SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR)
			if(I.slot_flags & SLOT_TWOEARS)
				if(_item_by_slot(SLOT_ID_LEFT_EAR) || _item_by_slot(SLOT_ID_RIGHT_EAR))
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
			else
				var/obj/item/left_ear = _item_by_slot(SLOT_ID_LEFT_EAR)
				var/obj/item/right_ear = _item_by_slot(SLOT_ID_RIGHT_EAR)
				if(left_ear && left_ear != INVENTORY_SLOT_DOES_NOT_EXIST && left_ear != I && left_ear.slot_flags & SLOT_TWOEARS)
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
				else if(right_ear && right_ear != INVENTORY_SLOT_DOES_NOT_EXIST && right_ear != I && right_ear.slot_flags & SLOT_TWOEARS)
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
	return CAN_EQUIP_SLOT_CONFLICT_NONE

/**
 * checks if you can reach a slot
 * return null or the first item blocking
 */
/mob/proc/inventory_slot_reachability_conflict(obj/item/I, slot, mob/user)
	return null

/**
 * semantic check - should this item fit here? slot flag checks/etc should go in here.
 *
 * return TRUE if conflicting, otherwise FALSE
 */
/mob/proc/inventory_slot_semantic_conflict(obj/item/I, datum/inventory_slot/slot, mob/user)
	. = FALSE
	slot = resolve_inventory_slot(slot)
	return slot._equip_check(I, src, user)

/**
 * checks if we are missing the bodypart for a slot
 * return FALSE if we are missing, or TRUE if we're not
 *
 * this proc should give the feedback of what's missing!
 */
/mob/proc/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, flags)
	return TRUE

//* Hands *//

/**
 * Hands are a bit of a special case
 *
 * They don't use inventory slots like the inventory system does,
 * But still exists in the inventory module because they do a number of things,
 * like count as equipped under [SLOT_ID_HANDS].
 *
 * This semi-integration lets us do a few cool things like not needing separate hooks
 * for when someone has something in hand, but not in inventory, transitioning
 * to them having it in inventory, but not in hands.
 */

/**
 * the big, bad proc ultimately in charge of putting something into someone's hand
 * whether it's from the ground, from a slot, or from another hand.
 */
/mob/proc/equip_hand_impl(obj/item/I, index, flags)
	if(!I)
		return TRUE
	// let's not do that if it's deleted!
	if(QDELETED(I))
		to_chat(src, SPAN_DANGER("A deleted item [I] ([REF(I)]) was sent into inventory hand procs with flags [flags]. Report this line to coders immediately."))
		to_chat(src, SPAN_DANGER("The inventory system will attempt to reject the bad equip. Glitches may occur."))
		return FALSE

	if(length(inventory?.held_items) < index)
		return FALSE

	var/obj/item/existing = inventory?.held_items[index]
	if(!isnull(existing))
		if(flags & INV_OP_FORCE)
			drop_held_index(index, flags | INV_OP_NO_UPDATE_ICONS)
			if(!isnull(inventory?.held_items[index]))
				// failed to drop
				return FALSE
		else
			return FALSE

	var/existing_slot = is_in_inventory(I)
	if(existing_slot == SLOT_ID_HANDS)
		handle_item_handswap(I, index, get_held_index(I), flags)
	else
		if(existing_slot)
			// already in inv
			if(!_handle_item_reequip(I, SLOT_ID_HANDS, existing_slot, flags, src, index))
				return FALSE
			log_inventory("equip-to-hand: keyname [key_name(src)] index [index] item [I]([ref(I)]) from slot [existing_slot]")
		else
			// newly eqiupped
			var/atom/old_loc = I.loc
			if(I.loc != src)
				I.forceMove(src)
			if(I.loc != src)
				return FALSE
			log_inventory("pickup-to-hand: keyname [key_name(src)] index [index] item [I]([ref(I)])")
			I.held_index = index
			I.pickup(src, flags, old_loc)
			I.equipped(src, SLOT_ID_HANDS, flags)

		inventory.held_items[index] = I
		inventory.on_item_entered(I, index)

	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hand(index)

	if(!(I.interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH))
		I.add_fingerprint(src)
	else
		I.add_hiddenprint(src)

	return TRUE

/**
 * get something out of our hand
 *
 * @return unequipped item
 */
/mob/proc/unequip_hand_impl(obj/item/I, index, flags)
	ASSERT(inventory?.held_items[index] == I)

	inventory.held_items[index] = null
	inventory.on_item_exited(I, index)

	I.held_index = null
	I.unequipped(src, SLOT_ID_HANDS, flags)
	I.on_inv_unequipped(src, inventory, index, flags)

	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hand(index)

	return TRUE

/**
 * handle swapping item from one hand index to another
 */
/mob/proc/handle_item_handswap(obj/item/I, index, old_index, flags, mob/user = src)
	ASSERT(inventory?.held_items[old_index] == I)
	ASSERT(isnull(inventory?.held_items[index]))

	inventory.held_items[old_index] = null
	inventory.held_items[index] = I
	I.held_index = index
	inventory.on_item_swapped(I, old_index, index)


	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hand(old_index)
		update_inv_hand(index)
