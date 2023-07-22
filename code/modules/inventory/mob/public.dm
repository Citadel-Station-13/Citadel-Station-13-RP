//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Checks / Enumerations *//

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
	I = I.inv_slot_attached()
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

/**
 * get all equipped items
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/get_equipped_items(include_inhands, include_restraints)
	return get_held_items() + _get_all_slots(include_restraints)

// todo: below procs needs optimization for when we need the datum anyways, to avoid two lookups

/mob/proc/has_slot(id)
	SHOULD_NOT_OVERRIDE(TRUE)
	return _item_by_slot(id) != INVENTORY_SLOT_DOES_NOT_EXIST

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

//* Equipping *//

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
	return _equip_item(I, flags | INV_OP_FATAL, slot, user)

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

//* Dropping *//

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

	if(!(flags & INV_OP_FORCE) && HAS_TRAIT(I, TRAIT_ITEM_NODROP))
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
 * wipe our inventory
 *
 * @params
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 */
/mob/proc/delete_inventory(include_inhands = TRUE, include_restraints = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		qdel(I)
