//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Descriptor of a stored resource.
 */
/datum/robot_resource
	/// storage name
	var/name
	/// max amount
	/// * sheets for stacks
	/// * cm3 for materials
	/// * units for reagents
	var/amount_max = 0
	/// current amount
	var/amount = 0

/datum/robot_resource/New()
	if(isnull(amount))
		amount = amount_max

/**
 * Provisioned, hardcoded resources.
 *
 * * Provided by the module.
 * * Automatically regenerates if `regen_per_second` is non-zero.
 */
/datum/robot_resource/provisioned
	/// base regen per second
	var/regen_per_second = 1
	/// provide a given stack type
	var/legacy_stack_path
	/// form sum types if possible
	/// * example: metal/glass forming rglass and metal forming tiles
	var/legacy_form_sum_types = FALSE

//* --- Implementations / Presets --- *//

//* presets - engineering *//

#warn name the ones in this section

/datum/robot_resource/provisioned/preset/wire
	name = "wire spool"
	legacy_stack_path = /obj/item/stack/cable_coil
	amount_max = 250
	regen_per_second = 30

/datum/robot_resource/provisioned/preset/material
	name = "provisioned material holder"
	legacy_form_sum_types = TRUE

/datum/robot_resource/provisioned/preset/material/steel
	legacy_stack_path = /obj/item/stack/material/steel
	amount_max = 100
	regen_per_second = 2.5

/datum/robot_resource/provisioned/preset/material/glass
	legacy_stack_path = /obj/item/stack/material/glass
	amount_max = 100
	regen_per_second = 2.5

/datum/robot_resource/provisioned/preset/material/wood
	legacy_stack_path = /obj/item/stack/material/wood
	amount_max = 50
	regen_per_second = 1

/datum/robot_resource/provisioned/preset/material/plasteel
	legacy_stack_path = /obj/item/stack/material/plasteel
	amount_max = 20
	regen_per_second = 0.5

/datum/robot_resource/provisioned/preset/material/plastic
	legacy_stack_path = /obj/item/stack/material/plastic
	amount_max = 20
	regen_per_second = 0.5

//* presets - medical *//

/datum/robot_resource/provisioned/preset/bandages
	display_name = "bandage roller"
	legacy_stack_path = /obj/item/stack/medical/bruise_pack
	amount_max = 50
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/bandages/advanced
	display_name = "dermal nanowrap roller"
	legacy_stack_path = /obj/item/stack/medical/advanced/bruise_pack
	amount_max = 50
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/ointment
	display_name = "ointment tank"
	legacy_stack_path = /obj/item/stack/medical/ointment
	amount_max = 50
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/ointment/advanced
	display_name = "advanced ointment tank"
	legacy_stack_path = 	amount_max = 50
	amount_max = 50
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/nanopaste
	display_name = "synthetic polyfill nanites"
	legacy_stack_path = /obj/item/stack/nanopaste/advanced
	amount_max = 50
	regen_per_second = 5

