//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: relay on_equipped() normally; it's currently relay'd by equipped()

/obj/item/clothing/on_unequipped(mob/wearer, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	// Do not allow nested propagation.
	if(!(inv_op_flags & INV_OP_IS_ACCESSORY) && length(accessories))
		for(var/obj/item/acc as anything in accessories)
			acc.on_unequipped(wearer, slot_id_or_index, inv_op_flags | INV_OP_IS_ACCESSORY, actor)

// todo: relay on_pickup() normally; it's currently relay'd by pickup()
// todo: relay on_dropped() normally; it's currently relay'd by dropped()
