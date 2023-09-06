//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/component/rig_piece
	//* Appearance
	/// display name - what is used for UIs
	var/display_name
	var/state_sealed
	var/state_unsealed
	var/state_worn_sealed
	var/state_worn_unsealed

	//* Flags
	/// piece intrinsic flags
	var/rig_piece_flags = NONE

	//* RIG / Piece
	/// Our controller
	var/obj/item/rig/controller
	/// Our deployment slot
	var/inventory_slot

	//* Sealing
	/// are we sealed?
	var/sealed = RIG_PIECE_UNSEALED
	/// in the process of a seal operation - used internally as a mutex. don't fuck with this var.
	var/seal_mutex

/datum/component/rig_piece/Initialize(obj/item/rig/controller)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return . | COMPONENT_INCOMPATIBLE
	src.controller = controller
	#warn impl

/datum/component/rig_piece/RegisterWithParent()
	. = ..()

/datum/component/rig_piece/UnregisterFromParent()
	. = ..()

/datum/component/rig_piece/proc/tgui_piece_data()
	return list(
		"name" = display_name,
		"sealed" = sealed,
		"flags" = rig_piece_flags,
	)
	#warn impl

/datum/component/rig_piece/proc/seal(time)

/datum/component/rig_piece/proc/unseal(time)

#warn impl all

/datum/component/rig_piece/proc/deploy(mob/onto, inv_op_flags)
	var/obj/item/I = parent
	if(I.loc == onto)
		return TRUE
	else if(I.loc != controller)
		retract(inv_op_flags)
	if(isnull(inventory_slot))
		return FALSE
	return onto.equip_to_slot_if_possible(I, inventory_slot, inv_op_flags)

/datum/component/rig_piece/proc/retract(inv_op_flags)
	#warn impl

/datum/component/rig_piece/proc/is_deployed()
	var/obj/item/I = parent
	return I.loc != controller

/obj/item/clothing/head/rig

/obj/item/clothing/suit/rig

/obj/item/clothing/gloves/rig

/obj/item/clothing/shoes/rig
