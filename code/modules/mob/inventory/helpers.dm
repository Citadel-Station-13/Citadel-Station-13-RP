/**
 * dels something or says "x is stuck to your hand"
 *
 * WARNING: DELS THINGS AFTER CURRENT PROC. DO NOT USE IF YOU NEED IMMEDIATE QDEL!
 * This is so procs can still access data.
 */
/mob/proc/attempt_consume_item_for_construction(obj/item/I, flags)
	. = temporarily_remove_from_inventory(I, flags)
	if(!.)
		return FALSE
	. = TRUE
	QDEL_IN(I, 0)

/**
 * standard helper for put something into something else
 */
/mob/proc/attempt_insert_item_for_installation(obj/item/I, atom/newloc, flags)
	. = transfer_item_to_loc(I, newloc, flags)
	if(!.)
		return FALSE
	return TRUE

/**
 * standard helper for put something into something else but it actually nullspaces lmao
 */
/mob/proc/attempt_void_item_for_installation(obj/item/I, flags)
	. = transfer_item_to_nullspace(I, flags)
	if(!.)
		return FALSE
	return TRUE

/**
 * puts item in hand or drops, unless we are using MUTATION_TELEKINESIS, in which case just drops at interacted loc
 * this doesn't actually check if I is in interacted
 * this is intentional.
 */
/mob/proc/grab_item_from_interacted_with(obj/item/I, atom/interacted)
	// TODO: proper MUTATION_TELEKINESIS checks
	if(!Adjacent(interacted))
		I.forceMove(interacted.drop_location())
		return
	put_in_hands_or_drop(I)

/mob/proc/drop_slots_to_ground(list/slots, flags, datum/callback/cb)
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot(slot)
			. = drop_item_to_ground(I, flags)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot(slots)
		. = drop_item_to_ground(I, flags)
		cb?.Invoke(I, .)

/mob/proc/transfer_slots_to_loc(list/slots, atom/A, flags, datum/callback/cb)
	// todo: handle what happens if dropping something requires a logic thing
	// e.g. dropping jumpsuit makes it impossible to transfer a belt since it
	// de-equipped from the jumpsuit
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot(slot)
			. = transfer_item_to_loc(I, A, flags)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot(slots)
		. = transfer_item_to_loc(I, A, flags)
		cb?.Invoke(I, .)

/mob/proc/get_equipped_items_in_slots(list/slots)
	. = list()
	var/obj/item/I
	if(islist(slots))
		for(var/slot in slots)
			I = item_by_slot(slot)
			if(I)
				. += I
	else
		I = item_by_slot(slots)
		if(I)
			. += I

/**
 * equip to slots if possible, in order
 * silent defaults to TRUE, to avoid spam
 *
 * return slot equipped to if success, otherwise null
 */
/mob/proc/equip_to_slots_if_possible(obj/item/I, list/slots, mob/user, flags)
	if(!islist(slots))
		return equip_to_slot_if_possible(I, slots, user, flags)? slots : null
	for(var/slot in slots)
		if(equip_to_slot_if_possible(I, slot, user, flags))
			return slot
