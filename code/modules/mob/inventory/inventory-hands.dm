//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/**
 * the big, bad proc ultimately in charge of putting something into someone's hand
 * whether it's from the ground, from a slot, or from another hand.
 */
/mob/proc/equip_hand_impl(obj/item/I, index, flags)
	PRIVATE_PROC(TRUE)
	if(!I)
		return TRUE
	// let's not do that if it's deleted!
	if(QDELETED(I))
		to_chat(src, SPAN_DANGER("A deleted item [I] ([REF(I)]) was sent into inventory hand procs with flags [flags]. Report this line to coders immediately."))
		to_chat(src, SPAN_DANGER("The inventory system will attempt to reject the bad equip. Glitches may occur."))
		return FALSE

	if(length(inventory?.held_items) < index)
		return FALSE

	var/obj/item/existing = inventory?.held_items[index]
	if(!isnull(existing))
		if(flags & INV_OP_FORCE)
			drop_held_index(index, flags | INV_OP_NO_UPDATE_ICONS)
			if(!isnull(inventory?.held_items[index]))
				// failed to drop
				return FALSE
		else
			return FALSE

	var/existing_slot = is_in_inventory(I)
	if(existing_slot)
		// already in inv
		if(!_handle_item_reequip(I, SLOT_ID_HANDS, existing_slot, flags))
			return FALSE
	else
		// newly eqiupped
		var/atom/old_loc = I.loc
		if(I.loc != src)
			I.forceMove(src)
		if(I.loc != src)
			return FALSE
		I.pickup(src, flags, old_loc)
		I.equipped(src, SLOT_ID_HANDS, flags)
		log_inventory("pickup-to-hand: keyname [key_name(src)] index [index] item [I]([ref(I)])")

	inventory?.held_items[index] = I
	#warn hud

	//! LEGACY BEGIN
	I.update_twohanding()
	//! END

	if(!(flags & INV_OP_NO_UPDATE_ICONS))
		update_inv_hand(index)

	if(!(I.interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH))
		I.add_fingerprint(src)
	else
		I.add_hiddenprint(src)

/**
 * get something out of our hand
 *
 * @return unequipped item
 */
/mob/proc/unequip_hand_impl(obj/item/I, index, flags)
	ASSERT(inventory?.held_items[index] == I)

	inventory?.held_items[index] = null

	I.unequipped(src, SLOT_ID_HANDS, flags)
	#warn impl; hud

/**
 * handle swapping item from one hand index to another
 */
/mob/proc/handle_item_handswap(obj/item/I, index, old_index, flags, mob/user = src)
	ASSERT(inventory?.held_items[old_index] == I)
	ASSERT(isnull(inventory?.held_items[index]))

	inventory?.held_items[old_index] = null
	inventory?.held_items[index] = I

	#warn impl; hud
