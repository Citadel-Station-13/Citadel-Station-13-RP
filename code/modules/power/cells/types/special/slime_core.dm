//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/cell/slime_core
	name = "charged slime core"
	desc = "A chunk of charged slime lattice, pulsing with energy. Is this even ethical?"
	icon = 'icons/items/power/cells/special/slime_core.dmi'
	icon_state = "core"
	rendering_system = FALSE
	rating = 5
	self_recharge = TRUE

	var/join_type
	var/join_result
	var/split_result

/obj/item/cell/slime_core/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, join_type) && join_result)
		var/obj/item/cell/joining = using
		// TODO: sound
		// TODO: log
		var/obj/item/cell/joined = new join_result
		joined.set_integrity(joined.integrity_max * (((src.integrity / src.integrity_max) + (joining.integrity / joining.integrity_max)) / 2))
		joined.set_charge(joined.max_charge * (((src.charge / src.max_charge) + (joining.charge / joining.max_charge)) / 2))
		joined.charge = src.charge + joining.charge
		clickchain.chat_feedback(SPAN_NOTICE("You squeeze both [src]\s together, forming a [joined]."), target = src)
		qdel(using)
		qdel(src)
		// TODO: check telekinesis
		clickchain.performer.put_in_hands_or_drop(joined)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/cell/slime_core/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// TODO: allow context menu version
	if(split_result && clickchain.performer.is_holding_inactive(src))
		// TODO: sound
		// TODO: log
		var/obj/item/cell/split1 = new split_result
		var/obj/item/cell/split2 = new split_result
		transfer_fingerprints_to(split1)
		transfer_fingerprints_to(split2)
		var/split_integrity = split1.integrity_max * (integrity / integrity_max)
		split1.set_integrity(split_integrity)
		split2.set_integrity(split_integrity)
		var/split_charge = split1.max_charge * (charge / max_charge)
		split1.set_charge(split_charge)
		split1.set_charge(split_charge)
		clickchain.chat_feedback(SPAN_NOTICE("You squeeze through [src]'s middle, splitting it into two [split1]\s."), target = src)
		qdel(src)
		// TODO: check telekinesis
		clickchain.performer.put_in_hands_or_drop(split1)
		clickchain.performer.put_in_hands_or_drop(split2)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/cell/slime_core/eighth
	name = "charged slime sliver"
	desc = /obj/item/cell/slime_core::desc + " This one seems to be one-eighth of a full core, and can be combined with another eight to form a fourth-core."
	icon_state = "core-eighth"

	join_type = /obj/item/cell/slime_core/eighth
	join_result = /obj/item/cell/slime_core/fourth
	split_result = null

	max_charge = POWER_CELL_CAPACITY_SMALL * (5 / 6)
	self_recharge_amount = POWER_CELL_CAPACITY_SMALL * (5 / 6) / ((4 MINUTES) / (1 SECONDS))
	cell_type = CELL_TYPE_SMALL
	w_class = WEIGHT_CLASS_SMALL
	weight_volume = ITEM_VOLUME_SMALL_CELL / 2

/obj/item/cell/slime_core/fourth
	name = "charged slime fragment"
	desc = /obj/item/cell/slime_core::desc + " This one seems to be one-fourth of a full core, and can be combined with another fourth to form a half-core."
	icon_state = "core-fourth"

	join_type = /obj/item/cell/slime_core/fourth
	join_result = /obj/item/cell/slime_core/half
	split_result = /obj/item/cell/slime_core/eighth

	max_charge = POWER_CELL_CAPACITY_WEAPON * (5 / 6)
	self_recharge_amount = POWER_CELL_CAPACITY_WEAPON * (5 / 6) / ((4 MINUTES) / (1 SECONDS))
	cell_type = CELL_TYPE_WEAPON
	w_class = WEIGHT_CLASS_SMALL
	weight_volume = ITEM_VOLUME_WEAPON_CELL / 2

/obj/item/cell/slime_core/half
	name = "charged slime globule"
	desc = /obj/item/cell/slime_core::desc + " This one seems to be one-half of a full core, and can be combined with another half to reform the full core."
	icon_state = "core-half"

	join_type = /obj/item/cell/slime_core/half
	join_result = /obj/item/cell/slime_core/whole
	split_result = /obj/item/cell/slime_core/fourth

	max_charge = POWER_CELL_CAPACITY_MEDIUM * (5 / 6)
	self_recharge_amount = POWER_CELL_CAPACITY_MEDIUM * (5 / 6) / ((4 MINUTES) / (1 SECONDS))
	cell_type = CELL_TYPE_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = ITEM_VOLUME_MEDIUM_CELL / 2

/obj/item/cell/slime_core/whole
	name = "charged slime core"
	desc = /obj/item/cell/slime_core::desc + " This one seems to be a full core, and can be split apart into two halves."
	icon_state = "core"

	join_type = null
	join_result = null
	split_result = /obj/item/cell/slime_core/half

	max_charge = POWER_CELL_CAPACITY_LARGE * (5 / 6)
	self_recharge_amount = POWER_CELL_CAPACITY_LARGE * (5 / 6) / ((4 MINUTES) / (1 SECONDS))
	cell_type = CELL_TYPE_LARGE
	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = ITEM_VOLUME_LARGE_CELL / 2
