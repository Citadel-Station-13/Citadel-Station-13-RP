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

/datum/robot_resource/provisioned/proc/regen(seconds)
	amount = clamp(amount + regen_per_second * seconds, 0, amount_max)

//* --- Implementations / Presets --- *//

//* presets - engineering *//

/datum/robot_resource/provisioned/preset/wire
	name = "wire spool"
	amount_max = 250
	regen_per_second = 30

/datum/robot_resource/provisioned/preset/material
	name = "provisioned material holder"

/datum/robot_resource/provisioned/preset/material/steel
	amount_max = 100 * SHEET_MATERIAL_AMOUNT
	regen_per_second = 2.5 * SHEET_MATERIAL_AMOUNT

/datum/robot_resource/provisioned/preset/material/glass
	amount_max = 100 * SHEET_MATERIAL_AMOUNT
	regen_per_second = 2.5 * SHEET_MATERIAL_AMOUNT

/datum/robot_resource/provisioned/preset/material/wood
	amount_max = 50 * SHEET_MATERIAL_AMOUNT
	regen_per_second = 1 * SHEET_MATERIAL_AMOUNT

/datum/robot_resource/provisioned/preset/material/plasteel
	amount_max = 20 * SHEET_MATERIAL_AMOUNT
	regen_per_second = 0.5 * SHEET_MATERIAL_AMOUNT

/datum/robot_resource/provisioned/preset/material/plastic
	amount_max = 20 * SHEET_MATERIAL_AMOUNT
	regen_per_second = 0.5 * SHEET_MATERIAL_AMOUNT

//* presets - medical *//

/datum/robot_resource/provisioned/preset/splints
	name = "splint magazine"
	amount_max = 30
	regen_per_second = 2

/datum/robot_resource/provisioned/preset/bandages
	name = "bandage roller"
	amount_max = 100
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/bandages/advanced
	name = "dermal nanowrap roller"
	amount_max = 100
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/ointment
	name = "ointment tank"
	amount_max = 100
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/ointment/advanced
	name = "advanced ointment tank"
	amount_max = 100
	regen_per_second = 5

/datum/robot_resource/provisioned/preset/nanopaste
	name = "synthetic polyfill nanites"
	amount_max = 50
	regen_per_second = 5

//* presets - reagents *//

/datum/robot_resource/provisioned/preset/water
	name = "water tank"
	amount_max = 500
	regen_per_second = 15
