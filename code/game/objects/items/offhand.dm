/**
 * offhand items used for a multitude of things
 *
 * make your own subtype please, to set name/desc.
 */
/obj/item/offhand
	name = "broken offhand"
	desc = "fire coderbus"
	item_flags = ITEM_DROPDEL | ITEM_ABSTRACT | ITEM_NOBLUDGEON
#warn make icon
	icon = 'icons/obj/item/abstract/offhand.dmi'
	icon_state = ""
	drop_sound = null
	equip_sound = null
	pickup_sound = null
	unequip_sound = null

// just in case
/obj/item/offhand/can_equip(mob/M, slot, mob/user, flags)
	if(slot != SLOT_ID_HANDS)
		return FALSE
	return ..()

/**
 * allocates an offhand item if possible
 *
 * @params
 * - index - preferred hand
 * - flags - inv flags
 */
/mob/proc/allocate_offhand(index, flags)
	#warn impl
