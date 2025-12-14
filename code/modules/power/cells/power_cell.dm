//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A prototype that stores core tuning for power cells.
 *
 * ## Are you fucking insane?
 *
 * * Yes.
 *
 * ## Why?
 *
 * * Power cells being persisteed with all their data can end really badly if an
 *   admin fucks up their VV-fu.
 *   Using prototypes allows for managed storage of things like names, descs,
 *   and other fluff data.
 *
 * ## What does / doesn't this do?
 *
 * * This **does not** encapsulate behavior. Power cells themselves do that.
 *   This is just a template for common tuning parameters.
 */
/datum/prototype/power_cell
	//* Descriptors *//

	/// our cell name
	///
	/// * used for type generation
	var/cell_name = "unknown"
	/// our cell description append.
	///
	/// * used for type generation
	var/cell_desc = "Some unknown technology, probably. What is this?"

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
	/// * set to null to say "we have no worth / are invaluable" (useful for infinite cells)
	/// * null behaves like 0 right now but might not later
	var/typegen_worth_multiplier = 1

	//* Misc *//

	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for regen speed on regen cells
	/// * used for use rate on microfission
	var/c_reaction_multiplier = 1
	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for total fuel on microfission
	var/c_fuel_multiplier = 1

// TODO: serializable
