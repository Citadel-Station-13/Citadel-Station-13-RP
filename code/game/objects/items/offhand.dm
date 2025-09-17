/**
 * offhand items used for a multitude of things
 *
 * make your own subtype please, to set name/desc.
 */
/obj/item/offhand
	name = "broken offhand"
	desc = "fire coderbus"
	item_flags = ITEM_DROPDEL | ITEM_ABSTRACT | ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	icon = 'icons/obj/item/abstract.dmi'
	icon_state = "offhand"
	drop_sound = null
	equip_sound = null
	pickup_sound = null
	unequip_sound = null

	/// if clicked on an item, automatically try to pick that item up to drop us.
	var/allow_item_pickup_replace = FALSE

// just in case
/obj/item/offhand/can_equip(mob/M, slot, mob/user, flags)
	if(slot != SLOT_ID_HANDS)
		return FALSE
	return ..()

/obj/item/offhand/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	if(isitem(target) && allow_item_pickup_replace)
		var/obj/item/target_item = target
		if(target_item.should_allow_pickup(e_args))
			e_args.chat_feedback(SPAN_WARNING("You [get_host_drop_descriptor()] to pick up [target_item]."))
			e_args.performer.drop_item_to_ground(src)
			target_item.attempt_pickup(e_args.performer)
			return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/offhand/proc/get_host_drop_descriptor()
	return "drop your grip"

/**
 * allocates an offhand item if possible
 *
 * returns offhand or null
 *
 * @params
 * - type - the type of the offhand
 * - index - hand index; null for any
 * - inv_op_flags - inv flags
 * - ... - the rest of the args are passed into New() of the offhand.
 */
/mob/proc/allocate_offhand(type, index, inv_op_flags, ...)
	RETURN_TYPE(/obj/item/offhand)
	var/obj/item/offhand/O = new type(arglist(list(src) + args.Copy(4)))
	if(index)
		if(put_in_hands_or_del(O, inv_op_flags, index))
			return O
	else
		if(put_in_hands_or_del(O, inv_op_flags))
			return O
