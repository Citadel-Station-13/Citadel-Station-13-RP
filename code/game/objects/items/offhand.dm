/**
 * offhand items used for a multitude of things
 *
 * make your own subtype please, to set name/desc.
 */
/obj/item/offhand
	name = "broken offhand"
	desc = "fire coderbus"
	item_flags = ITEM_DROPDEL | ITEM_ABSTRACT | ITEM_NOBLUDGEON
	icon = 'icons/obj/item/abstract.dmi'
	icon_state = "offhand"
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
 * returns offhand or null
 *
 * @params
 * - type - the type of the offhand
 * - index - hand index; null for any
 * - flags - inv flags
 * - ... - the rest of the args are passed into New() of the offhand.
 */
/mob/proc/allocate_offhand(type, index, flags, ...)
	RETURN_TYPE(/obj/item/offhand)
	var/obj/item/offhand/O = new type(arglist(list(src) + args.Copy(4)))
	if(index)
		if(put_in_hand_or_del(O, index, flags))
			return O
	else
		if(put_in_hands_or_del(O, flags))
			return O
