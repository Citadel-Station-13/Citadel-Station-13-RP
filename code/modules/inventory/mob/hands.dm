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

//* Public API - Drop *//

//* Public API - Check *//
