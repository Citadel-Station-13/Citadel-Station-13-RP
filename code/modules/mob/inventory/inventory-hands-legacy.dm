//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: deal with below; new inventory-level api, don't just mirror from mob?

/**
 * returns if we're holding something in inactive hand slots
 *
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/is_holding_inactive(obj/item/I)
	return is_holding(I) && (get_active_held_item() != I)

/**
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/drop_active_held_item(flags)
	return drop_item_to_ground(get_active_held_item(), flags)

/**
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/drop_inactive_held_item(flags)
	return drop_item_to_ground(get_inactive_held_item(), flags)

/**
 * returns held item in active hand
 *
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/get_active_held_item()
	RETURN_TYPE(/obj/item)
	return inventory?.held_items?[active_hand]

/**
 * returns held item in inactive hand (or any inactive hand if more than 1)
 *
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/get_inactive_held_item()
	RETURN_TYPE(/obj/item)
	for(var/i in 1 to length(inventory?.held_items))
		if(i == active_hand)
			continue
		if(isnull(inventory?.held_items[i]))
			continue
		return inventory?.held_items[i]

/**
 * returns all items held in non active hands
 *
 * todo: deprecate; 'active hand' should be based on client intent, not on the mob.
 */
/mob/proc/get_inactive_held_items()
	RETURN_TYPE(/list)
	. = list()
	for(var/i in 1 to length(inventory?.held_items))
		if(i == active_hand)
			continue
		if(isnull(inventory?.held_items[i]))
			continue
		. += inventory?.held_items[i]

/mob/proc/put_in_active_hand(obj/item/I, flags)
	return put_in_hand(I, active_hand, flags)

/mob/proc/put_in_inactive_hand(obj/item/I, flags)
	for(var/i in 1 to length(inventory?.held_items))
		if(i == active_hand)
			continue
		if(put_in_hand(I, i, flags))
			return TRUE
	return FALSE
