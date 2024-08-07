
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
