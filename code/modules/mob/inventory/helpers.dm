/**
 * dels something or says "x is stuck to your hand"
 *
 * WARNING: DELS THINGS AFTER CURRENT PROC. DO NOT USE IF YOU NEED IMMEDIATE QDEL!
 * This is so procs can still access data.
 */
/mob/proc/attempt_consume_item_for_construction(obj/item/I)
	. = temporarily_remove_from_inventory(I)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	. = TRUE
	QDEL_IN(I, 0)

/**
 * standard helper for put something into something else
 */
/mob/proc/attempt_insert_item_for_installation(obj/item/I, atom/newloc)
	. = transfer_item_to_loc(I, newloc)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	return TRUE

/**
 * standard helper for put something into something else but it actually nullspaces lmao
 */
/mob/proc/attempt_void_item_for_installation(obj/item/I)
	. = transfer_item_to_nullspace(I)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	return TRUE

/mob/proc/drop_slots_to_ground(list/slots, force, datum/callback/cb)
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot(slot)
			. = drop_item_to_ground(I, force)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot(slot)
		. = drop_item_to_ground(I, force)
		cb?.Invoke(I, .)

/mob/proc/transfer_slots_to_loc(list/slots, atom/A, force, datum/callback/cb)
	if(islist(slots))
		for(var/slot in slots)
			var/obj/item/I = item_by_slot(slot)
			. = transfer_item_to_loc(I, A, force)
			cb?.Invoke(I, .)
	else
		var/obj/item/I = item_by_slot(slot)
		. = transfer_item_to_loc(I, A, force)
		cb?.Invoke(I, .)
