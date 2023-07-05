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
	PROTECTED_PROC(TRUE)
	. = INVENTORY_SLOT_DOES_NOT_EXIST
	CRASH("Attempting to set inv slot of [slot] to [I] went to base /mob. You probably had someone assigning to a nonexistant slot!")

/**
 * ""expensive"" proc that scans for the real slot of an item
 * usually used when safety checks detect something is amiss
 */
/mob/proc/_slot_by_item(obj/item/I)
	PROTECTED_PROC(TRUE)

/**
 * doubles as slot detection
 * returns -1 if no slot
 * YES, MAGIC VALUE BUT SOLE USER IS 20 LINES ABOVE, SUE ME.
 */
/mob/proc/_item_by_slot(slot)
	PROTECTED_PROC(TRUE)
	return INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_get_all_slots(include_restraints)
	PROTECTED_PROC(TRUE)
	return list()

/**
 * return all slot ids we implement
 */
/mob/proc/_get_inventory_slot_ids()
	PROTECTED_PROC(TRUE)
	return list()

/**
 * override this if you need to make a slot not semantically exist
 * useful for other species that don't have a slot so you don't have jumpsuit requirements apply
 */
/mob/proc/_semantic_slot_id_check(id)
	PROTECTED_PROC(TRUE)
	return TRUE

//* Optional Behaviors *//

/**
 * checks for slot conflict
 */
/mob/proc/inventory_slot_conflict_check(obj/item/I, slot)
	if(_item_by_slot(slot))
		return CAN_EQUIP_SLOT_CONFLICT_HARD
	switch(slot)
		if(SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR)
			if(I.slot_flags & SLOT_TWOEARS)
				if(_item_by_slot(SLOT_ID_LEFT_EAR) || _item_by_slot(SLOT_ID_RIGHT_EAR))
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
/mob/proc/inventory_slot_semantic_conflict(obj/item/I, datum/inventory_slot_meta/slot, mob/user)
	. = FALSE
	slot = resolve_inventory_slot_meta(slot)
	return slot._equip_check(I, src, user)

/**
 * checks if we are missing the bodypart for a slot
 * return FALSE if we are missing, or TRUE if we're not
 *
 * this proc should give the feedback of what's missing!
 */
/mob/proc/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, flags)
	return TRUE
