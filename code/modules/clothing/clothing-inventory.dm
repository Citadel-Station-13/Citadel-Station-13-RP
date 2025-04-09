//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: relay on_inv_equipped() normally; it's currently relay'd by equipped()

/obj/item/clothing/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	// Do not allow nested propagation.
	if(!(inv_op_flags & INV_OP_IS_ACCESSORY) && length(accessories))
		for(var/obj/item/acc as anything in accessories)
			acc.on_inv_unequipped(wearer, inventory, slot_id_or_index, inv_op_flags | INV_OP_IS_ACCESSORY, actor)

// todo: relay on_inv_pickup() normally; it's currently relay'd by pickup()
// todo: relay on_inv_dropped() normally; it's currently relay'd by dropped()
