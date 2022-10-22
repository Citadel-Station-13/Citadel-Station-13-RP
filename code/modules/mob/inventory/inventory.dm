/**
 * handles the insertion
 * item can be moved or not moved before calling
 *
 * slot must be a typepath
 *
 * @return true/false based on if it worked
 */
/mob/proc/handle_abstract_slot_insertion(obj/item/I, slot, flags)
	if(!ispath(slot, /datum/inventory_slot_meta/abstract))
		slot = resolve_inventory_slot_meta(slot)?.type
		if(!ispath(slot, /datum/inventory_slot_meta/abstract))
			stack_trace("invalid slot: [slot]")
		else
			stack_trace("attempted usage of slot id in abstract insertion converted successfully")
	. = FALSE
	switch(slot)
		if(/datum/inventory_slot_meta/abstract/hand/left)
			return put_in_left_hand(I, flags)
		if(/datum/inventory_slot_meta/abstract/hand/right)
			return put_in_right_hand(I, flags)
		if(/datum/inventory_slot_meta/abstract/put_in_belt)
			var/obj/item/storage/S = item_by_slot(SLOT_ID_BELT)
			return istype(S) && S.try_insert(I, src, flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_FORCE)
		if(/datum/inventory_slot_meta/abstract/put_in_backpack)
			var/obj/item/storage/S = item_by_slot(SLOT_ID_BACK)
			return istype(S) && S.try_insert(I, src, flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_FORCE)
		if(/datum/inventory_slot_meta/abstract/put_in_hands)
			return put_in_hands(I, flags)
		if(/datum/inventory_slot_meta/abstract/put_in_storage, /datum/inventory_slot_meta/abstract/put_in_storage_try_active)
			if(slot == /datum/inventory_slot_meta/abstract/put_in_storage_try_active)
				if(s_active && Adjacent(s_active) && s_active.try_insert(I, src, flags & INV_OP_SUPPRESS_WARNING, flags & INV_OP_FORCE))
					return TRUE
			for(var/obj/item/storage/S in get_equipped_items_in_slots(list(
				SLOT_ID_BELT,
				SLOT_ID_BACK,
				SLOT_ID_UNIFORM,
				SLOT_ID_SUIT,
				SLOT_ID_LEFT_POCKET,
				SLOT_ID_RIGHT_POCKET
			)) + get_held_items())
				if(S.try_insert(I, src, INV_OP_SUPPRESS_WARNING, flags & INV_OP_FORCE))
					return TRUE
			return FALSE
		if(/datum/inventory_slot_meta/abstract/attach_as_accessory)
			for(var/obj/item/clothing/C in get_equipped_items())
				if(C.attempt_attach_accessory(I))
					return TRUE
			return FALSE
		else
			CRASH("Invalid abstract slot [slot]")


// So why do all of these return true if the item is null?
// Semantically, transferring/dropping nothing always works
// This lets us tidy up other pieces of code by not having to typecheck everything.
// However, if you do pass in an invalid object instead of null, the procs will fail or pass
// depending on needed behavior.
// Use the helpers when you can, it's easier for everyone and makes replacing behaviors later easier.

// This logic is actually **stricter** than the previous logic, which was "if item doesn't exist, it always works"

/**
 * drops an item to ground
 *
 * semantically returns true if the thing is no longer in our inventory after our call, whether or not we dropped it
 * if you require better checks, check if something is in inventory first.
 *
 * if the item is null, this returns true
 * if an item is not in us, this returns true
 */
/mob/proc/drop_item_to_ground(obj/item/I, flags, mob/user = src)
	// destroyed IS allowed to call these procs
	if(I && QDELETED(I) && !QDESTROYING(I))
		to_chat(user, SPAN_DANGER("A deleted item [I] was used in drop_item_to_ground(). Report the entire line to coders. Debugging information: [I] ([REF(I)]) flags [flags] user [user]"))
		to_chat(user, SPAN_DANGER("Drop item to ground will now proceed, ignoring the bugged state. Errors may ensue."))
	else if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, drop_location(), user)

/**
 * transfers an item somewhere
 * newloc MUST EXIST, use transfer_item_to_nullspace otherwise
 *
 * semantically returns true if we transferred something from our inventory to newloc in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_loc(obj/item/I, newloc, flags, mob/user)
	if(!I)
		return TRUE
	ASSERT(newloc)
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, newloc, user)

/**
 * transfers an item into nullspace
 *
 * semantically returns true if we transferred something from our inventory to null in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_nullspace(obj/item/I, flags, mob/user)
	if(!I)
		return TRUE
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, null, user)

/**
 * removes an item from inventory. does NOT move it.
 * item MUST be qdel'd or moved after this if it returns TRUE!
 *
 * semantically returns true if the passed item is no longer in our inventory after the call
 *
 * if the item is null, ths returns true
 * if an item is not in us, this returns true
 */
/mob/proc/temporarily_remove_from_inventory(obj/item/I, flags, mob/user)
	if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, flags | INV_OP_DIRECTLY_DROPPING, FALSE, user)

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
		_unequip_held(I, TRUE)
		I.unequipped(src, SLOT_ID_HANDS, flags)
		old = SLOT_ID_HANDS
	else
		if(!I.worn_slot)
			stack_trace("tried to unequip an item without current equipped slot.")
			I.worn_slot = _slot_by_item(I)
		if(!can_unequip(I, I.worn_slot, flags, user))
			return FALSE
		old = I.worn_slot
		_unequip_slot(I.worn_slot, flags)
		I.unequipped(src, I.worn_slot, flags)
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

	update_action_buttons()

/mob/proc/handle_item_denesting(obj/item/I, old_slot, flags, mob/user)
	// if the item was inside something,
	if(I.worn_inside)
		var/obj/item/over = I.worn_over
		var/obj/item/inside = I.worn_inside
		// if we were inside something we WEREN'T the top level item
		// collapse the links
		inside.worn_over = over
		if(over)
			over.worn_inside = inside
		I.worn_over = null
		I.worn_inside = null
		// call procs to inform things
		inside.equip_on_worn_over_remove(src, old_slot, user, I, flags)
		if(over)
			I.equip_on_worn_over_remove(src, old_slot, user, over, flags)

		// now we're free to forcemove later
	// if the item wasn't but was worn over something, there's more complicated methods required
	else if(I.worn_over)
		var/obj/item/over = I.worn_over
		I.worn_over = null
		I.equip_on_worn_over_remove(src, old_slot, user, I.worn_over, flags)
		// I is free to be forcemoved now, but the old object needs to be put back on
		over.worn_hook_suppressed = TRUE
		over.forceMove(src)
		over.worn_hook_suppressed = FALSE
		// put it back in the slot
		_equip_slot(over, old_slot, flags)
		// put it back on the screen
		over.hud_layerise()
		position_hud_item(over, old_slot)
		client?.screen |= over

/**
 * checks if we can unequip an item
 *
 * Preconditions: The item is either equipped already, or isn't equipped.
 *
 * @return TRUE/FALSE
 *
 * @params
 * - I - item
 * - slot - slot we're unequipping from - can be null
 * - flags - inventory operation hint bitfield, see defines
 * - user - stripper - can be null
 */
/mob/proc/can_unequip(obj/item/I, slot, flags, mob/user = src)
	// destroyed IS allowed to call these procs
	if(I && QDELETED(I) && !QDESTROYING(I))
		to_chat(user, SPAN_DANGER("A deleted [I] was checked in can_unequip(). Report this entire line to coders immediately. Debug data: [I] ([REF(I)]) slot [slot] flags [flags] user [user]"))
		to_chat(user, SPAN_DANGER("can_unequip will return TRUE to allow you to drop the item, but expect potential glitches!"))
		return TRUE

	if(!slot)
		slot = slot_by_item(I)

	if(!(flags & INV_OP_FORCE) && HAS_TRAIT(I, TRAIT_NODROP))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("[I] is stuck to your hand!"))
		return FALSE

	var/blocked_by
	if((blocked_by = inventory_slot_reachability_conflict(I, slot, user)) && !(flags & (INV_OP_FORCE | INV_OP_IGNORE_REACHABILITY)))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("\the [blocked_by] is in the way!"))
		return FALSE

	// lastly, check item's opinion
	if(!I.can_unequip(src, slot, user, flags))
		return FALSE

	return TRUE

/**
 * equips an item to a slot if possible
 *
 * @params
 * - I - item
 * - slot - the slot
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_if_possible(obj/item/I, slot, flags, mob/user)
	return _equip_item(I, flags, slot, user)

/**
 * equips an item to a slot if possible
 * item is deleted on failure
 *
 * @params
 * - I - item
 * - slot - the slot
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_or_del(obj/item/I, slot, flags, mob/user)
	. = equip_to_slot_if_possible(I, slot, flags, user)
	if(!.)
		qdel(I)
/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 * this proc is silent for the sub-calls by default to prevent spam.
 *
 * @params
 * - I - item
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_appropriate_slot(obj/item/I, flags, mob/user)
	for(var/slot in GLOB.slot_equipment_priority)
		if(equip_to_slot_if_possible(I, slot, flags | INV_OP_SUPPRESS_WARNING, user))
			return TRUE
	if(!(flags & INV_OP_SUPPRESS_WARNING))
		to_chat(user, user == src? SPAN_WARNING("You can't find somewhere to equip [I] to!") : SPAN_WARNING("[src] has nowhere to equip [I] to!"))
	return FALSE

/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 *
 * item is deleted on failure.
 *
 * @params
 * - I - item
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */

/mob/proc/equip_to_appropriate_slot_or_del(obj/item/I, flags, mob/user)
	if(!equip_to_appropriate_slot(I, flags, user))
		qdel(I)

/**
 * forcefully equips an item to a slot
 * kicks out conflicting items if possible
 *
 * This CAN fail, so listen to return value
 * Why? YOU MIGHT EQUIP TO A MOB WITHOUT A CERTAIN SLOT!
 *
 * @params
 * - I - item
 * - slot - slot to equip to
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/force_equip_to_slot(obj/item/I, slot, flags, mob/user)
	return _equip_item(I, flags, slot, user)

/**
 * forcefully equips an item to a slot
 * kicks out conflicting items if possible
 * if still failing, item is deleted
 *
 * this can fail, so listen to return values.
 * @params
 * - I - item
 * - slot - slot to equip to
 * - flags - inventory operation hint bitfield, see defines
 * - user - the user doing the action, if any. defaults to ourselves.
 *
 * @return TRUE/FALSE
 */
/mob/proc/force_equip_to_slot_or_del(obj/item/I, slot, flags, mob/user)
	if(!force_equip_to_slot(I, slot, flags, user))
		qdel(I)
		return FALSE
	return TRUE

/**
 * checks if we can equip an item to a slot
 *
 * Preconditions: The item will either be equipped on us already, or not yet equipped.
 *
 * @return TRUE/FALSE
 *
 * @params
 * - I - item
 * - slot - slot ID
 * - flags - inventory operation hint bitfield, see defines
 * - user - user trying to equip that thing to us there - can be null
 * - denest_to - the old slot we're leaving if called from handle_item_reequip. **extremely** snowflakey
 *
 * todo: refactor nesting to not require this shit
 */
/mob/proc/can_equip(obj/item/I, slot, flags, mob/user, denest_to)
	// let's NOT.
	if(I && QDELETED(I))
		to_chat(user, SPAN_DANGER("A deleted [I] was checked in can_equip(). Report this entire line to coders immediately. Debug data: [I] ([REF(I)]) slot [slot] flags [flags] user [user]"))
		to_chat(user, SPAN_DANGER("can_equip will now attempt to prevent the deleted item from being equipped. There should be no glitches."))
		return FALSE

	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
	var/self_equip = user == src
	if(!slot_meta)
		. = FALSE
		CRASH("Failed to resolve to slot datm.")

	if(slot_meta.inventory_slot_flags & INV_SLOT_IS_ABSTRACT)
		// special handling: make educated guess, defaulting to yes
		switch(slot_meta.type)
			if(/datum/inventory_slot_meta/abstract/hand/left)
				return (flags & INV_OP_FORCE) || !get_left_held_item()
			if(/datum/inventory_slot_meta/abstract/hand/right)
				return (flags & INV_OP_FORCE) || !get_right_held_item()
			if(/datum/inventory_slot_meta/abstract/put_in_backpack)
				var/obj/item/storage/S = item_by_slot(SLOT_ID_BACK)
				if(!istype(S))
					return FALSE
				return S.can_be_inserted(I, TRUE)
			if(/datum/inventory_slot_meta/abstract/put_in_belt)
				var/obj/item/storage/S = item_by_slot(SLOT_ID_BACK)
				if(!istype(S))
					return FALSE
				return S.can_be_inserted(I, TRUE)
			if(/datum/inventory_slot_meta/abstract/put_in_hands)
				return (flags & INV_OP_FORCE) || !hands_full()
		return TRUE

	if(!inventory_slot_bodypart_check(I, slot, user, flags) && !(flags & INV_OP_FORCE))
		return FALSE

	var/conflict_result = inventory_slot_conflict_check(I, slot)
	var/obj/item/to_wear_over

	if((flags & INV_OP_IS_FINAL_CHECK) && conflict_result && (slot != SLOT_ID_HANDS))
		// try to fit over
		var/obj/item/conflicting = item_by_slot(slot)
		if(conflicting)
			// there's something there
			var/can_fit_over = I.equip_worn_over_check(src, slot, user, conflicting, flags)
			if(can_fit_over)
				conflict_result = CAN_EQUIP_SLOT_CONFLICT_NONE
				to_wear_over = conflicting
				// ! DANGER: snowflake time
				// take it out of the slot
				_unequip_slot(slot, flags | INV_OP_NO_LOGIC | INV_OP_NO_UPDATE_ICONS)
				// recheck
				conflict_result = inventory_slot_conflict_check(I, slot)
				// put it back in incase something else breaks
				_equip_slot(conflicting, slot, flags | INV_OP_NO_LOGIC | INV_OP_NO_UPDATE_ICONS)

	switch(conflict_result)
		if(CAN_EQUIP_SLOT_CONFLICT_HARD)
			if(!(flags & INV_OP_SUPPRESS_WARNING))
				to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] are already [slot_meta.display_plural? "holding too many things" : "wearing something"] [slot_meta.display_preposition] [self_equip? "your" : "their"] [slot_meta.display_name]."))
			return FALSE
		if(CAN_EQUIP_SLOT_CONFLICT_SOFT)
			if(!(flags & INV_OP_FORCE))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] are already [slot_meta.display_plural? "holding too many things" : "wearing something"] [slot_meta.display_preposition] [self_equip? "your" : "their"] [slot_meta.display_name]."))
				return FALSE

	if(!inventory_slot_semantic_conflict(I, slot, user) && !(flags & INV_OP_FORCE))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("[I] doesn't fit there."))
		return FALSE

	var/blocked_by

	if((blocked_by = inventory_slot_reachability_conflict(I, slot, user)) && !(flags & (INV_OP_FORCE | INV_OP_IGNORE_REACHABILITY)))
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(user, SPAN_WARNING("\the [blocked_by] is in the way!"))
		return FALSE

	// lastly, check item's opinion
	if(!I.can_equip(src, slot, user, flags))
		return FALSE

	// we're the final check - side effects ARE allowed
	if((flags & INV_OP_IS_FINAL_CHECK) && to_wear_over)
		//! Note: this means that can_unequip is NOT called for to wear over.
		//! This is intentional, but very, very sonwflakey.
		to_wear_over.worn_inside = I
		// setting worn inside first disallows equip/unequip from triggering
		to_wear_over.forceMove(I)
		// check we don't have something already (wtf)
		if(I.worn_over)
			handle_item_denesting(I, denest_to, flags, user)
		// set the other way around
		I.worn_over = to_wear_over
		// tell it we're inserting the old item
		I.equip_on_worn_over_insert(src, slot, user, to_wear_over, flags)
		// take the old item off our screen
		client?.screen -= to_wear_over
		to_wear_over.screen_loc = null
		to_wear_over.hud_unlayerise()
		// we don't call slot re-equips here because the equip proc does this for us

	return TRUE

/**
 * checks if we are missing the bodypart for a slot
 * return FALSE if we are missing, or TRUE if we're not
 *
 * this proc should give the feedback of what's missing!
 */
/mob/proc/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, flags)
	return TRUE

/**
 * drop items if a bodypart is missing
 */
/mob/proc/reconsider_inventory_slot_bodypart(bodypart)
	// todo: this and the above function should be on the slot datums.
	var/list/obj/item/affected
	switch(bodypart)
		if(BP_HEAD)
			affected = items_by_slot(
				SLOT_ID_HEAD,
				SLOT_ID_LEFT_EAR,
				SLOT_ID_RIGHT_EAR,
				SLOT_ID_MASK,
				SLOT_ID_GLASSES
			)
		if(BP_GROIN, BP_TORSO)
			affected = items_by_slot(
				SLOT_ID_BACK,
				SLOT_ID_BELT,
				SLOT_ID_SUIT,
				SLOT_ID_SUIT_STORAGE,
				SLOT_ID_RIGHT_POCKET,
				SLOT_ID_LEFT_POCKET,
				SLOT_ID_UNIFORM
			)
		if(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND)
			affected = items_by_slot(
				SLOT_ID_HANDCUFFED,
				SLOT_ID_GLOVES
			)
		if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
			affected = items_by_slot(
				SLOT_ID_LEGCUFFED,
				SLOT_ID_SHOES
			)
	if(!affected)
		return
	else if(!islist(affected))
		affected = list(affected)
	for(var/obj/item/I as anything in affected)
		if(!inventory_slot_bodypart_check(I, I.worn_slot, null, INV_OP_SILENT))
			drop_item_to_ground(I)

/**
 * checks for slot conflict
 */
/mob/proc/inventory_slot_conflict_check(obj/item/I, slot)
	if(_item_by_slot(slot))
		return CAN_EQUIP_SLOT_CONFLICT_HARD
	switch(slot)
		if(SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR)
			if(I.slot_flags & SLOT_TWOEARS)
				if(_item_by_slot(SLOT_ID_LEFT_EAR) || _item_by_slot(SLOT_ID_RIGHT_EAR))
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
	return CAN_EQUIP_SLOT_CONFLICT_NONE

/**
 * checks if you can reach a slot
 * return null or the first item blocking
 */
/mob/proc/inventory_slot_reachability_conflict(obj/item/I, slot, mob/user)
	return null

/**
 * semantic check - should this item fit here? slot flag checks/etc should go in here.
 *
 * return TRUE if conflicting, otherwise FALSE
 */
/mob/proc/inventory_slot_semantic_conflict(obj/item/I, datum/inventory_slot_meta/slot, mob/user)
	. = FALSE
	slot = resolve_inventory_slot_meta(slot)
	return slot._equip_check(I, src, user)

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
	PROTECTED_PROC(TRUE)

	if(!I)		// how tf would we put on "null"?
		return FALSE

	// resolve slot
	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
	if(slot_meta.inventory_slot_flags & INV_SLOT_IS_ABSTRACT)
		// if it's abstract, we go there directly - do not use can_equip as that will just guess.
		return handle_abstract_slot_insertion(I, slot, flags)

	var/old_slot = slot_by_item(I)

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

	update_action_buttons()

	if(I.zoom)
		I.zoom()

	return TRUE

/**
 * checks if we already have something in our inventory
 * if so, this will try to shift the slots over, calling equipped/unequipped automatically
 *
 * INV_OP_FORCE will allow ignoring can unequip.
 *
 * return true/false based on if we succeeded
 */
/mob/proc/_handle_item_reequip(obj/item/I, slot, old_slot, flags, mob/user = src)
	ASSERT(slot)
	if(!old_slot)
		// DO NOT USE _slot_by_item - at this point, the item has already been var-set into the new slot!
		// slot_by_item however uses cached values still!
		old_slot = slot_by_item(I)
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
			_unequip_held(I, flags)
		else
			_unequip_slot(old_slot, flags)
		I.unequipped(src, old_slot, flags)
		// sigh
		handle_item_denesting(I, old_slot, flags, user)
		// TODO: HANDLE DELETIONS ON EQUIPPED PROPERLY, INCLUDING ON HANDS
		// ? we don't do this on hands, hand procs do it
		// _equip_slot(I, slot, update_icons)
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
			_unequip_held(I, flags)
		else
			_unequip_slot(old_slot, flags)
		I.unequipped(src, old_slot, flags)
		// TODO: HANDLE DELETIONS ON EQUIPPED PROPERLY
		// sigh
		_equip_slot(I, slot, flags)
		I.equipped(src, slot, flags)
		log_inventory("[key_name(src)] moved [I] from [old_slot] to [slot].")
		return TRUE

/**
 * handles removing an item from our hud
 *
 * some things call us from outside inventory code. this is shitcode and shouldn't be propageted.
 */
/mob/proc/_handle_inventory_hud_remove(obj/item/I)
	if(client)
		client.screen -= I
	I.screen_loc = null

/**
 * handles adding an item or updating an item to our hud
 */
/mob/proc/_handle_inventory_hud_update(obj/item/I, slot)
	var/datum/inventory_slot_meta/meta = resolve_inventory_slot_meta(slot)
	I.screen_loc = meta.hud_position
	if(client)
		client.screen |= I

/**
 * get all equipped items
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/get_equipped_items(include_inhands, include_restraints)
	return get_held_items() + _get_all_slots(include_restraints)

/**
 * wipe our inventory
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/delete_inventory(include_inhands = TRUE, include_restraints = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		qdel(I)

/**
 * drops everything in our inventory
 *
 * @params
 * - include_inhands - include held items too?
 * - include_restraints - include restraints too?
 * - force - ignore nodrop and all that
 */
/mob/proc/drop_inventory(include_inhands = TRUE, include_restraints = TRUE, force = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		drop_item_to_ground(I, INV_OP_SILENT | INV_OP_FLUFFLESS | (force? INV_OP_FORCE : NONE))

	// todo: handle what happens if dropping something requires a logic thing
	// e.g. dropping jumpsuit makes it impossible to transfer a belt since it
	// de-equipped from the jumpsuit

/mob/proc/transfer_inventory_to_loc(atom/newLoc, include_inhands = TRUE, include_restraints = TRUE, force = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		transfer_item_to_loc(I, newLoc, INV_OP_SILENT | INV_OP_FLUFFLESS | (force? INV_OP_FORCE : NONE))
	// todo: handle what happens if dropping something requires a logic thing
	// e.g. dropping jumpsuit makes it impossible to transfer a belt since it
	// de-equipped from the jumpsuit

/**
 * gets the primary item in a slot
 * null if not in inventory. inhands don't count as inventory here, use held item procs.
 */
/mob/proc/item_by_slot(slot)
	return _item_by_slot(slot)	// why the needless indirection? so people don't override this for slots!

/**
 * gets the primary item and nested items (e.g. gloves, magboots, accessories) in a slot
 * null if not in inventory, otherwise list
 * inhands do not count as inventory
 */
/mob/proc/items_by_slot(slot)
	var/obj/item/I = _item_by_slot(slot)
	if(!I)
		return list()
	I = I._inv_return_attached()
	return islist(I)? I : list(I)

/**
 * returns if we have something equipped - the slot if it is, null if not
 *
 * SLOT_ID_HANDS if in hands
 */
/mob/proc/is_in_inventory(obj/item/I)
	return (I?.worn_mob() == src) && I.worn_slot
	// we use entirely cached vars for speed.
	// if this returns bad data well fuck you, don't break equipped()/unequipped().

/**
 * returns if an item is in inventory (equipped) rather than hands
 */
/mob/proc/is_wearing(obj/item/I)
	var/slot = is_in_inventory(I)
	return slot && (slot != SLOT_ID_HANDS)

/**
 * get slot of item if it's equipped.
 * null if not in inventory. SLOT_HANDS if held.
 */
/mob/proc/slot_by_item(obj/item/I)
	return is_in_inventory(I) || null		// short circuited to that too
									// if equipped/unequipped didn't set worn_slot well jokes on you lmfao

/mob/proc/_equip_slot(obj/item/I, slot, flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = _set_inv_slot(slot, I, flags) != INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_unequip_slot(slot, flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = _set_inv_slot(slot, null, flags) != INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_unequip_held(obj/item/I, flags)
	return

/mob/proc/has_slot(id)
	SHOULD_NOT_OVERRIDE(TRUE)
	return _item_by_slot(id) != INVENTORY_SLOT_DOES_NOT_EXIST

// todo: both of these below procs needs optimization for when we need the datum anyways, to avoid two lookups

/mob/proc/semantically_has_slot(id)
	return has_slot(id) && _semantic_slot_id_check(id)

/mob/proc/get_inventory_slot_ids(semantic, sorted)
	// get all
	if(sorted)
		. = list()
		for(var/id as anything in GLOB.inventory_slot_meta)
			if(!semantically_has_slot(id))
				continue
			. += id
		return
	else
		. = _get_inventory_slot_ids()
	// check if we should filter
	if(!semantic)
		return
	. = _get_inventory_slot_ids()
	for(var/id in .)
		if(!_semantic_slot_id_check(id))
			. -= id

/**
 * THESE PROCS MUST BE OVERRIDDEN FOR NEW SLOTS ON MOBS
 * yes, i managed to shove all basic behaviors that needed overriding into 5-6 procs
 * you're
 * welcome.
 *
 * These are UNSAFE PROCS.
 *
 * oh and can_equip_x* might need overriding for complex mobs like humans but frankly
 * sue me, there's no better way right now.
 */

/**
 * sets a slot to icon or null
 *
 * some behaviors may be included other than update icons
 * even update icons is unpreferred but we're stuck with this for now.
 *
 * todo: logic should be moved out of the proc, but where?
 *
 * @params
 * slot - slot to set
 * I - item or null
 * update_icons - update icons immediately?
 * logic - apply logic like dropping stuff from pockets when unequippiing a jumpsuit imemdiately?
 */
/mob/proc/_set_inv_slot(slot, obj/item/I, flags)
	PROTECTED_PROC(TRUE)
	. = INVENTORY_SLOT_DOES_NOT_EXIST
	CRASH("Attempting to set inv slot of [slot] to [I] went to base /mob. You probably had someone assigning to a nonexistant slot!")

/**
 * ""expensive"" proc that scans for the real slot of an item
 * usually used when safety checks detect something is amiss
 */
/mob/proc/_slot_by_item(obj/item/I)
	PROTECTED_PROC(TRUE)

/**
 * doubles as slot detection
 * returns -1 if no slot
 * YES, MAGIC VALUE BUT SOLE USER IS 20 LINES ABOVE, SUE ME.
 */
/mob/proc/_item_by_slot(slot)
	PROTECTED_PROC(TRUE)
	return INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_get_all_slots(include_restraints)
	PROTECTED_PROC(TRUE)
	return list()

/**
 * return all slot ids we implement
 */
/mob/proc/_get_inventory_slot_ids()
	PROTECTED_PROC(TRUE)
	return list()

/**
 * override this if you need to make a slot not semantically exist
 * useful for other species that don't have a slot so you don't have jumpsuit requirements apply
 */
/mob/proc/_semantic_slot_id_check(id)
	PROTECTED_PROC(TRUE)
	return TRUE
