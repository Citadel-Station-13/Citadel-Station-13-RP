//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
