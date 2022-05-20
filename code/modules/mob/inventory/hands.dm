
#warn impl - check overrides too

/mob/proc/put_in_hands

/mob/proc/put_in_r_hand

/mob/proc/put_in_l_hand

/mob/proc/get_held_items()

/mob/proc/get_held_index(obj/item/I)

/mob/proc/put_in_active_hand

/mob/proc/put_in_inactive_hand

/mob/proc/get_active_held_item

/mob/proc/get_inactive_held_item

/**
 * returns if we are holding something
 */
/mob/proc/is_holding(obj/item/I)

/**
 * drops all our held items
 *
 * @params
 * force - even if nodrop
 */
/mob/proc/drop_all_held_items(force)
	#warn impl

/mob/proc/drop_active_held_item()

/mob/proc/drop_inactive_held_item()
