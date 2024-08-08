//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

#warn mirror & check below

/mob/proc/put_in_hand(obj/item/I, index, flags)
	return equip_hand_impl(I, index, flags)

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
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE

/mob/proc/put_in_right_hand(obj/item/I, flags)
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE

/mob/proc/put_in_active_hand(obj/item/I, flags)
	return put_in_hand(I, active_hand, flags)

/mob/proc/put_in_inactive_hand(obj/item/I, flags)
	for(var/i in 1 to length(inventory?.held_items))
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
