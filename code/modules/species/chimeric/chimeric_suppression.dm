//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Suppression sources.
 * * These are instanced per chimeric core.
 */
/datum/chimeric_suppression
	/// unique id
	var/id
	/// current amount
	var/amount = 0
	/// general susceptibility multiplier
	var/multiplier = 1

/**
 * From burns
 */
/datum/chimeric_suppression/incineration
	id = "fire"

/**
 * From EMPs & ion beams
 */
/datum/chimeric_suppression/ionic
	id = "emp"

/**
 * From certain chemicals that make them drowsy
 */
/datum/chimeric_suppression/chem_anesthetic
	id = "anesthetic"

/**
 * From certain chemicals that are poisonous to them
 */
/datum/chimeric_suppression/chem_poison
	id = "poison"

/**
 * From blunt impacts
 */
/datum/chimeric_suppression/kinetic_impact
	id = "impact"

/**
 * From piercing damage
 */
/datum/chimeric_suppression/kinetic_pierce
	id = "pierce"
