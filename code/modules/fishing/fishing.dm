/**
 * checks if we're a fishing spot
 *
 * @return fishing spot component, if found
 */
/atom/proc/is_fishing_spot()
	return GetComponent(/datum/component/fishing_spot)


/**
 * called just as we're about to start fishing
 * use this to generate a fishing spot if needed.
 */
/atom/proc/pre_fishing_query(obj/item/fishing_rod/rod, mob/user)
	SEND_SIGNAL(src, COMSIG_PRE_FISHING_QUERY, rod, user)
