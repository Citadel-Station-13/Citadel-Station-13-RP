//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
