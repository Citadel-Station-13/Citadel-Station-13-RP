//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Item enter / exit *//

/**
 * Should be called when an item is added to inventory.
 *
 * The call semantics for this proc is interesting.
 *
 * * It is allowed for on_item_swapped to be called instead of this proc if it's a swap.
 * * It is not required for on_item_swapped to be called instead of this proc if it's a swap.
 */
/datum/inventory/proc/on_item_entered(obj/item/item, datum/inventory_slot/slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_ENTERED_SLOT, slot_or_index)

/**
 * Should be called when an item is removed from inventory.
 *
 * The call semantics for this proc is interesting.
 *
 * * It is allowed for on_item_swapped to be called instead of this proc if it's a swap.
 * * It is not required for on_item_swapped to be called instead of this proc if it's a swap.
 */
/datum/inventory/proc/on_item_exited(obj/item/item, datum/inventory_slot/slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_EXITED_SLOT, slot_or_index)

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
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_EXITED_SLOT, from_slot_or_index)
	SEND_SIGNAL(src, COMSIG_INVENTORY_ITEM_ENTERED_SLOT, to_slot_or_index)

/**
 * Should be called when the mob's mobility flags change.
 */
/datum/inventory/proc/on_mobility_update()
	for(var/datum/action/action in actions.actions)
		action.update_button_availability()
