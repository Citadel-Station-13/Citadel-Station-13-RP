//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Hooks *//

/**
 * Called when we enter a new inventory slot, or hand index.
 *
 * * Called after on_inv_unequipped in a swap
 * * Called after on_inv_pickup on a pickup
 *
 * @params
 * * wearer - The mob whose inventory we're in.
 * * inventory - The inventory we're in
 * * slot_id_or_index - Text slot ID or numerical hand index
 * * inv_op_flags - INV_OP_* bits.
 * * actor - (optional) Actor data of who's putting it on us.
 */
/obj/item/proc/on_inv_equipped(mob/wearer,datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Called when we exit an inventory slot, or hand index.
 *
 * * Called after on_inv_unequipped in a swap
 * * Called before on_inv_dropped on a drop
 *
 * @params
 * * wearer - The mob whose inventory we're in.
 * * inventory - The inventory we're in
 * * slot_id_or_index - Text slot ID or numerical hand index
 * * inv_op_flags - INV_OP_* bits.
 * * actor - (optional) Actor data of who's putting it on us.
 */
/obj/item/proc/on_inv_unequipped(mob/wearer,datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Called when we are picked up
 *
 * todo: hook into inventory; this is currently nonfunctional
 *
 * * Called before on_inv_equipped
 *
 * @params
 * * wearer - The mob whose inventory we're entering
 * * inventory - The inventory we're entering
 * * inv_op_flags - INV_OP_* bits.
 * * actor - (optional) Actor data of who's putting it on us.
 */
/obj/item/proc/on_inv_pickup(mob/wearer, datum/inventory/inventory, inv_op_flags, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Called when we are dropped
 *
 * todo: hook into inventory; this is currently nonfunctional
 *
 * * Called after on_inv_unequipped
 *
 * @params
 * * wearer - The mob whose inventory we're exiting
 * * inventory - The inventory we're exiting
 * * inv_op_flags - INV_OP_* bits.
 * * actor - (optional) Actor data of who's putting it on us.
 */
/obj/item/proc/on_inv_dropped(mob/wearer, datum/inventory/inventory, inv_op_flags, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

//* Checks *//

/**
 * checks if we're in inventory. if so, returns mob we're in
 */
/obj/item/proc/is_in_inventory() as /mob
	return inv_inside?.owner

/**
 * checks if we're held in hand
 *
 * if so, returns mob we're in
 */
/obj/item/proc/is_being_held() as /mob
	return isnum(inv_slot_or_index) ? inv_inside?.owner : null

/**
 * checks if we're worn. if so, return mob we're in
 *
 * note: this is not the same as is_in_inventory, we check if it's a clothing/worn slot in this case!
 */
/obj/item/proc/is_being_worn() as /mob
	if(!worn_slot)
		return FALSE
	var/datum/inventory_slot/slot_meta = resolve_inventory_slot(worn_slot)
	return slot_meta.inventory_slot_flags & INV_SLOT_CONSIDERED_WORN

//* Shieldcall registration

/obj/item/register_shieldcall(datum/shieldcall/delegate)
	. = ..()
	if(delegate.shields_in_inventory)
		get_worn_mob()?.register_shieldcall(delegate)

/obj/item/unregister_shieldcall(datum/shieldcall/delegate)
	. = ..()
	if(delegate.shields_in_inventory)
		get_worn_mob()?.unregister_shieldcall(delegate)
