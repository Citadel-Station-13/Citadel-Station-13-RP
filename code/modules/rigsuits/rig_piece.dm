//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/component/rig_piece
	#warn more vars?
	/// display name - what is used for UIs
	var/display_name
	/// are we sealed?
	var/sealed = RIG_PIECE_UNSEALED
	/// in the process of a seal operation - used internally as a mutex. don't fuck with this var.
	var/seal_mutex
	/// piece intrinsic flags
	var/rig_piece_flags = NONE
	/// multiplier to armor to apply - does *not* affect armor tier
	var/armor_multiplier = 1

/datum/component/rig_piece/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return . | COMPONENT_INCOMPATIBLE
	#warn impl

/datum/component/rig_piece/RegisterWithParent()
	. = ..()

/datum/component/rig_piece/UnregisterFromParent()
	. = ..()

/datum/component/rig_piece/proc/tgui_piece_data()
	#warn impl

#warn impl all

/obj/item/clothing/head/rig

/obj/item/clothing/suit/rig

/obj/item/clothing/gloves/rig

/obj/item/clothing/shoes/rig
