/**
 * handles the insertion
 * item can be moved or not moved before calling
 *
 * slot must be a typepath
 *
 * @return true/false based on if it worked
 */
/mob/proc/handle_abstract_slot_insertion(obj/item/I, slot, force, silent)
	if(!ispath(slot, /datum/inventory_slot_meta/abstract))
		slot = resolve_inventory_slot_meta(slot)?.type
		if(!ispath(slot, /datum/inventory_slot_meta/abstract))
			stack_trace("invalid slot: [slot]")
		else
			stack_trace("attempted usage of slot id in abstract insertion converted successfully")
	. = FALSE
	switch(slot)
		if(/datum/inventory_slot_meta/abstract/left_hand)
			return put_in_left_hand(I, force)
		if(/datum/inventory_slot_meta/abstract/right_hand)
			return put_in_right_hand(I, force)
		if(/datum/inventory_slot_meta/abstract/put_in_belt)
			var/obj/item/storage/S = item_by_slot(SLOT_ID_BELT)
			return istype(S) && S.try_insert(I, src, silent, force)
		if(/datum/inventory_slot_meta/abstract/put_in_backpack)
			var/obj/item/storage/S = item_by_slot(SLOT_ID_BACK)
			return istype(S) && S.try_insert(I, src, silent, force)
		if(/datum/inventory_slot_meta/abstract/put_in_hands)
			return put_in_hands(I, force = force)
		if(/datum/inventory_slot_meta/abstract/put_in_storage, /datum/inventory_slot_meta/abstract/put_in_storage_try_active)
			if(slot == /datum/inventory_slot_meta/abstract/put_in_storage_try_active)
				if(s_active && Adjacent(s_active) && s_active.try_insert(I, src, silent, FALSE))
					return TRUE
			for(var/obj/item/storage/S in get_equipped_items_in_slots(list(
				SLOT_ID_BELT,
				SLOT_ID_BACK,
				SLOT_ID_UNIFORM,
				SLOT_ID_SUIT,
				SLOT_ID_LEFT_POCKET,
				SLOT_ID_RIGHT_POCKET
			)) + get_held_items())
				if(S.try_insert(I, src, silent, force))
					return TRUE
			return FALSE
		if(/datum/inventory_slot_meta/abstract/attach_as_accessory)
			for(var/obj/item/clothing/C in get_equipped_items())
				if(C.attempt_attach_accessory(I))
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
/mob/proc/drop_item_to_ground(obj/item/I, force)
	if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, force, drop_location())

/**
 * transfers an item somewhere
 * newloc MUST EXIST, use transfer_item_to_nullspace otherwise
 *
 * semantically returns true if we transferred something from our inventory to newloc in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_loc(obj/item/I, newloc, force)
	if(!I)
		return TRUE
	ASSERT(newloc)
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, force, newloc)

/**
 * transfers an item into nullspace
 *
 * semantically returns true if we transferred something from our inventory to null in the call
 *
 * if the item is null, this returns true
 * if an item is not in us, this crashes
 */
/mob/proc/transfer_item_to_nullspace(obj/item/I, force)
	if(!I)
		return TRUE
	if(!is_in_inventory(I))
		return FALSE
	return _unequip_item(I, force, null)

/**
 * removes an item from inventory. does NOT move it.
 * item MUST be qdel'd or moved after this if it returns TRUE!
 *
 * semantically returns true if the passed item is no longer in our inventory after the call
 *
 * if the item is null, ths returns true
 * if an item is not in us, this returns true
 */
/mob/proc/temporarily_remove_from_inventory(obj/item/I, force)
	if(!is_in_inventory(I))
		return TRUE
	return _unequip_item(I, force, FALSE)

/**
 * handles internal logic of unequipping an item
 *
 * @params
 * - I - item
 * - force - ignore nodrop/other restrictions
 * - newloc - where to transfer to. null for nullspace, FALSE for don't transfer
 * - user - can be null - person doing the removal
 * - swapping - swapping clothes, don't drop pockets/whatnot
 * - silent - don't display warnings
 * - ignore_fluff - ignore stuff like reachability checks
 * - update_icons - update mob icons?
 * - disallow_delay - fail if there'd be an equip delay
 *
 * @return TRUE/FALSE for success
 */
/mob/proc/_unequip_item(obj/item/I, force, newloc, mob/user = src, disallow_delay, ignore_fluff, silent, update_icons = TRUE, swapping)
	PROTECTED_PROC(TRUE)
	if(!I)
		return TRUE

	var/hand = get_held_index(I)
	var/old
	if(hand)
		if(!can_unequip(I, SLOT_ID_HANDS, user, force, disallow_delay, ignore_fluff, silent))
			return FALSE
		_unequip_held(I, TRUE)
		old = SLOT_ID_HANDS
	else
		if(!I.current_equipped_slot)
			stack_trace("tried to unequip an item without current equipped slot.")
			I.current_equipped_slot = _slot_by_item(I)
		if(!can_unequip(I, I.current_equipped_slot, user, force, disallow_delay, ignore_fluff, silent))
			return FALSE
		old = I.current_equipped_slot
		_unequip_slot(I.current_equipped_slot, TRUE)
		I.unequipped(src, I.current_equipped_slot)

	. = TRUE

	if(I)
		// todo: better rendering that takes observers into account
		if(client)
			client.screen -= I
			I.screen_loc = null
		if(!(I.flags & DROPDEL))
			if(newloc == null)
				I.moveToNullspace()
			else if(newloc != FALSE)
				I.forceMove(newloc)
		if(I.dropped(src) == ITEM_RELOCATED_BY_DROPPED)
			. = FALSE
		if(QDELETED(I))
			. = FALSE

	log_inventory("[key_name(src)] unequipped [I] from [old].")

	update_action_buttons()

/**
 * checks if we can unequip an item
 *
 * @return TRUE/FALSE
 *
 * @params
 * - I - item
 * - slot - slot we're unequipping from - can be null
 * - user - stripper - can be null
 * - force - ignore nodrops, etc
 * - dislalow_delay - fail if we'd need to do a do_after, instead of sleeping
 * - ignore_fluff - ignore equip delay, item zone checks, etc
 * - silent - do not play warning messages
 */
/mob/proc/can_unequip(obj/item/I, slot, mob/user, force, disallow_delay, ignore_fluff, silent)
	if(!force && HAS_TRAIT(I, TRAIT_NODROP))
		return FALSE

	var/blocked_by
	if((blocked_by = inventory_slot_reachability_conflict(I, slot, user)) && !force)
		if(!silent)
			to_chat(user, SPAN_WARNING("\the [blocked_by] is in the way!"))
		return FALSE

	// lastly, check item's opinion
	if(!I.can_unequip(src, user, slot, silent, disallow_delay, ignore_fluff))
		return FALSE

	return TRUE

/**
 * equips an item to a slot if possible
 *
 * @params
 * - I - item
 * - slot - the slot
 * - silent - don't show this mob warnings when failing
 * - user - the user doing the action, if any. defaults to ourselves.
 * - disallow_delay - fail if we have to sleep/do_after
 * - ignore_fluff - ignore silly roleplay fluff like not being able to reach/self equip delays
 * - update_icons - redraw slot icons?
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_if_possible(obj/item/I, slot, mob/user, silent, disallow_delay, ignore_fluff, update_icons)
	return _equip_item(I, FALSE, slot, user, silent, disallow_delay, ignore_fluff, update_icons)

/**
 * equips an item to a slot if possible
 * item is deleted on failure
 *
 * @params
 * - I - item
 * - slot - the slot
 * - silent - don't show this mob warnings when failing
 * - user - the user doing the action, if any. defaults to ourselves.
 * - disallow_delay - fail if we have to sleep/do_after
 * - ignore_fluff - ignore silly roleplay fluff like not being able to reach/self equip delays
 * - update_icons - redraw slot icons?
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_slot_or_del(obj/item/I, slot, mob/user, silent, update_icons, ignore_fluff)
	. = equip_to_slot_if_possible(I, slot, user, silent, update_icons, ignore_fluff)
	if(!.)
		qdel(I)
/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 * this proc is silent for the sub-calls by default to prevent spam.
 *
 * @params
 * - I - item
 * - user - the user doing the action, if any. defaults to ourselves.
 * - silent - don't show this mob warnings when failing
 * - disallow_delay - fail if we have to sleep/do_after
 * - ignore_fluff - ignore silly roleplay fluff like not being able to reach/self equip delays
 * - update_icons - redraw slot icons?
 *
 * @return TRUE/FALSE
 */
/mob/proc/equip_to_appropriate_slot(obj/item/I, mob/user, silent, disallow_delay, ignore_fluff, update_icons)
	for(var/slot in GLOB.slot_equipment_priority)
		if(equip_to_slot_if_possible(I, slot, user, TRUE, ignore_fluff, update_icons))
			return TRUE
	if(!silent)
		to_chat(user, user == src? SPAN_WARNING("You can't find somewhere to equip [I] to!") : SPAN_WARNING("[src] has nowhere to equip [I] to!"))
	return FALSE

/**
 * automatically equips to the best inventory (non storage!) slot we can find for an item, if possible
 *
 * item is deleted on failure.
 *
 * @params
 * - I - item
 * - silent - don't show this mob warnings when failing
 * - disallow_delay - fail if we have to sleep/do_after
 * - ignore_fluff - ignore silly roleplay fluff like not being able to reach/self equip delays
 * - update_icons - redraw slot icons?
 *
 * @return TRUE/FALSE
 */

/mob/proc/equip_to_appropriate_slot_or_del(obj/item/I, silent, disallow_delay, ignore_fluff, update_icons)
	if(!equip_to_appropriate_slot(I, silent, disallow_delay, ignore_fluff, update_icons))
		qdel(I)

/**
 * forcefully equips an item to a slot
 * kicks out conflicting items if possible
 *
 * This CAN fail, so listen to return value
 * Why? YOU MIGHT EQUIP TO A MOB WITHOUT A CERTAIN SLOT!
 *
 * @return TRUE/FALSE
 */
/mob/proc/force_equip_to_slot(obj/item/I, slot, silent, mob/user, update_icons)
	return _equip_item(I, TRUE, slot, user, silent, null, null, update_icons)

/mob/proc/force_equip_to_slot_or_del(obj/item/I, slot, silent, mob/user, update_icons)
	if(!force_equip_to_slot(I, slot, silent, user, update_icons))
		qdel(I)
		return FALSE
	return TRUE

/**
 * checks if we can equip an item to a slot
 *
 * @return TRUE/FALSE
 *
 * @params
 * - I - item
 * - slot - slot ID
 * - user - user trying to equip that thing to us there - can be null
 * - force - we can forcefully dislodge an item if needed, also ignore nodrops and "fluff" blockers.
 * - disallow_delay - fail if we'd need to sleep
 * - ignore_fluff - ignore self equip delay, item zone checks, etc. implied by force.
 * - silent - don't display a warning message if we find an error
 */
/mob/proc/can_equip(obj/item/I, slot, mob/user, force, disallow_delay, ignore_fluff, silent)
	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
	var/self_equip = user == src
	if(!slot_meta)
		. = FALSE
		CRASH("Failed to resolve to slot datm.")

	if(slot_meta.is_abstract)
		// special handling: make educated guess, defaulting to yes
		switch(slot_meta.type)
			if(/datum/inventory_slot_meta/abstract/left_hand)
				return force || !get_left_held_item()
			if(/datum/inventory_slot_meta/abstract/right_hand)
				return force || !get_right_held_item()
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
				return force || !hands_full()
		return TRUE

	var/missing_bodypart

	if(!inventory_slot_bodypart_check(I, slot, user, silent) && !force)
		return FALSE

	switch(inventory_slot_conflict_check(I, slot))
		if(CAN_EQUIP_SLOT_CONFLICT_HARD)
			if(!silent)
				to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] are already [slot_meta.display_plural? "holding too many things" : "wearing something"] [slot_meta.display_preposition] [self_equip? "your" : "their"] [slot_meta.display_name]."))
			return FALSE
		if(CAN_EQUIP_SLOT_CONFLICT_SOFT)
			if(!force)
				if(!silent)
					to_chat(user, SPAN_WARNING("[self_equip? "You" : "They"] are already [slot_meta.display_plural? "holding too many things" : "wearing something"] [slot_meta.display_preposition] [self_equip? "your" : "their"] [slot_meta.display_name]."))
				return FALSE

	if(!inventory_slot_semantic_conflict(I, slot, user) && !force)
		if(!silent)
			to_chat(user, SPAN_WARNING("[I] doesn't fit there."))
		return FALSE

	var/blocked_by

	if((blocked_by = inventory_slot_reachability_conflict(I, slot, user)) && !ignore_fluff && !force)
		if(!silent)
			to_chat(user, SPAN_WARNING("\the [blocked_by] is in the way!"))
		return FALSE

	// lastly, check item's opinion
	if(!I.can_equip(src, user, slot, silent, disallow_delay, ignore_fluff))
		return FALSE

	return TRUE

/**
 * checks if we are missing the bodypart for a slot
 * return FALSE if we are missing, or TRUE if we're not
 *
 * this proc should give the feedback of what's missing!
 */
/mob/proc/inventory_slot_bodypart_check(obj/item/I, slot, mob/user, silent)
	return TRUE

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
 * - force - knock out current items, ignore softer checks
 * - slot - slot to equip it to
 * - user - user trying to put it on us
 * - silent - suppress error messages going to the user
 * - disallow_delay - fail if we need to do_after or similar
 * - ignore_fluff - ignore stuff like reachability checks. implied by force.
 * - update_icons - update mob icons
 *
 * @return TRUE/FALSE on success
 */
/mob/proc/_equip_item(obj/item/I, force, slot, mob/user = src, silent, disallow_delay, ignore_fluff, update_icons = TRUE)
	PROTECTED_PROC(TRUE)

	if(!I)		// how tf would we put on "null"?
		return FALSE

	// resolve slot
	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
	if(slot_meta.is_abstract)
		// if it's abstract, we go there directly - do not use can_equip as that will just guess.
		return handle_abstract_slot_insertion(I, slot, force, silent)

	if(!can_equip(I, slot, user, force, disallow_delay, ignore_fluff, silent))
		return FALSE

	var/old_slot = slot_by_item(I)

	if(old_slot)
		. = _handle_item_reequip(I, slot, old_slot, force)
		if(!.)
			return

		log_inventory("[key_name(src)] moved [I] from [old_slot] to [slot].")
	else
		I.forceMove(src)
		I.pickup(src, FALSE, silent)
		I.equipped(src, slot, FALSE, silent)

		log_inventory("[key_name(src)] equipped [I] to [slot].")

	update_action_buttons()

	if(I.zoom)
		I.zoom()

	return TRUE

/**
 * checks if we already have something in our inventory
 * if so, this will try to shift the slots over, calling equipped/unequipped automatically
 *
 * force will allow ignoring can unequip.
 *
 * returns old slot if slot shifted, otherwise null
 */
/mob/proc/_handle_item_reequip(obj/item/I, slot, old_slot, force)
	if(!old_slot)
		// DO NOT USE _slot_by_item - at this point, the item has already been var-set into the new slot!
		// slot_by_item however uses cached values still!
		old_slot = slot_by_item(I)
		if(!old_slot)
			// still not there, wasn't already in inv
			return
	// this IS a slot shift!
	. = old_slot
	if(slot == old_slot)
		// lol we're done
		return
	if(slot == SLOT_ID_HANDS)
		// if we're going into hands,
		// just check can unequip
		if(!force && !can_unequip(I, force))
			// check can unequip
			return null
		// call procs
		I.unequipped(src, old_slot)
		I.equipped(src, slot)
		log_inventory("[key_name(src)] moved [I] from [old_slot] to hands.")
		// hand procs handle rest
		return
	else
		// else, this gets painful
		#warn impl

		log_inventory("[key_name(src)] moved [I] from [old_slot] to [slot].")

#warn impl and hook

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
 * include_inhands - include held items too?
 * include_restraints - include restraints too?
 * force - ignore nodrop and all that
 */
/mob/proc/drop_inventory(include_inhands = TRUE, include_restraints = TRUE, force = TRUE)
	for(var/obj/item/I as anything in get_equipped_items(include_inhands, include_restraints))
		drop_item_to_ground(I, force)

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
	I = I._inv_return_attached()
	return islist(I)? I : list(I)

/**
 * returns if we have something equipped - the slot if it is, null if not
 *
 * SLOT_ID_HANDS if in hands
 */
/mob/proc/is_in_inventory(obj/item/I)
	return I && (I.loc == src) && I.current_equipped_slot
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
	return is_in_inventory(I)		// short circuited to that too
									// if equipped/unequipped didn't set current_equipped_slot well jokes on you lmfao

/mob/proc/_equip_slot(obj/item/I, slot, update_icons)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = _set_inv_slot(slot, I, update_icons, TRUE) != INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_unequip_slot(slot, update_icons)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = _set_inv_slot(slot, null, update_icons, TRUE) != INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_unequip_held(obj/item/I, update_icons)
	return

/mob/proc/has_slot(id)
	SHOULD_NOT_OVERRIDE(TRUE)
	return _item_by_slot(id) != INVENTORY_SLOT_DOES_NOT_EXIST

/**
 * THESE PROCS MUST BE OVERRIDDEN FOR NEW SLOTS ON MOBS
 * yes, i managed to shove all basic behaviors that needed overriding into 4 procs
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
/mob/proc/_set_inv_slot(slot, obj/item/I, update_icons, logic)
	. = INVENTORY_SLOT_DOES_NOT_EXIST
	CRASH("Attempting to set inv slot of [slot] to [I] went to base /mob. You probably had someone assigning to a nonexistant slot!")

/**
 * ""expensive"" proc that scans for the real slot of an item
 * usually used when safety checks detect something is amiss
 */
/mob/proc/_slot_by_item(obj/item/I)

/**
 * doubles as slot detection
 * returns -1 if no slot
 * YES, MAGIC VALUE BUT SOLE USER IS 20 LINES ABOVE, SUE ME.
 */
/mob/proc/_item_by_slot(slot)
	return INVENTORY_SLOT_DOES_NOT_EXIST

/mob/proc/_get_all_slots(include_restraints)
	return list()
