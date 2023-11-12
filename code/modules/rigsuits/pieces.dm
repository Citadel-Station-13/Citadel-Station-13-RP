//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/deploy_piece(datum/event_args/actor/actor, datum/component/rig_piece/piece, seal = TRUE, instant_seal, force)
	#warn impl

/obj/item/rig/proc/undeploy_piece(datum/event_args/actor/actor, datum/component/rig_piece/piece, unseal = TRUE, instant_unseal)
	#warn impl

/obj/item/rig/proc/seal_piece(datum/event_args/actor/actor, datum/component/rig_piece/piece, instant, override)
	#warn impl

/obj/item/rig/proc/unseal_piece(datum/event_args/actor/actor, datum/component/rig_piece/piece, instant, override)
	#warn impl

#warn impl

/obj/item/rig/proc/deploy_async(datum/event_args/actor/actor, seal = TRUE, instant_seal, force)

/obj/item/rig/proc/undeploy_async(datum/event_args/actor/actor, unseal = TRUE, instant_unseal)

/obj/item/rig/proc/seal_async(datum/event_args/actor/actor, instant, override)

/obj/item/rig/proc/unseal_async(datum/event_args/actor/actor, instant, override)

/obj/item/rig/proc/add_piece(datum/component/rig_piece/piece)
	piece_components += piece
	piece_items += piece.parent

/obj/item/rig/proc/legacy_sync_piece(datum/component/rig_piece/piece, sealed)
	var/obj/item/physical = piece.parent
	if(piece.rig_piece_flags & RIG_PIECE_APPLY_ARMOR)
		physical.set_armor(suit_armor)
	else
		physical.reset_armor()
	if((piece.rig_piece_flags & RIG_PIECE_APPLY_ENVIRONMENTALS) && sealed)
		physical.max_pressure_protection = max_pressure_protect
		physical.min_pressure_protection = min_pressure_protect
		physical.max_heat_protection_temperature = max_temperature_protect
		physical.min_cold_protection_temperature = min_temperature_protect
	else
		physical.max_pressure_protection = initial(physical.max_pressure_protection)
		physical.min_pressure_protection = initial(physical.min_pressure_protection)
		physical.max_heat_protection_temperature = initial(physical.max_heat_protection_temperature)
		physical.min_cold_protection_temperature = initial(physical.min_cold_protection_temperature)
	if(!piece.always_fully_insulated)
		physical.siemens_coefficient = siemens_coefficient
	else
		physical.siemens_coefficient = 0
