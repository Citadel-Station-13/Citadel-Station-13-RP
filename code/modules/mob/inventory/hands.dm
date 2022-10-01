/mob/proc/put_in_hands(obj/item/I, flags)
	if(is_holding(I))
		return TRUE

	if(!(flags & INV_OP_NO_MERGE_STACKS) && istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		for(var/obj/item/stack/held_stack in get_held_items())
			if(S.can_merge(held_stack) && S.merge(held_stack))
				to_chat(src, SPAN_NOTICE("Your [held_stack] stack now contains [held_stack.get_amount()] [held_stack.singular_name]\s."))
				return TRUE

	return put_in_active_hand(I, flags) || put_in_inactive_hand(I, flags)

/**
 * put in hands or forcemove to drop location
 * allows an optional param for where to drop on fail
 *
 * @return TRUE/FALSE based on put in hand or dropped to ground
 */
/mob/proc/put_in_hands_or_drop(obj/item/I, flags, atom/drop_loc = drop_location())
	if(!put_in_hands(I, flags))
		I.forceMove(drop_loc)
		return FALSE
	return TRUE

/**
 * put in hands or del
 *
 * @return TRUE/FALSE based on put in hand or del'd
 */
/mob/proc/put_in_hands_or_del(obj/item/I, flags)
	if(!put_in_hands(I, flags))
		qdel(I)
		return FALSE
	return TRUE

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
 * returns held items
 */
/mob/proc/get_held_items()
	. = list()

/mob/proc/get_left_held_item()
	RETURN_TYPE(/obj/item)
	return

/mob/proc/get_left_held_items()
	var/obj/item/I = get_left_held_item()
	if(I)
		return list(I)
	return list()
	// TODO: actual variable hand count

/mob/proc/get_right_held_item()
	RETURN_TYPE(/obj/item)
	return

/mob/proc/get_right_held_items()
	var/obj/item/I = get_right_held_item()
	if(I)
		return list(I)
	return list()
	// TODO: actual variable hand count

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
	RETURN_TYPE(/obj/item)
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
	RETURN_TYPE(/obj/item)
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
/mob/proc/drop_all_held_items(flags)
	for(var/obj/item/I as anything in get_held_items())
		drop_item_to_ground(I, flags)

/mob/proc/drop_active_held_item(flags)
	return drop_item_to_ground(get_active_held_item(), flags)

/mob/proc/drop_inactive_held_item(flags)
	return drop_item_to_ground(get_inactive_held_item(), flags)

/mob/proc/drop_held_item_of_index(index, flags)
	return drop_item_to_ground(get_held_item_of_index(index), flags)

// these two will need rewritten when we get support for arbitrary hand numbers.

/mob/proc/drop_left_held_item(flags)
	return drop_held_item_of_index(1, flags)

/mob/proc/drop_right_held_item(flags)
	return drop_held_item_of_index(2, flags)
