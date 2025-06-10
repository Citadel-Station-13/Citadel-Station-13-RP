//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: deal with below; new inventory-level api, don't just mirror from mob?

//* Procs in this file are mirrored to the /mob level for ease of use.        *//
//*                                                                           *//
//* In the future, there should likely be a separation of concerns            *//
//* and the enforcement of 'mob.inventory' access, but given the overhead of  *//
//* a proc-call, this is currently not done.                                  *//

/datum/inventory/proc/put_in_hand(obj/item/I, index, inv_op_flags)
	return owner.equip_hand_impl(I, index, inv_op_flags) ? INV_RETURN_SUCCESS : INV_RETURN_FAILED

/mob/proc/put_in_hand(obj/item/I, index, inv_op_flags)
	return inventory?.put_in_hand(I, index, inv_op_flags)

/**
 * **Warning**: `prioritize_index` is patched to support legacy behavior by defaulting to owner active hand.
 *              This may be removed at any time. Besure to specify the index if you need this behavior.
 *
 * @params
 * * I - the item
 * * inv_op_flags - inventory operation flags
 * * prioritize_index - try that index first; defaults to the inventory owner's active hand, if any. set to `0` (not null!) to prioritize none.
 */
/datum/inventory/proc/put_in_hands(obj/item/I, inv_op_flags, prioritize_index)
	if(isnull(prioritize_index))
		prioritize_index = owner.active_hand

	if(is_holding(I))
		return INV_RETURN_SUCCESS

	if(!(inv_op_flags & INV_OP_NO_MERGE_STACKS) && istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		for(var/obj/item/stack/held_stack in get_held_items())
			if(S.can_merge(held_stack) && S.merge(held_stack))
				to_chat(owner, SPAN_NOTICE("The [held_stack.name] in your hands now contains [held_stack.get_amount()] [held_stack.singular_name]\s."))
				if(QDELETED(S))
					return INV_RETURN_SUCCESS

	if(prioritize_index)
		var/priority_result = put_in_hand(I, prioritize_index, inv_op_flags)
		switch(priority_result)
			if(INV_RETURN_FAILED)
			else
				return priority_result

	for(var/i in 1 to length(held_items))
		if(i == prioritize_index)
			continue
		var/result = put_in_hand(I, i, inv_op_flags)
		switch(result)
			if(INV_RETURN_FAILED)
			else
				return result

	return INV_RETURN_FAILED

/**
 * **Warning**: `prioritize_index` is patched to support legacy behavior by defaulting to owner active hand.
 *              This may be removed at any time. Besure to specify the index if you need this behavior.
 *
 * @params
 * * I - the item
 * * inv_op_flags - inventory operation flags
 * * prioritize_index - try that index first; defaults to the inventory owner's active hand, if any. set to `0` (not null!) to prioritize none.
 */
/mob/proc/put_in_hands(obj/item/I, inv_op_flags, prioritize_index)
	return inventory?.put_in_hands(I, inv_op_flags, prioritize_index)

/**
 * puts an item in hands or forcemoves to drop_loc
 *
 * * if 'specific_index' is specified, this only tries to go to that hand index.
 * * drop_loc defaults to the owner's location, if any owner is there.
 * * not having a valid drop_loc is a runtime error.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/put_in_hands_or_drop(obj/item/I, inv_op_flags, atom/drop_loc, specific_index)
	if(isnull(drop_loc))
		drop_loc = owner?.drop_location()
	if(isnull(drop_loc))
		CRASH("invalid drop location; placing stuff into nullspace is usually an error.")

	var/result = specific_index ? put_in_hand(I, specific_index, inv_op_flags) : put_in_hands(I, inv_op_flags)

	// todo: switch(result) once put_in_hands uses INV_RETURN_*; convert this
	if(!result)
		I.forceMove(drop_loc)
		return INV_RETURN_FAILED
	return INV_RETURN_SUCCESS

/**
 * puts an item in hands or forcemoves to drop_loc
 *
 * * if 'specific_index' is specified, this only tries to go to that hand index.
 * * drop_loc defaults to the owner's location, if any owner is there.
 * * not having a valid drop_loc is a runtime error.
 *
 * @return INV_RETURN_*
 */
/mob/proc/put_in_hands_or_drop(obj/item/I, inv_op_flags, atom/drop_loc, specific_index)
	// inventory null --> INV_RETURN_FAILED, as that's also #define'd to be null
	if(!inventory)
		I.forceMove(drop_loc || drop_location())
		return INV_RETURN_FAILED
	return inventory?.put_in_hands_or_drop(I, inv_op_flags, drop_loc, specific_index)

/**
 * puts an item in hands or deletes it
 *
 * * if 'specific_index' is specified, this only tries to go to that hand index.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/put_in_hands_or_del(obj/item/I, inv_op_flags, specific_index)
	var/result = specific_index ? put_in_hand(I, specific_index, inv_op_flags) : put_in_hands(I, inv_op_flags)

	// todo: switch(result) once put_in_hands uses INV_RETURN_*; convert this
	if(!result)
		qdel(I)
		return INV_RETURN_FAILED
	return INV_RETURN_SUCCESS

/**
 * puts an item in hands or deletes it
 *
 * * if 'specific_index' is specified, this only tries to go to that hand index.
 *
 * @return INV_RETURN_*
 */
/mob/proc/put_in_hands_or_del(obj/item/I, inv_op_flags, specific_index)
	if(inventory)
		return inventory.put_in_hands_or_del(I, inv_op_flags, specific_index)
	qdel(I)
	return INV_RETURN_FAILED

//*                   By Side                       *//
//* This is not on /datum/inventory level as        *//
//* oftentimes a mob has no semantic 'sided hands'. *//

/mob/proc/put_in_left_hand(obj/item/I, inv_op_flags)
	for(var/i in 1 to length(inventory?.held_items) step 2) //Odds a left hands
		if(put_in_hand(I, i, inv_op_flags))
			return TRUE
	return FALSE

/mob/proc/put_in_right_hand(obj/item/I, inv_op_flags)
	for(var/i in 2 to length(inventory?.held_items) step 2) //Evens a right hands
		if(put_in_hand(I, i, inv_op_flags))
			return TRUE
	return FALSE
