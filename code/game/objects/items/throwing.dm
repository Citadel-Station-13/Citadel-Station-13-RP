/**
 * get what we actually throw, so we can throw holders/grabs
 */
/obj/item/proc/throw_resolve_actual()
	return src

/obj/item/overhand_throw_delay(mob/user)
	return w_class * OVERHAND_THROW_ITEM_DELAY

/**
 * return TRUE to not drop us and instead just throw whatever throw_resolve_actual hopefully returned
 */
/obj/item/proc/throw_resolve_override()
	return FALSE

/**
 * called at point of no return; lets us un-reference what we're having them throw if we need to.
 */
/obj/item/proc/throw_resolve_finalize()
	return
