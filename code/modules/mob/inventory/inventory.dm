
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
			drop_item_to_ground(I, INV_OP_SILENT)

/**
 * checks for slot conflict
 */
/mob/proc/inventory_slot_conflict_check(obj/item/I, slot, flags)
	var/obj/item/conflicting = _item_by_slot(slot)
	if(conflicting)
		if((flags & (INV_OP_CAN_DISPLACE | INV_OP_IS_FINAL_CHECK)) == (INV_OP_CAN_DISPLACE | INV_OP_IS_FINAL_CHECK))
			drop_item_to_ground(conflicting, INV_OP_FORCE)
			if(_item_by_slot(slot))
				return CAN_EQUIP_SLOT_CONFLICT_HARD
		else
			return CAN_EQUIP_SLOT_CONFLICT_HARD
	switch(slot)
		if(SLOT_ID_LEFT_EAR, SLOT_ID_RIGHT_EAR)
			if(I.slot_flags & SLOT_TWOEARS)
				if(_item_by_slot(SLOT_ID_LEFT_EAR) || _item_by_slot(SLOT_ID_RIGHT_EAR))
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
			else
				var/obj/item/left_ear = _item_by_slot(SLOT_ID_LEFT_EAR)
				var/obj/item/right_ear = _item_by_slot(SLOT_ID_RIGHT_EAR)
				if(left_ear && left_ear != INVENTORY_SLOT_DOES_NOT_EXIST && left_ear != I && left_ear.slot_flags & SLOT_TWOEARS)
					return CAN_EQUIP_SLOT_CONFLICT_SOFT
				else if(right_ear && right_ear != INVENTORY_SLOT_DOES_NOT_EXIST && right_ear != I && right_ear.slot_flags & SLOT_TWOEARS)
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
/mob/proc/inventory_slot_semantic_conflict(obj/item/I, datum/inventory_slot/slot, mob/user)
	. = FALSE
	slot = resolve_inventory_slot(slot)
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
	var/datum/inventory_slot/meta = resolve_inventory_slot(slot)
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
/mob/proc/item_by_slot_id(slot)
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
/mob/proc/slot_id_by_item(obj/item/I)
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
