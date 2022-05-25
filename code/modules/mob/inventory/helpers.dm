/**
 * dels something or says "x is stuck to your hand"
 *
 * WARNING: DELETES THINGS IMMEDIATELY. Don't use if you need to access data.
 */
/mob/proc/attempt_consume_item_for_construction(obj/item/I)
	. = temporarily_remove_from_inventory(I)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	. = TRUE
	qdel(I)

/**
 * standard helper for put something into something else
 */
/mob/proc/attempt_insert_item_for_installation(obj/item/I, atom/newloc)
	. = transfer_item_to_loc(I newloc)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	return TRUE
