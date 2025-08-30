//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/organ/internal/nano/nanite_rig_subcore

	/// rig theme; set to type or id to initialize
	var/datum/rig_theme/rig_theme
	/// stored rig
	var/obj/item/rig/rig
	/// should the stored rig start with preset modules?
	var/rig_is_equipped = TRUE
	/// additional modules to mount into the rig
	var/list/rig_additional_module_descriptors

/obj/item/organ/internal/nano/nanite_rig_subcore/on_insert(mob/owner, initializing)
	. = ..()

/obj/item/organ/internal/nano/nanite_rig_subcore/on_remove(mob/owner)
	. = ..()

/obj/item/organ/internal/nano/nanite_rig_subcore/proc/create_rig_instance()

/obj/item/organ/internal/nano/nanite_rig_subcore/proc/initialize_rig()



#warn impl
