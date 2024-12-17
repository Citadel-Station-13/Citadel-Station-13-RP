//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Equips an item to a slot or deletes it.
 *
 * @params
 * * entity - Item being equipped.
 * * type_or_id - A typepath, or string ID.
 * * inv_op_flags - INV_OP_* bits.
 * * actor - Actor data of who did it.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_or_del(obj/item/entity, datum/inventory_slot/type_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner.equip_to_slot_or_del(entity, type_or_id, inv_op_flags, actor?.performer)

/**
 * Equips an item to a slot or drops it beneath our owner.
 *
 * @params
 * * entity - Item being equipped.
 * * type_or_id - A typepath, or string ID.
 * * inv_op_flags - INV_OP_* bits.
 * * actor - Actor data of who did it.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_or_drop(obj/item/entity, datum/inventory_slot/type_or_id, inv_op_flags, datum/event_args/actor/actor)
	if(!owner.equip_to_slot_if_possible(entity, type_or_id, inv_op_flags, actor?.performer))
		entity.forceMove(owner.drop_location())
		return FALSE
	return TRUE

/**
 * Equips an item to a slot if possible
 *
 * @params
 * * entity - Item being equipped.
 * * type_or_id - A typepath, or string ID.
 * * inv_op_flags - INV_OP_* bits.
 * * actor - Actor data of who did it.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_if_possible(obj/item/entity, datum/inventory_slot/type_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner.equip_to_slot_if_possible(entity, type_or_id, inv_op_flags, actor?.performer)

/**
 * Equips an item to a slot forcefully, trampling anything in the way.
 *
 * @params
 * * entity - Item being equipped.
 * * type_or_id - A typepath, or string ID.
 * * inv_op_flags - INV_OP_* bits.
 * * actor - Actor data of who did it.
 *
 * @return TRUE / FALSE
 */
/datum/inventory/proc/equip_to_slot_forcefully(obj/item/entity, datum/inventory_slot/type_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner._equip_item(entity, inv_op_flags | INV_OP_FORCE, type_or_id, actor?.performer)

/**
 * Equips an item to a slot. This is the advanced version of the proc that returns an INV_RETURN_* result.
 *
 * @params
 * * entity - Item being equipped.
 * * type_or_id - A typepath, or string ID.
 * * inv_op_flags - INV_OP_* bits.
 * * actor - Actor data of who did it.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/equip_to_slot(obj/item/entity, datum/inventory_slot/type_or_id, inv_op_flags, datum/event_args/actor/actor)
	return owner._equip_item(entity, inv_op_flags, type_or_id, actor?.performer) ? INV_RETURN_SUCCESS : INV_RETURN_FAILED

/**
 * Equips an item to an ordered list of slots. This is an advanced version of the proc that returns an INV_RETURN_* result
 *
 * @params
 * * entity - item being equipped
 * * slots - A list of: typepaths, or string ids
 * * inv_op_flags - INV_OP_* bits
 * * actor - actor data of who did it.
 *
 * @return INV_RETURN_*
 */
/datum/inventory/proc/equip_to_slots(obj/item/entity, list/datum/inventory_slot/slots, inv_op_flags, datum/event_args/actor/actor)
	for(var/slot in slots)
		switch(owner._equip_item(entity, inv_op_flags, slot, actor?.performer))
			if(INV_RETURN_DELETED)
				return INV_RETURN_DELETED
			if(INV_RETURN_FAILED)
				continue
			if(INV_RETURN_RELOCATED)
				return INV_RETURN_RELOCATED
			if(INV_RETURN_SUCCESS)
				return INV_RETURN_SUCCESS
			else
				CRASH("unimplemented inv return: [.]")
	return INV_RETURN_FAILED
