//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This is just a thing to allow sealant components a way to attach
 * to an inventory slot that doesn't have anything on it.
 */
/obj/item/sealant_glob
	name = "sealant glob"
	desc = "A glob of foaming sealant. This is usually used for hull breaches, \
		but today, you are the breach."


#warn probably don't even need below procs, component should just destroy this on remove


/obj/item/sealant_glob/can_equip(mob/M, slot, mob/user, flags)
	. = ..()

/obj/item/sealant_glob/can_unequip(mob/M, slot, mob/user, flags)
	. = ..()

/obj/item/sealant_glob/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()

/obj/item/sealant_glob/break_apart(method)
	. = ..()



#warn impl
