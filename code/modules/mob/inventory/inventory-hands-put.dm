//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

// todo: return INV_RETURN_*
/datum/inventory/proc/put_in_hand(obj/item/I, index, inv_op_flags)
	#warn impl & below

/mob/proc/put_in_hand(obj/item/I, index, inv_op_flags)
	return equip_hand_impl(I, index, inv_op_flags)

// todo: return INV_RETURN_*
/datum/inventory/proc/put_in_hands(obj/item/I, inv_op_flags)
	#warn impl & below

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
 * puts an item in hands or forcemoves to drop_loc
 *
 * * drop_loc defaults to the owner's location, if any owner is there.
 * * not having a valid drop_loc is a runtime error.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/put_in_hands_or_drop(obj/item/I, inv_op_flags, atom/drop_loc)
	if(isnull(drop_loc))
		drop_loc = owner?.drop_location()
	if(isnull(drop_loc))
		CRASH("invalid drop location; placing stuff into nullspace is usually an error.")

	var/result = put_in_hands(I, inv_op_flags)

	// todo: switch(result) once put_in_hands uses INV_RETURN_*; convert this
	if(!result)
		I.forceMove(drop_loc)
		return INV_RETURN_FAILED
	return INV_RETURN_SUCCESS

/**
 * puts an item in hands or forcemoves to drop_loc
 *
 * * drop_loc defaults to the owner's location, if any owner is there.
 * * not having a valid drop_loc is a runtime error.
 *
 * @return INV_RETURN_*
 */
/mob/proc/put_in_hands_or_drop(obj/item/I, inv_op_flags, atom/drop_loc)
	// inventory null --> INV_RETURN_FAILED, as that's also #define'd to be null
	return inventory?.put_in_hands_or_drop(I, inv_op_flags, drop_loc)

#warn mirror & check below

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

/mob/proc/put_in_hand_or_del(obj/item/I, index, flags)
	. = put_in_hand(I, index, flags)
	if(!.)
		qdel(I)

/mob/proc/put_in_hand_or_drop(obj/item/I, index, flags, atom/drop_loc = drop_location())
	. = put_in_hand(I, index, flags)
	if(!.)
		I.forceMove(drop_loc)

#warn mirror & check above

//*                   By Side                       *//
//* This is not on /datum/inventory level as        *//
//* oftentimes a mob has no semantic 'sided hands'. *//

/mob/proc/put_in_left_hand(obj/item/I, inv_op_flags)
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(put_in_hand(I, i, inv_op_flags))
			return TRUE
	return FALSE

/mob/proc/put_in_right_hand(obj/item/I, inv_op_flags)
	for(var/i in 1 to length(inventory?.held_items) step 2)
		if(put_in_hand(I, i, inv_op_flags))
			return TRUE
	return FALSE
