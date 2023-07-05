// todo: we need a set of 'core' procs subtypes need to override, and the rest are composites of those procs.

/mob/proc/put_in_right_hand(obj/item/I, flags)
	return FALSE

/mob/proc/put_in_left_hand(obj/item/I, flags)
	return FALSE

/mob/proc/put_in_active_hand(obj/item/I, flags)
	return FALSE

/mob/proc/put_in_inactive_hand(obj/item/I, flags)
	return FALSE

/mob/proc/put_in_hand(obj/item/I, index, flags)
	return index == 1? put_in_left_hand(I, flags) : put_in_right_hand(I, flags)

/mob/proc/put_in_hand_or_del(obj/item/I, index, flags)
	. = index == 1? put_in_left_hand(I, flags) : put_in_right_hand(I, flags)
	if(!.)
		qdel(I)

/mob/proc/put_in_hand_or_drop(obj/item/I, index, flags, atom/drop_loc = drop_location())
	. = index == 1? put_in_left_hand(I, flags) : put_in_right_hand(I, flags)
	if(!.)
		I.forceMove(drop_loc)

/**
 * return index of item, or null if not found
 */
/mob/proc/get_held_index(obj/item/I)
	return

/**
 * returns held item in active hand
 */
/mob/proc/get_active_held_item()
	RETURN_TYPE(/obj/item)
	return

/**
 * returns held item in inactive hand (or any inactive hand if more than 1)
 */
/mob/proc/get_inactive_held_item()
	RETURN_TYPE(/obj/item)
	return

/**
 * returns all items held in non active hands
 */
/mob/proc/get_inactive_held_items()
	var/obj/item/I = get_inactive_held_item()
	if(I)
		return list(I)
	return list()
	// TODO: actual multihanding support, for now this is just a wrapper

/**
 * get number of hand slots
 *
 * semantically this means "physically there"
 * a broken hand is still there, a stump isn't
 */
/mob/proc/get_number_of_hands()
	return 0

/**
 * do we have hands?
 */
/mob/proc/has_hands()
	return FALSE

// these two will need rewritten when we get support for arbitrary hand numbers.

/mob/proc/drop_left_held_item(flags)
	return drop_held_item_of_index(1, flags)

/mob/proc/drop_right_held_item(flags)
	return drop_held_item_of_index(2, flags)
