//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Internal inventory logic
 * You shouldn't be calling or modifying these without good reason.
 */

//* Routing *//

/**
 * handles the insertion
 * item can be moved or not moved before calling
 *
 * slot must be a typepath
 *
 * @return true/false based on if it worked
 */
/mob/proc/handle_abstract_slot_insertion(obj/item/I, slot, flags)
	if(!ispath(slot, /datum/inventory_slot/abstract))
		slot = resolve_inventory_slot(slot)?.type
		if(!ispath(slot, /datum/inventory_slot/abstract))
			stack_trace("invalid slot: [slot]")
		else if(slot != /datum/inventory_slot/abstract/put_in_hands)
			stack_trace("attempted usage of slot id in abstract insertion converted successfully")
	. = FALSE
	switch(slot)
		if(/datum/inventory_slot/abstract/hand/left)
			return put_in_left_hand(I, flags)
		if(/datum/inventory_slot/abstract/hand/right)
			return put_in_right_hand(I, flags)
		if(/datum/inventory_slot/abstract/put_in_belt)
			var/obj/item/held = item_by_slot_id(SLOT_ID_BELT)
			if(flags & INV_OP_FORCE)
				return held?.obj_storage?.insert(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_SOUND)
			return held?.obj_storage?.auto_handle_inventory_insertion(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_SUPPRESS_SOUND)
		if(/datum/inventory_slot/abstract/put_in_backpack)
			var/obj/item/held = item_by_slot_id(SLOT_ID_BACK)
			if(flags & INV_OP_FORCE)
				return held?.obj_storage?.insert(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_SOUND)
			return held?.obj_storage?.auto_handle_inventory_insertion(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_SUPPRESS_SOUND)
		if(/datum/inventory_slot/abstract/put_in_hands)
			return put_in_hands(I, flags)
		if(/datum/inventory_slot/abstract/put_in_storage, /datum/inventory_slot/abstract/put_in_storage_try_active)
			if(slot == /datum/inventory_slot/abstract/put_in_storage_try_active)
				// todo: redirection
				if(flags & INV_OP_FORCE)
					if(active_storage?.insert(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_WARNING))
						return TRUE
				else
					if(active_storage?.auto_handle_inventory_insertion(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_SUPPRESS_SOUND))
						return TRUE
			for(var/obj/item/held in get_equipped_items_in_slots(list(
				SLOT_ID_BELT,
				SLOT_ID_BACK,
				SLOT_ID_UNIFORM,
				SLOT_ID_SUIT,
				SLOT_ID_LEFT_POCKET,
				SLOT_ID_RIGHT_POCKET
			)) + get_held_items())
				if(isnull(held?.obj_storage))
					continue
				if(flags & INV_OP_FORCE)
					return held.obj_storage.insert(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_SOUND)
				return held.obj_storage.auto_handle_inventory_insertion(I, new /datum/event_args/actor(src), flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_SUPPRESS_SOUND)
			return FALSE
		if(/datum/inventory_slot/abstract/attach_as_accessory)
			for(var/obj/item/clothing/C in get_equipped_items())
				if(C.attempt_attach_accessory(I))
					return TRUE
			return FALSE
		else
			CRASH("Invalid abstract slot [slot]")

//* Unequip *//

/**
 * handles internal logic of unequipping an item
 *
 * @params
 * - I - item
 * - flags - inventory operation hint bitfield, see defines
 * - newloc - where to transfer to. null for nullspace, FALSE for don't transfer
 * - user - can be null - person doing the removals
 *
 * @return TRUE/FALSE for success
 */
/mob/proc/_unequip_item(obj/item/I, flags, newloc, mob/user = src)
	PROTECTED_PROC(TRUE)
	if(!I)
		return TRUE

	var/hand = get_held_index(I)
	var/old
	if(hand)
		if(!can_unequip(I, SLOT_ID_HANDS, flags, user))
			return FALSE
		unequip_hand_impl(I, hand, flags)
		old = SLOT_ID_HANDS
	else
		if(!I.worn_slot)
			stack_trace("tried to unequip an item without current equipped slot.")
			I.worn_slot = _slot_by_item(I)
		if(!can_unequip(I, I.worn_slot, flags, user))
			return FALSE
		old = I.worn_slot
		_unequip_slot(old, flags, I)
		I.on_inv_unequipped(src, inventory, old, flags)
		I.unequipped(src, old, flags)
		handle_item_denesting(I, old, flags, user)

	// this qdeleted catches unequipped() deleting the item.
	. = QDELETED(I)? FALSE : TRUE

	if(I)
		// todo: better rendering that takes observers into account
		if(client)
			client.screen -= I
			I.screen_loc = null
		//! at some point we should have /pre_dropped and /pre_pickup, because dropped should logically come after move.
		if(I.dropped(src, flags, newloc) == ITEM_RELOCATED_BY_DROPPED)
			. = FALSE
		else if(QDELETED(I))
			// this check RELIES on dropped() being the first if
			// make sure you don't blindly move it!!
			// this is meant to catch any potential deletions dropped can cause.
			. = FALSE
		else
			if(!(I.item_flags & ITEM_DROPDEL))
				if(newloc == null)
					I.moveToNullspace()
				else if(newloc != FALSE)
					I.forceMove(newloc)

	log_inventory("[key_name(src)] unequipped [I] from [old].")

/mob/proc/_unequip_slot(slot, flags, obj/item/yanking)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/obj/item/old = _item_by_slot(slot)
	if(old != yanking)
		return FALSE
	. = _set_inv_slot(slot, null, flags) != INVENTORY_SLOT_DOES_NOT_EXIST
	if(.)
		inventory.on_item_exited(old, resolve_inventory_slot(slot))

/**
 * handles removing an item from our hud
 *
 * some things call us from outside inventory code. this is shitcode and shouldn't be propageted.
 */
/mob/proc/_handle_inventory_hud_remove(obj/item/I)
	if(client)
		client.screen -= I
	I.screen_loc = null

//* Equip *//

/**
 * handles internal logic of equipping an item
 *
 * @params
 * - I - item to equip
 * - flags - inventory operation hint flags, see defines
 * - slot - slot to equip it to
 * - user - user trying to put it on us
 *
 * @return TRUE/FALSE on success
 */
/mob/proc/_equip_item(obj/item/I, flags, slot, mob/user = src)
	if(!I)		// how tf would we put on "null"?
		return FALSE

	// resolve slot
	var/datum/inventory_slot/slot_meta = resolve_inventory_slot(slot)
	if(slot_meta.inventory_slot_flags & INV_SLOT_IS_ABSTRACT)
		// if it's abstract, we go there directly - do not use can_equip as that will just guess.
		return handle_abstract_slot_insertion(I, slot, flags)

	// slots must have IDs.
	ASSERT(!isnull(slot_meta.id))
	// convert to ID after abstract slot checks
	slot = slot_meta.id

	var/old_slot = slot_id_by_item(I)

	if(old_slot)
		. = _handle_item_reequip(I, slot, old_slot, flags, user)
		if(!.)
			return

		log_inventory("[key_name(src)] moved [I] from [old_slot] to [slot].")
	else
		if(!can_equip(I, slot, flags | INV_OP_IS_FINAL_CHECK, user))
			return FALSE

		var/atom/oldLoc = I.loc
		if(I.loc != src)
			I.forceMove(src)
		if(I.loc != src)
			// UH OH, SOMEONE MOVED US
			log_inventory("[key_name(src)] failed to equip [I] to slot (loc sanity failed).")
			// UH OH x2, WE GOT WORN OVER SOMETHING
			if(I.worn_over)
				handle_item_denesting(I, slot, INV_OP_FATAL, user)
			return FALSE

		_equip_slot(I, slot, flags)

		// TODO: HANDLE DELETIONS IN PICKUP AND EQUIPPED PROPERLY
		I.pickup(src, flags, oldLoc)
		I.equipped(src, slot, flags)

		log_inventory("[key_name(src)] equipped [I] to [slot].")

	if(I.zoom)
		I.zoom()

	return TRUE

/mob/proc/_equip_slot(obj/item/I, slot, flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = _set_inv_slot(slot, I, flags) != INVENTORY_SLOT_DOES_NOT_EXIST
	if(.)
		inventory.on_item_entered(I, resolve_inventory_slot(slot))

//* Slot Change *//

/**
 * checks if we already have something in our inventory
 * if so, this will try to shift the slots over, calling equipped/unequipped automatically
 *
 * INV_OP_FORCE will allow ignoring can unequip.
 *
 * return true/false based on if we succeeded
 */
/mob/proc/_handle_item_reequip(obj/item/I, slot, old_slot, flags, mob/user = src, hand_index)
	ASSERT(slot)
	if(!old_slot)
		// DO NOT USE _slot_by_item - at this point, the item has already been var-set into the new slot!
		// slot_id_by_item however uses cached values still!
		old_slot = slot_id_by_item(I)
		if(!old_slot)
			// still not there, wasn't already in inv
			return FALSE
	// this IS a slot shift!
	. = old_slot
	if((slot == old_slot) && (slot != SLOT_ID_HANDS))
		// lol we're done (unless it was hands)
		return TRUE
	if(slot == SLOT_ID_HANDS)
		// if we're going into hands,
		// just check can unequip
		if(!can_unequip(I, old_slot, flags, user))
			// check can unequip
			return FALSE
		// call procs
		if(old_slot == SLOT_ID_HANDS)
			unequip_hand_impl(I, get_held_index(I), flags)
		else
			_unequip_slot(old_slot, flags, I)
		I.on_inv_unequipped(src, inventory, old_slot, flags)
		I.unequipped(src, old_slot, flags)
		// sigh
		handle_item_denesting(I, old_slot, flags, user)
		// TODO: HANDLE DELETIONS ON EQUIPPED PROPERLY, INCLUDING ON HANDS
		// ? we don't do this on hands, hand procs do it
		// _equip_slot(I, slot, update_icons)
		I.held_index = hand_index
		I.equipped(src, slot, flags)
		log_inventory("[key_name(src)] moved [I] from [old_slot] to hands.")
		// hand procs handle rest
		return TRUE
	else
		// else, this gets painful
		if(!can_unequip(I, old_slot, flags, user))
			return FALSE
		if(!can_equip(I, slot, flags | INV_OP_IS_FINAL_CHECK, user, old_slot))
			return FALSE
		// ?if it's from hands, hands aren't a slot.
		if(old_slot == SLOT_ID_HANDS)
			unequip_hand_impl(I, get_held_index(I), flags)
		else
			_unequip_slot(old_slot, flags, I)
		I.unequipped(src, old_slot, flags)
		I.on_inv_unequipped(src, inventory, old_slot, flags)
		// TODO: HANDLE DELETIONS ON EQUIPPED PROPERLY
		// sigh
		_equip_slot(I, slot, flags)
		I.equipped(src, slot, flags)
		log_inventory("[key_name(src)] moved [I] from [old_slot] to [slot].")
		return TRUE
