//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/sealant_glob
	name = "sealant glob"
	desc = "A glob of foaming sealant. This is usually used for hull breaches, \
		but today, you are the breach."
	icon = 'icons/modules/sealant_gun/sealant_glob.dmi'
	icon_state = "glob"

	worn_render_flags = NONE

	encumbrance = ITEM_ENCUMBRANCE_SEALANT_GLOB

	/**
	 * Sprites exist for these slots, as well as hands.
	 */
	var/const/list/allowed_slot_ids = list(
		/datum/inventory_slot/abstract/put_in_hands::id,
		/datum/inventory_slot/inventory/head::id,
		/datum/inventory_slot/inventory/mask::id,
		/datum/inventory_slot/inventory/shoes::id,
		/datum/inventory_slot/inventory/suit::id,
	)

/obj/item/sealant_glob/can_equip(mob/M, slot, mob/user, flags)
	. = ..()

/obj/item/sealant_glob/can_unequip(mob/M, slot, mob/user, flags)
	. = ..()

/obj/item/sealant_glob/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()

/obj/item/sealant_glob/break_apart(method)
	. = ..()



#warn impl
