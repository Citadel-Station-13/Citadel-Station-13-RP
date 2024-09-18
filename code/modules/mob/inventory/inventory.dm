//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * mob inventory data goes in here.
 *
 * * this does not include hands; that's handled mob-side.
 * * this only includes inventory slots.
 */
/datum/inventory
	//* Basics *//
	/// owning mob
	var/mob/owner

	//* Actions *//
	/// our action holder
	var/datum/action_holder/actions

	//* Caches *//
	/// cached overlays by slot id or hand index
	var/list/rendered_normal_overlays = list()
	/// cached overlays by slot id
	// todo: emissives
	// var/list/rendered_emissive_overlays = list()

	//* HUD *//
	/// our hud
	///
	/// todo: can we render this per user mob? /datum/remote_control?
	var/datum/mob_hud/inventory/hud

	//* Inventory *//
	/// held items
	///
	/// * empty indices are null
	/// * this is also our rendered & nominal hand count
	/// * 1, 3, 5, ... are left
	/// * 2, 4, 6, ... are right
	var/list/obj/item/held_items = list()

	//* Slots *//
	/// our base slot ids associated to remappings
	///
	/// * key: string id; value: remapping list with keys of INVENTORY_SLOT_REMAP_*
	/// * never ever modify this list in-place, this is why it's private; this may be shared lists in species!
	VAR_PRIVATE/list/base_inventory_slots

/datum/inventory/New(mob/M)
	if(!istype(M))
		CRASH("no mob")
	owner = M
	/// no lazy-init for actions for now since items with actions are so common
	actions = new
	M.client?.action_drawer.register_holder(actions)

/datum/inventory/Destroy()
	QDEL_NULL(actions)
	owner = null
	return ..()

//* HUD *//

/**
 * returns our mob inventory
 */
/datum/inventory/proc/get_hud()
	RETURN_TYPE(/datum/mob_hud/inventory)
	if(!hud)
		hud = new(owner, src)
	return hud

//* Queries *//

/**
 * returns list() of items with body_cover_flags
 */
/datum/inventory/proc/items_that_cover(cover_flags)
	if(cover_flags == NONE)
		return list()
	. = list()
	for(var/obj/item/I as anything in owner.get_equipped_items())
		if(I.body_cover_flags & cover_flags)
			. += I

//* Update Hooks *//

/datum/inventory/proc/on_mobility_update()
	for(var/datum/action/action in actions.actions)
		action.update_button_availability()

/**
 * called when an item is added to inventory
 */
/datum/inventory/proc/item_entered(obj/item/item, datum/inventory_slot/slot)
	hud?.add_item(item, slot)

/**
 * called when an item is removed from inventory
 */
/datum/inventory/proc/item_exited(obj/item/item, datum/inventory_slot/slot)
	hud?.remove_item(item, slot)

/**
 * called when an item is moved from one slot to another
 */
/datum/inventory/proc/item_swapped(obj/item/item, datum/inventory_slot/from_slot, datum/inventory_slot/to_slot)
	hud?.move_item(item, from_slot, to_slot)

#warn hook above 3

//* Slots *//

/**
 * @return list(id = list(INVENTORY_SLOT_REMAP_*))
 */
/datum/inventory/proc/build_inventory_slots_with_remappings()
	return base_inventory_slots

/datum/inventory/proc/set_base_inventory_slots(list/mapped_slots)
	base_inventory_slots = mapped_slots
	hud?.rebuild_slots(build_inventory_slots_with_remappings())

//! unsorted / legacy below

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
 * drop items if a bodypart is missing
 */
/mob/proc/reconsider_inventory_slot_bodypart(bodypart)
	// todo: this and the above function should be on the slot datums.
	var/list/obj/item/affected
	switch(bodypart)
		if(BP_HEAD)
			affected = items_by_slot_id(
				SLOT_ID_HEAD,
				SLOT_ID_LEFT_EAR,
				SLOT_ID_RIGHT_EAR,
				SLOT_ID_MASK,
				SLOT_ID_GLASSES
			)
		if(BP_GROIN, BP_TORSO)
			affected = items_by_slot_id(
				SLOT_ID_BACK,
				SLOT_ID_BELT,
				SLOT_ID_SUIT,
				SLOT_ID_SUIT_STORAGE,
				SLOT_ID_RIGHT_POCKET,
				SLOT_ID_LEFT_POCKET,
				SLOT_ID_UNIFORM
			)
		if(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND)
			affected = items_by_slot_id(
				SLOT_ID_HANDCUFFED,
				SLOT_ID_GLOVES
			)
		if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
			affected = items_by_slot_id(
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
