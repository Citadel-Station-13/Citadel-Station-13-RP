//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Encapsulates power cell behavior.
 */
/datum/power_cell
	//* Descriptors *//

	/// our cell name
	///
	/// * used for type generation
	var/cell_name = "unknown"
	/// our cell description append.
	///
	/// * used for type generation
	var/cell_desc = "Some unknown technology, probably. What is this?"

	//* Function *//

	/// are we an actual functional power cell datum, or just a template?
	///
	/// * If set to FALSE, the power cell will not grab a datum instance of us, rather than just setting variables via us.
	var/functional = FALSE
	#warn impl

	//* Capacity - Type Generation *//

	var/typegen_capacity_multiplier = 1
	/// compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_small = 1
	/// compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_medium = 1
	/// compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_large = 1
	/// compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_weapon = 1

	//* Materials - Type Generation *//

	var/typegen_material_multiply = 1
	/// compounded with [typegen_material_multiply]
	var/typegen_material_multiply_small = 1
	/// compounded with [typegen_material_multiply]
	var/typegen_material_multiply_medium = 1
	/// compounded with [typegen_material_multiply]
	var/typegen_material_multiply_large = 1
	/// compounded with [typegen_material_multiply]
	var/typegen_material_multiply_weapon = 1

	/// sets base materials; negative values are allowed
	///
	/// * this is applied before typegen material multiply
	var/list/typegen_materials_base
	#warn impl
	/// added to the base materials; negative values are allowed
	///
	/// * this is applied after typegen material multiply
	var/list/typegen_materials_base_adjust
	#warn impl

	//* Visuals - Type Generation *//

	/// color of the cell's stripe
	var/typegen_visual_stripe_color
	/// color of the cell's indicator
	var/typegen_visual_indicator_color

	//* Worth / Materials *//

	/// worth multiplier
	///
	/// * set to null to say "we have no worth" (useful for infinite cells)
	/// * null behaves like 0 right now but might not later
	var/typegen_worth_multiplier = 1

/**
 * Intercepts 'use' behavior
 *
 * @return amount that could used
 */
/datum/power_cell/proc/use(obj/item/cell/cell, amount)

/**
 * Intercepts 'check' behavior
 *
 * @return if we have that amount
 */
/datum/power_cell/proc/check(obj/item/cell/cell, amount)

/**
 * Intercepts 'give' behavior
 *
 * @return amount consumed
 */
/datum/power_cell/proc/give(obj/item/cell/cell, amount)

#warn impl all
