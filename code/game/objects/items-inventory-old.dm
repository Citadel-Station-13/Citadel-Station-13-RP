//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Hooks - Old *//

/**
 * called when an item is equipped to inventory or picked up
 *
 * @params
 * user - person equipping us
 * slot - slot id we're equipped to
 * flags - inventory operation flags, see defines
 */
/obj/item/proc/equipped(mob/user, slot, flags)
	SHOULD_CALL_PARENT(TRUE)

	// set slot
	worn_slot = slot
	inv_slot_or_index = slot == SLOT_ID_HANDS ? user.get_held_index(src) : slot
	inv_inside = user.inventory
	// register carry
	if(isliving(user))
		var/mob/living/L = user
		if((slot == SLOT_ID_HANDS)? (item_flags & ITEM_ENCUMBERS_WHILE_HELD) : !(item_flags & ITEM_ENCUMBERS_ONLY_HELD))
			if(flat_encumbrance)
				L.recalculate_carry()
			else
				encumbrance_registered = get_encumbrance()
				L.adjust_current_carry_encumbrance(encumbrance_registered)
	// fire signals
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot, flags)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_EQUIPPED, src, slot, flags)

	if((slot != SLOT_ID_HANDS) && equip_sound)
		playsound(src, equip_sound, 30, ignore_walls = FALSE)

	// call the new hook instead
	on_inv_equipped(user, user.inventory, slot == SLOT_ID_HANDS? user.get_held_index(src) : slot, flags)


/**
 * called when an item is unequipped from inventory or moved around in inventory
 *
 * @params
 * user - person unequipping us
 * slot - slot id we're unequipping from
 * flags - inventory operation flags, see defines
 */
/obj/item/proc/unequipped(mob/user, slot, flags)
	SHOULD_CALL_PARENT(TRUE)
	// clear slot
	worn_slot = null
	inv_slot_or_index = null
	inv_inside = null
	// clear carry
	if(isliving(user))
		var/mob/living/L = user
		if(flat_encumbrance)
			L.recalculate_carry()
		else if(!isnull(encumbrance_registered))
			L.adjust_current_carry_encumbrance(-encumbrance_registered)
			encumbrance_registered = null
	// fire signals
	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user, slot, flags)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_UNEQUIPPED, src, slot, flags)

	if(!(flags & INV_OP_DIRECTLY_DROPPING) && (slot != SLOT_ID_HANDS) && unequip_sound)
		playsound(src, unequip_sound, 30, ignore_walls = FALSE)

	// on_inv_unequipped cannot be called here, as we don't know the inventory index exactly
	// todo: kill unequipped()

/**
 * called when a mob drops an item
 *
 * ! WARNING: You CANNOT assume we are post or pre-move on dropped.
 * ! If unequipped() deletes the item, loc will be null. Sometimes, loc won't change at all!
 *
 * dropping is defined as moving out of both equipment slots and hand slots
 */
/obj/item/proc/dropped(mob/user, flags, atom/newLoc)
	SHOULD_CALL_PARENT(TRUE)

	// unset things
	item_flags &= ~ITEM_IN_INVENTORY
	vis_flags &= ~(VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)
	// clear carry
	if(isliving(user))
		var/mob/living/L = user
		L.adjust_current_carry_weight(-weight_registered)
	weight_registered = null
	// unload actions
	unregister_item_actions(user)
	// close context menus
	close_context_menus()
	// storage stuff
	obj_storage?.on_dropped(user)
	// get rid of shieldcalls
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		if(!shieldcall.shields_in_inventory)
			continue
		user.unregister_shieldcall(shieldcall)

	//! LEGACY
	if(!(flags & INV_OP_SUPPRESS_SOUND) && isturf(newLoc) && !(. & COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND))
		playsound(src, drop_sound, 30, ignore_walls = FALSE)
	// user?.update_equipment_speed_mods()
	if(zoom)
		zoom() //binoculars, scope, etc
	//! END

	// fire signals
	. = SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user, flags, newLoc)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_DROPPED, src, flags, newLoc)

	if((item_flags & ITEM_DROPDEL) && !(flags & INV_OP_DELETING))
		qdel(src)
		. |= ITEM_RELOCATED_BY_DROPPED

	return ((. & COMPONENT_ITEM_DROPPED_RELOCATE)? ITEM_RELOCATED_BY_DROPPED : NONE)

/**
 * called when a mob picks up an item
 *
 * picking up is defined as moving into either an equipment slot, or hand slots
 */
/obj/item/proc/pickup(mob/user, flags, atom/oldLoc)
	SHOULD_CALL_PARENT(TRUE)

	// set things
	item_flags |= ITEM_IN_INVENTORY
	vis_flags |= (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)
	// we load the component here as it hooks equipped,
	// so loading it here means it can still handle the equipped signal.
	if(passive_parry)
		LoadComponent(/datum/component/passive_parry, passive_parry)

	// load action buttons
	register_item_actions(user)
	// register carry
	weight_registered = get_weight()
	if(isliving(user))
		var/mob/living/L = user
		L.adjust_current_carry_weight(weight_registered)
	// register shieldcalls
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		if(!shieldcall.shields_in_inventory)
			continue
		user.register_shieldcall(shieldcall)
	// storage stuff
	obj_storage?.on_pickup(user)

	//! LEGACY
	reset_pixel_offsets()
	// todo: should this be here
	transform = null
	if(isturf(oldLoc) && !(flags & (INV_OP_SILENT | INV_OP_DIRECTLY_EQUIPPING)))
		playsound(src, pickup_sound, 20, ignore_walls = FALSE)
	//! END

	// fire signals
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user, flags, oldLoc)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_PICKUP, src, flags, oldLoc)

//* Access *//

/**
 * get the mob we're equipped on
 */
/obj/item/proc/get_worn_mob() as /mob
	RETURN_TYPE(/mob)
	return worn_inside?.get_worn_mob() || (worn_slot? loc : null)


//* Stripping *//

/**
 * get strip menu options by  href key associated to name.
 */
/obj/item/proc/strip_menu_options(mob/user)
	RETURN_TYPE(/list)
	return list()

/**
 * strip menu act
 *
 * adjacency is pre-checked.
 * return TRUE to refresh
 */
/obj/item/proc/strip_menu_act(mob/user, action)
	return FALSE

/**
 * standard do after for interacting from strip menu
 */
/obj/item/proc/strip_menu_standard_do_after(mob/user, delay)
	. = FALSE
	var/slot = worn_slot
	if(!slot)
		CRASH("no worn slot")
	var/mob/M = get_worn_mob()
	if(!M)
		CRASH("no worn mob")
	if(!M.strip_interaction_prechecks(user))
		return
	if(!do_after(user, delay, M, DO_AFTER_IGNORE_ACTIVE_ITEM))
		return
	if(slot != worn_slot || M != get_worn_mob())
		return
	return TRUE

//* Checks *//
// todo: item should get final say for "soft" aka not-literal-var-overwrite conflicts.

/**
 * checks if a mob can equip us to a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/can_equip(mob/M, slot, mob/user, flags)
	if(!equip_check_beltlink(M, slot, user, flags))
		return FALSE
	if(ishuman(M) && !(flags & INV_OP_FORCE))
		// todo: put on the mob side maybe?
		var/mob/living/carbon/human/casted_bodytype_check = M
		var/their_bodytype = casted_bodytype_check.species.get_effective_bodytype(casted_bodytype_check, src, slot)
		if(!worn_bodytypes?.contains(their_bodytype) && !worn_bodytypes_fallback?.contains(their_bodytype))
			if(!(flags & INV_OP_SILENT))
				to_chat(user || M, SPAN_WARNING("[src] doesn't fit on you."))
			return FALSE
	return TRUE

/**
 * checks if a mob can unequip us from a slot
 * mob gets final say
 * if you return false, feedback to the user, as the main proc doesn't do this.
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/can_unequip(mob/M, slot, mob/user, flags)
	return TRUE

/**
 * allow an item in suit storage slot?
 */
/obj/item/proc/can_suit_storage(obj/item/I)
	if(suit_storage_types_disallow_override)
		for(var/path in suit_storage_types_disallow_override)
			if(istype(I, path))
				return FALSE
	if(suit_storage_types_allow_override)
		for(var/path in suit_storage_types_allow_override)
			if(istype(I, path))
				return FALSE
	if(suit_storage_class_disallow & I.suit_storage_class)
		return FALSE
	if(suit_storage_class_allow & I.suit_storage_class)
		return TRUE
	return FALSE

/**
 * checks if we need something to attach to in a certain slot
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/equip_check_beltlink(mob/M, slot, mob/user, flags)
	if(clothing_flags & CLOTHING_IGNORE_BELTLINK)
		return TRUE

	if(!ishuman(M))
		return TRUE

	var/mob/living/carbon/human/H = M

	switch(slot)
		if(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot_id(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_WORN_ID)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot_id(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_BELT)
			if(H.semantically_has_slot(SLOT_ID_UNIFORM) && !H.item_by_slot_id(SLOT_ID_UNIFORM))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach [src]."))
				return FALSE
		if(SLOT_ID_SUIT_STORAGE)
			if(H.semantically_has_slot(SLOT_ID_SUIT) && !H.item_by_slot_id(SLOT_ID_SUIT))
				if(!(flags & INV_OP_SUPPRESS_WARNING))
					to_chat(H, SPAN_WARNING("You need a suit before you can attach [src]."))
				return FALSE
	return TRUE

/**
 * automatically unequip if we're missing beltlink
 */
/obj/item/proc/reconsider_beltlink()
	var/mob/M = loc
	if(!istype(M))
		return
	if(!worn_slot)
		return
	if(!equip_check_beltlink(M, worn_slot, null, INV_OP_SILENT))
		M.drop_item_to_ground(src, INV_OP_SILENT)
		return

//* Speed / Carry Weight *//

/**
 * get the slowdown we incur when we're worn
 */
/obj/item/proc/get_equipment_speed_mod()
	return slowdown

//* ADVANCED: Wear-Over System *//

/**
 * checks if we can fit over something
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	return FALSE

/**
 * call when we fit us over something - item should be already in us
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/equip_on_worn_over_insert(mob/M, slot, mob/user, obj/item/I, flags)
	if(!(flags & INV_OP_SUPPRESS_WARNING))
		to_chat(M, SPAN_NOTICE("You slip [src] over [I]."))

/**
 * call when we unfit us over something - item should already be out of us
 *
 * todo: non-singular-letter proc args
 */
/obj/item/proc/equip_on_worn_over_remove(mob/M, slot, mob/user, obj/item/I, flags)

//* ADVANCED: Compound Objects *//

/**
 * returns either an item or a list
 * get_equipped_items() uses this so accessories are included
 * anything this returns is considered to be in the same slot.
 *
 * * You must never return anything that would be returned when this is called on any other item!
 *   Things can only be in one slot at a time, even with this compound-item system.
 */
/obj/item/proc/inv_slot_attached()
	if(worn_over)
		return list(src) + worn_over.inv_slot_attached()
	else
		return src
