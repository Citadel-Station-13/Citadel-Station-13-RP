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
	// TODO: make sure these all apply if the prototype updates

	/// our cell name
	///
	/// * used for type generation
	var/cell_name = "unknown"
	/// our cell description append.
	///
	/// * used for type generation
	var/cell_desc = "Some unknown technology, probably. What is this?"

	//* Capacity - Type Generation *//
	// TODO: make sure these all apply if the prototype updates

	/// * automatically set via define / typegen
	var/typegen_capacity_multiplier = 1
	/// * automatically set via define / typegen
	/// * compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_small = 1 * POWER_CELL_CAPACITY_MULTIPLIER_SMALL
	/// * automatically set via define / typegen
	/// * compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_medium = 1 * POWER_CELL_CAPACITY_MULTIPLIER_MEDIUM
	/// * automatically set via define / typegen
	/// * compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_large = 1 * POWER_CELL_CAPACITY_MULTIPLIER_LARGE
	/// * automatically set via define / typegen
	/// * compounded with [typegen_capacity_multiplier]
	var/typegen_capacity_multiplier_weapon = 1 * POWER_CELL_CAPACITY_MULTIPLIER_WEAPON

	//* Materials - Type Generation *//
	// TODO: make sure these all apply if the prototype updates

	/// * automatically set via define / typegen
	var/typegen_material_multiply = 1
	/// * automatically set via define / typegen
	/// * compounded with [typegen_material_multiply]
	var/typegen_material_multiply_small = 1
	/// * automatically set via define / typegen
	/// * compounded with [typegen_material_multiply]
	var/typegen_material_multiply_medium = 7.5
	/// * automatically set via define / typegen
	/// * compounded with [typegen_material_multiply]
	var/typegen_material_multiply_large = 15
	/// * automatically set via define / typegen
	/// * compounded with [typegen_material_multiply]
	var/typegen_material_multiply_weapon = 2.5

	/// sets base materials; negative values are allowed
	/// * this is keyed as ids, not instances, of materials! materials are
	///   resolved at init time.
	/// * this is applied before typegen material multiply
	var/list/typegen_materials_base
	/// added to the base materials; negative values are allowed
	/// * this is keyed as ids, not instances, of materials! materials are
	///   resolved at init time.
	/// * this is applied after typegen material multiply
	var/list/typegen_materials_base_adjust

	//* Size - Type Generation *//
	// TODO: make sure these all apply if the prototype updates

	var/typegen_w_class_small = WEIGHT_CLASS_SMALL
	var/typegen_w_class_weapon = WEIGHT_CLASS_NORMAL
	var/typegen_w_class_medium = WEIGHT_CLASS_NORMAL
	var/typegen_w_class_large = WEIGHT_CLASS_BULKY

	var/typegen_w_volume_small = WEIGHT_VOLUME_TINY
	var/typegen_w_volume_weapon = WEIGHT_VOLUME_SMALL
	var/typegen_w_volume_medium = WEIGHT_VOLUME_NORMAL
	var/typegen_w_volume_large = WEIGHT_VOLUME_BULKY

	//* Visuals - Type Generation *//
	// TODO: make sure this applies if the prototype updates

	/// color of the cell's stripe
	var/typegen_visual_stripe_color
	/// color of the cell's indicator
	var/typegen_visual_indicator_color

	//* Worth / Materials *//

	// TODO: make sure these all apply if the prototype updates
	var/typegen_worth_base_small = 10
	var/typegen_worth_base_medium = 30
	var/typegen_worth_base_large = 40
	var/typegen_worth_base_weapon = 75
	/// worth multiplier
	///
	/// * set to null to say "we have no worth / are invaluable" (useful for infinite cells)
	/// * null behaves like 0 right now but might not later
	var/typegen_worth_multiplier = 1

	//* Misc *//

	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for base regen speed in cell units on regen cells
	/// * used for reaction rate on microfission (cell units used per tick to regen)
	var/c_reaction_multiplier = 1
	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for base regen speed in cell units on regen cells
	/// * used for reaction rate on microfission (cell units used per tick to regen)
	var/c_reaction_adjust = 0
	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for percent regen speed on regen cells
	/// * used for total cell units over lifetime (fuel) on microfission
	var/c_fuel_multiplier = 1
	/// for subtypes that have reactions, as a tuning variable
	///
	/// known integrations:
	/// * used for percent regen speed on regen cells
	/// * used for total cell units over lifetime (fuel) on microfission
	var/c_fuel_adjust = 0

// TODO: serializable
