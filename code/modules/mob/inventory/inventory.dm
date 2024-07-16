//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * mob inventory data goes in here.
 */
/datum/inventory
	//* Basics *//
	/// owning mob
	var/mob/owner

	//* Actions *//
	/// our action holder
	var/datum/action_holder/actions

	//* Inventory *//

	//* Caches *//
	/// cached overlays by slot id
	var/list/rendered_normal_overlays = list()
	/// cached overlays by slot id
	// todo: emissives
	// var/list/rendered_emissive_overlays = list()

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

//* Rendering *//

/datum/inventory/proc/remove_slot_renders()
	var/list/transformed = list()
	for(var/slot_id in rendered_normal_overlays)
		transformed += rendered_normal_overlays[slot_id]
	owner.cut_overlay(transformed)

/datum/inventory/proc/reapply_slot_renders()
	// try not to dupe
	remove_slot_renders()
	var/list/transformed = list()
	for(var/slot_id in rendered_normal_overlays)
		transformed += rendered_normal_overlays[slot_id]
	owner.add_overlay(transformed)

/**
 * just update if a slot is visible
 */
/datum/inventory/proc/update_slot_visible(slot_id, cascade = TRUE)
	// resolve item
	var/obj/item/target = owner.item_by_slot_id(slot_id)

	// first, cascade incase we early-abort later
	if(cascade)
		var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
		slot.cascade_render_visibility(owner, target)

	// check existing
	if(isnull(rendered_normal_overlays[slot_id]))
		return

	// remove overlay first incase it's already there
	owner.cut_overlay(rendered_normal_overlays[slot_id])

	// check if slot should render
	var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
	if(!slot.should_render(owner, target))
		return

	// add overlay if it should
	owner.add_overlay(rendered_normal_overlays[slot_id])

/**
 * redo a slot's render
 */
/datum/inventory/proc/update_slot_render(slot_id, cascade = TRUE)
	var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
	var/obj/item/target = owner.item_by_slot_id(slot_id)

	// first, cascade incase we early-abort later
	if(cascade)
		slot.cascade_render_visibility(owner, target)

	if(!slot.should_render(owner, target))
		remove_slot_render(slot_id)
		return

	if(isnull(target))
		remove_slot_render(slot_id)
		return

	var/bodytype = BODYTYPE_DEFAULT

	if(ishuman(owner))
		var/mob/living/carbon/human/casted_human = owner
		bodytype = casted_human.species.get_effective_bodytype(casted_human, target, slot_id)

	var/rendering_results = slot.render(owner, target, bodytype)
	if(islist(rendering_results)? !length(rendering_results) : isnull(rendering_results))
		remove_slot_render(slot_id)
		return

	set_slot_render(slot_id, rendering_results)

/datum/inventory/proc/remove_slot_render(slot_id)
	if(isnull(rendered_normal_overlays[slot_id]))
		return
	owner.cut_overlay(rendered_normal_overlays[slot_id])
	rendered_normal_overlays -= slot_id

/datum/inventory/proc/set_slot_render(slot_id, overlay)
	if(!isnull(rendered_normal_overlays[slot_id]))
		owner.cut_overlay(rendered_normal_overlays[slot_id])
	rendered_normal_overlays[slot_id] = overlay
	owner.add_overlay(overlay)

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

#warn below

/**
 * called when an item is added to inventory
 */
/datum/inventory/proc/item_entered(obj/item/item, datum/inventory_slot/slot_or_index)
	hud?.add_item(item, slot_or_index)

/**
 * called when an item is removed from inventory
 */
/datum/inventory/proc/item_exited(obj/item/item, datum/inventory_slot/slot_or_index)
	hud?.remove_item(item, slot_or_index)

#warn hook above 2

//? init

/mob/proc/init_inventory()
	return

//! unsorted below

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
