//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Internal Calls *//

/**
 * Should be called when an item is added to inventory.
 *
 * The call semantics for this proc is interesting.
 *
 * * It is allowed for on_item_swapped to be called instead of this proc if it's a swap.
 * * It is not required for on_item_swapped to be called instead of this proc if it's a swap.
 */
/datum/inventory/proc/on_item_entered(obj/item/item, datum/inventory_slot/slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_ENTERED, slot_or_index)
	item.inv_inside = src
	invalidate_cache()
	for(var/datum/actor_hud/inventory/hud in huds_using)
		hud.add_item(item, slot_or_index)

/**
 * Should be called when an item is removed from inventory.
 *
 * The call semantics for this proc is interesting.
 *
 * * It is allowed for on_item_swapped to be called instead of this proc if it's a swap.
 * * It is not required for on_item_swapped to be called instead of this proc if it's a swap.
 */
/datum/inventory/proc/on_item_exited(obj/item/item, datum/inventory_slot/slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_EXITED, slot_or_index)
	item.inv_inside = null
	invalidate_cache()
	for(var/datum/actor_hud/inventory/hud in huds_using)
		hud.remove_item(item, slot_or_index)

/**
 * Should be called when an item is moved from one slot to another.
 *
 * The call semantics for this proc is interesting.
 *
 * * It is not required for this proc to be called instead of exited & entered.
 * * It is recommended for this proc to be called instead of exited & entered.
 *
 * This is because this proc and exited/entered do not actually trigger item-level hooks,
 * these are just here for visuals.
 *
 * As of right now, the functionality is equivalent; on_item_swapped() is just more efficient.
 */
/datum/inventory/proc/on_item_swapped(obj/item/item, datum/inventory_slot/from_slot_or_index, datum/inventory_slot/to_slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_EXITED, from_slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_ENTERED, to_slot_or_index)
	invalidate_cache()
	for(var/datum/actor_hud/inventory/hud in huds_using)
		hud.move_item(item, from_slot_or_index, to_slot_or_index)

//* External Calls *//

/**
 * Should be called when the mob's mobility flags change.
 */
/datum/inventory/proc/on_mobility_update()
	for(var/datum/action/action in actions.actions)
		action.update_button_availability()

/**
 * Trigger handcuffed overlay updates for HUDs.
 */
/datum/inventory/proc/on_handcuffed_update()
	var/restrained = !!owner.item_by_slot_id(/datum/inventory_slot/restraints/handcuffs::id)
	for(var/datum/actor_hud/inventory/hud in huds_using)
		for(var/atom/movable/screen/actor_hud/inventory/plate/hand/hand_plate in hud.hands)
			hand_plate.set_handcuffed(restrained)
