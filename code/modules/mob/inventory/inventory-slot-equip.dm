//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Equips an item to a slot or deletes it.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_or_del(obj/item/entity, datum/inventory_slot/slot_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner.equip_to_slot_or_del(entity, slot_or_id, inv_op_flags, actor?.performer)

/**
 * Equips an item to a slot or drops it beneath our owner.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_or_drop(obj/item/entity, datum/inventory_slot/slot_or_id, inv_op_flags, datum/event_args/actor/actor)
	if(!owner.equip_to_slot_if_possible(entity, slot_or_id, inv_op_flags, actor?.performer))
		entity.forceMove(owner.drop_location())
		return FALSE
	return TRUE

/**
 * Equips an item to a slot if possible
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_if_possible(obj/item/entity, datum/inventory_slot/slot_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner.equip_to_slot_if_possible(entity, slot_or_id, inv_op_flags, actor?.performer)

/**
 * Equips an item to a slot forcefully, trampling anything in the way.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_forcefully(obj/item/entity, datum/inventory_slot/slot_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner._equip_item(entity, inv_op_flags | INV_OP_FORCE, slot_or_id, actor?.performer)

/**
 * Equips an item to a slot. This is the advanced version of the proc that returns an INV_RETURN_* result.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/equip_to_slot(obj/item/entity, datum/inventory_slot/slot_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner._equip_item(entity, inv_op_flags, slot_or_id, actor?.performer) ? INV_RETURN_SUCCESS : INV_RETURN_FAILED
