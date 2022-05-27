
#warn impl - check overrides too

/mob/proc/put_in_hands(obj/item/I, force)
	return put_in_active_hand(I, force) || put_in_inactive_hand(I, force)

/**
 * put in hands or forcemove to drop location
 * allows an optional param for where to drop on fail
 *
 * @return TRUE/FALSE based on put in hand or dropped to ground
 */
/mob/proc/put_in_hands_or_drop(obj/item/I, force, atom/drop_loc = drop_location())
	if(!put_in_hands(I, force))
		I.forceMove(drop_loc)
		return FALSE
	return TRUE

/mob/proc/put_in_r_hand(obj/item/I, force)
	return FALSE

/mob/proc/put_in_l_hand(obj/item/I, force)
	return FALSE

/**
 * returns held items
 */
/mob/proc/get_held_items()
	. = list()

/**
 * get held items of type
 */
/mob/proc/get_held_items_of_type(type)
	. = list()
	for(var/obj/item/I as anything in get_held_items())
		if(istype(I, type))
			. += I

/**
 * get first held item of type
 */
/mob/proc/get_held_item_of_type(type)
	for(var/obj/item/I as anything in get_held_items())
		if(istype(I, type))
			return I

/**
 * return index of item, or null if not found
 */
/mob/proc/get_held_index(obj/item/I)
	return

/**
 * get held item item at index
 */
/mob/proc/get_held_item_of_index(index)
	return FALSE

/mob/proc/put_in_active_hand(obj/item/I, force)
	return FALSE

/mob/proc/put_in_inactive_hand(obj/item/I, force)
	return FALSE

/mob/proc/put_in_hand(obj/item/I, index, force)
	return FALSE

/**
 * hands are full?
 */
/mob/proc/hands_full()
	return FALSE

/**
 * returns held item in active hand
 */
/mob/proc/get_active_held_item()
	return

/**
 * returns held item in inactive hand (or any inactive hand if more than 1)
 */
/mob/proc/get_inactive_held_item()
	return

/**
 * get number of hand slots
 *
 * semantically this means "physically there"
 * a broken hand is still there, a stump isn't
 */
/mob/proc/get_number_of_hands()
	return 0

/**
 * returns if we are holding something
 */
/mob/proc/is_holding(obj/item/I)
	return !!get_held_index(I)

/**
 * drops all our held items
 *
 * @params
 * force - even if nodrop
 */
/mob/proc/drop_all_held_items(force)
	for(var/obj/item/I as anything in get_held_items())
		drop_item_to_ground(I, force = force)

/mob/proc/drop_active_held_item(force)
	return drop_item_to_ground(get_active_held_item(), force = force)

/mob/proc/drop_inactive_held_item(force)
	return drop_item_to_ground(get_inactive_held_item(), force = force)

/mob/proc/drop_held_item_of_index(index, force)
	return drop_item_to_ground(get_held_item_of_index(index), force = force)
