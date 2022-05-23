/**
 * dels something or says "x is stuck to your hand"
 */
/mob/proc/attempt_consume_item_for_construction(obj/item/I)
	. = temporarily_remove_from_inventory(I)
	if(!.)
		to_chat(src, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE
	. = TRUE
	qdel(I)
