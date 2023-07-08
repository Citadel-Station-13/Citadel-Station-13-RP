// todo: we need a set of 'core' procs subtypes need to override, and the rest are composites of those procs.

/mob/proc/put_in_hand(obj/item/I, index, flags)
	return index == 1? put_in_left_hand(I, flags) : put_in_right_hand(I, flags)

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

