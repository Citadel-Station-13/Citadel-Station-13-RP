
#warn impl - check overrides too

/mob/proc/put_in_hands

/mob/proc/put_in_r_hand

/mob/proc/put_in_l_hand

/**
 * returns held items
 */
/mob/proc/get_held_items()
	. = list()

/**
 * return index of item, or null if not found
 */
/mob/proc/get_held_index(obj/item/I)

/**
 * get held item item at index
 */
/mob/proc/get_held_item_of_index(index)

/mob/proc/put_in_active_hand(obj/item/I, force)

/mob/proc/put_in_inactive_hand(obj/item/I, force)

/mob/proc/put_in_hand(obj/item/I, index, force))

/**
 * returns held item in active hand
 */
/mob/proc/get_active_held_item()

/**
 * returns held item in inactive hand (or any inactive hand if more than 1)
 */
/mob/proc/get_inactive_held_item()

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
