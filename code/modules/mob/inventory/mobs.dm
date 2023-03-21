//? init

/mob/proc/init_inventory()
	return

//? equip

/**
 * equips an item to a slot if possible
 *
 * @params
 * - I - item
 * - slot - the slot
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_if_possible(obj/item/I, slot, flags, mob/user)
	return _equip_item(I, flags, slot, user)

/**
 * equips an item to a slot if possible
 * item is deleted on failure
 *
 * @params
 * - I - item
 * - slot - the slot
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_or_del(obj/item/I, slot, flags, mob/user)
	. = equip_to_slot_if_possible(I, slot, flags, user)
	if(!.)
		qdel(I)
/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 * this proc is silent for the sub-calls by default to prevent spam.
 *
 * @params
 * - I - item
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_appropriate_slot(obj/item/I, flags, mob/user)
	for(var/slot in GLOB.slot_equipment_priority)
		if(equip_to_slot_if_possible(I, slot, flags | INV_OP_SUPPRESS_WARNING, user))
			return TRUE
	if(!(flags & INV_OP_SUPPRESS_WARNING))
		to_chat(user, user == src? SPAN_WARNING("You can't find somewhere to equip [I] to!") : SPAN_WARNING("[src] has nowhere to equip [I] to!"))
	return FALSE

/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 *
 * item is deleted on failure.
 *
 * @params
 * - I - item
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */

/mob/proc/equip_to_appropriate_slot_or_del(obj/item/I, flags, mob/user)
	if(!equip_to_appropriate_slot(I, flags, user))
		qdel(I)

/**
 * forcefully equips an item to a slot
 * kicks out conflicting items if possible
 *
 * This CAN fail, so listen to return value
 * Why? YOU MIGHT EQUIP TO A MOB WITHOUT A CERTAIN SLOT!
 *
 * @params
 * - I - item
 * - slot - slot to equip to
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/force_equip_to_slot(obj/item/I, slot, flags, mob/user)
	return _equip_item(I, flags | INV_OP_FATAL, slot, user)

/**
 * forcefully equips an item to a slot
 * kicks out conflicting items if possible
 * if still failing, item is deleted
 *
 * this can fail, so listen to return values.
 * @params
 * - I - item
 * - slot - slot to equip to
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/force_equip_to_slot_or_del(obj/item/I, slot, flags, mob/user)
	if(!force_equip_to_slot(I, slot, flags, user))
		qdel(I)
		return FALSE
	return TRUE

//? drop

// So why do all of these return true if the item is null?
// Semantically, transferring/dropping nothing always works
// This lets us tidy up other pieces of code by not having to typecheck everything.
// However, if you do pass in an invalid object instead of null, the procs will fail or pass
// depending on needed behavior.
// Use the helpers when you can, it's easier for everyone and makes replacing behaviors later easier.

// This logic is actually **stricter** than the previous logic, which was "if item doesn't exist, it always works"

/**
 * drops an item to ground
 *
 * semantically returns true if the thing is no longer in our inventory after our call, whether or not we dropped it
 * if you require better checks, check if something is in inventory first.
 *
 * if the item is null, this returns true
 * if an item is not in us, this returns true
 */
/mob/proc/drop_item_to_ground(obj/item/I, flags, mob/user = src)
	// destroyed IS allowed to call these procs
	if(I && QDELETED(I) && !QDESTROYING(I))
		to_chat(user, SPAN_DANGER("A deleted item [I] was used in drop_item_to_ground(). Report the entire line to coders. Debugging information: [I] ([REF(I)]) flags [flags] user [user]"))
		to_chat(user, SPAN_DANGER("Drop item to ground will now proceed, ignoring the bugged state. Errors may ensue."))
	else if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, drop_location(), user)

/**
 * transfers an item somewhere
 * newloc MUST EXIST, use transfer_item_to_nullspace otherwise
 *
 * semantically returns true if we transferred something from our inventory to newloc in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_loc(obj/item/I, newloc, flags, mob/user)
	if(!I)
		return TRUE
	ASSERT(newloc)
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, newloc, user)

/**
 * transfers an item into nullspace
 *
 * semantically returns true if we transferred something from our inventory to null in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_nullspace(obj/item/I, flags, mob/user)
	if(!I)
		return TRUE
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, null, user)

/**
 * removes an item from inventory. does NOT move it.
 * item MUST be qdel'd or moved after this if it returns TRUE!
 *
 * semantically returns true if the passed item is no longer in our inventory after the call
 *
 * if the item is null, ths returns true
 * if an item is not in us, this returns true
 */
/mob/proc/temporarily_remove_from_inventory(obj/item/I, flags, mob/user)
	if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, FALSE, user)
