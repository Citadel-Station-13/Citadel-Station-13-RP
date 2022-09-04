/**
 * get what we actually throw, so we can throw holders/grabs
 */
/obj/item/proc/throw_resolve_actual()
	return src

/obj/item/overhand_throw_delay(mob/user)
	return w_class * OVERHAND_THROW_ITEM_DELAY
