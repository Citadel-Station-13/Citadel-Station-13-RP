/**
 * Hands are a bit of a special case
 *
 * They don't use inventory slots like the inventory system does,
 * But still exists in the inventory module because they do a number of things,
 * like count as equipped under [SLOT_ID_HANDS].
 *
 * This semi-integration lets us do a few cool things like not needing separate hooks
 * for when someone has something in hand, but not in inventory, transitioning
 * to them having it in inventory, but not in hands.
 */

//* Public API - Pickup *//

/mob/proc/put_in_hand(obj/item/I, index, flags)
	return put_in_hand_impl(I, index, flags)

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

/mob/proc/put_in_left_hand(obj/item/I, flags)
	for(var/i in 1 to length(held_items) step 2)
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE

/mob/proc/put_in_right_hand(obj/item/I, flags)
	for(var/i in 1 to length(held_items) step 2)
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE

/mob/proc/put_in_active_hand(obj/item/I, flags)
	return put_in_hand(I, active_hand, flags)

/mob/proc/put_in_inactive_hand(obj/item/I, flags)
	for(var/i in 1 to length(held_items))
		if(i == active_hand)
			continue
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE

/mob/proc/put_in_hand_or_del(obj/item/I, index, flags)
	. = put_in_hand(I, index, flags)
	if(!.)
		qdel(I)

/mob/proc/put_in_hand_or_drop(obj/item/I, index, flags, atom/drop_loc = drop_location())
	. = put_in_hand(I, index, flags)
	if(!.)
		I.forceMove(drop_loc)

//* Public API - Drop *//

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

/mob/proc/drop_sequential_left_held_item(flags)
	for(var/i in 1 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		return drop_held_item_of_index(i, flags)

/mob/proc/drop_sequential_right_held_item(flags)
	for(var/i in 2 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		return drop_held_item_of_index(i, flags)

//* Public API - Check *//

/**
 * returns if we are holding something
 */
/mob/proc/is_holding(obj/item/I)
	return !!get_held_index(I)

/**
 * returns if we're holding something in inactive hand slots
 */
/mob/proc/is_holding_inactive(obj/item/I)
	return is_holding(I) && (get_active_held_item() != I)

/**
 * hands are all holding items? undefined behavior if we don't have hands.
 */
/mob/proc/hands_full()
	for(var/i in get_usable_hand_indices())
		if(isnull(held_items[i]))
			return FALSE
	return TRUE

/**
 * hands are all empty? undefined behavior if we don't have hands.
 */
/mob/proc/hands_empty()
	for(var/i in get_usable_hand_indices())
		if(isnull(held_items[i]))
			continue
		return FALSE
	return TRUE

/**
 * returns number of empty hands
 */
/mob/proc/count_empty_hands()
	. = 0
	for(var/i in 1 to length(held_items))
		if(isnull(held_items[i]))
			.++

//* Public API - Get *//

/**
 * returns first item on left
 */
/mob/proc/get_left_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 1 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		return held_items[i]

/**
 * returns first item on right
 */
/mob/proc/get_right_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 2 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		return held_items[i]

/**
 * returns all items on left
 */
/mob/proc/get_left_held_items()
	RETURN_TYPE(/obj/item)
	. = list()
	for(var/i in 1 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		. += held_items[i]

/**
 * returns all items on right
 */
/mob/proc/get_right_held_items()
	RETURN_TYPE(/obj/item)
	. = list()
	for(var/i in 2 to length(held_items) step 2)
		if(isnull(held_items[i]))
			continue
		. += held_items[i]

/**
 * returns held items
 */
/mob/proc/get_held_items()
	. = list()
	for(var/obj/item/I in held_items)
		. += I

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
 * get held item item at index
 */
/mob/proc/get_held_item_of_index(index)
	RETURN_TYPE(/obj/item)
	return length(held_items) <= index? held_items[index] : null

/**
 * return index of item, or null if not found
 */
/mob/proc/get_held_index(obj/item/I)
	. = held_items?.Find(I)
	return .? . : null

/**
 * get full indices
 */
/mob/proc/get_full_hand_indices()
	. = list()
	for(var/i in 1 to length(held_items))
		if(!isnull(held_items[i]))
			. += i

/**
 * get empty indices
 */
/mob/proc/get_empty_hand_indices()
	. = list()
	for(var/i in 1 to length(held_items))
		if(isnull(held_items[i]))
			. += i

/**
 * returns held item in active hand
 */
/mob/proc/get_active_held_item()
	RETURN_TYPE(/obj/item)
	return held_items?[active_hand]

/**
 * returns held item in inactive hand (or any inactive hand if more than 1)
 */
/mob/proc/get_inactive_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 1 to length(held_items))
		if(i == active_hand)
			continue
		if(isnull(held_items[i]))
			continue
		return held_items[i]

/**
 * returns all items held in non active hands
 */
/mob/proc/get_inactive_held_items()
	RETURN_TYPE(/list)
	. = list()
	for(var/i in 1 to length(held_items))
		if(i == active_hand)
			continue
		if(isnull(held_items[i]))
			continue
		. += held_items[i]

//* Abstraction *//

/**
 * get number of physical hands / arms / whatever that we have and should check for
 *
 * this is not number we can use
 * this is the number we should use for things like rendering
 * a hand stump is still rendered, and we should never render less than 2 hands for mobs
 * that nominally have hands.
 */
/mob/proc/get_nominal_hand_count()
	#warn impl

/**
 * get number of usable hands / arms / whatever that we have and should check for
 *
 * this is the number we can use
 * missing = can't use
 * stump = can't use
 * broken = *can* use.
 *
 * basically if a red deny symbol is in the hand it is not usable, otherwise it's usable.
 */
/mob/proc/get_usable_hand_count()
	#warn impl

/**
 * get indices of usable hands
 */
/mob/proc/get_usable_hand_indices()
	RETURN_TYPE(/list)
	#warn impl

//* Internals *//

/**
 * the big, bad proc ultimately in charge of putting something into someone's hand
 * whether it's from the ground, from a slot, or from another hand.
 */
/mob/proc/put_in_hand_impl(obj/item/I, index, flags)
	PRIVATE_PROC(TRUE)
	if(!I)
		return TRUE
	// let's not do that if it's deleted!
	if(QDELETED(I))
		to_chat(src, SPAN_DANGER("A deleted item [I] ([REF(I)]) was sent into inventory hand procs with flags [flags]. Report this line to coders immediately."))
		to_chat(src, SPAN_DANGER("The inventory system will attempt to reject the bad equip. Glitches may occur."))
		return FALSE

	if(length(held_items) < index)
		return FALSE

	var/obj/item/existing = held_items[index]
	if(!isnull(existing))
		if(flags & INV_OP_FORCE)
			drop_held_item_of_index(index, flags | INV_OP_NO_UPDATE_ICONS)
			if(!isnull(held_items[index]))
				// failed to drop
				return FALSE
		else
			return FALSE

	var/existing_slot = is_in_inventory(I)
	if(existing_slot)
		// already in inv
		if(!_handle_item_reequip(I, SLOT_ID_HANDS, existing_slot, flags))
			return FALSE
	else
		// newly eqiupped
		var/atom/old_loc = I.loc
		if(I.loc != src)
			I.forceMove(src)
		if(I.loc != src)
			return FALSE
		I.pickup(src, flags, old_loc)
		I.equipped(src, SLOT_ID_HANDS, flags)
		log_inventory("pickup-to-hand: keyname [key_name(src)] index [index] item [I]([ref(I)])")

	held_items[index] = I

	//! LEGACY BEGIN
	I.update_twohanding()
	//! END

	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hand(index)

	if(!(I.interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH))
		I.add_fingerprint(src)
	else
		I.add_hiddenprint(src)

/**
 * handle swapping item from one hand index to another
 */
/mob/proc/handle_item_handswap(obj/item/I, index, old_index, flags, mob/user = src)
	#warn impl
