//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/regen, /regen, "regen")
/datum/prototype/power_cell/regen
	id = "regen"
	cell_name = "void"
	cell_desc = "This one is unlike anything you've seen before, able to generate energy seemingly out of nowhere."
	typegen_visual_stripe_color = "#aa00aa"

	// boost for larger cells
	c_fuel_adjust = 100 / ((6 MINUTES) / (1 SECONDS)) * 0.01
	// static regen rate
	c_reaction_adjust = 30

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/regen/fractal, /regen/fractal, "regen-fractal")
/datum/prototype/power_cell/regen/fractal
	id = "fractal"
	cell_name = "fractal"
	cell_desc = "You can't even begin to comprehend what this is, other than the fact it's out of this world and \
	making energy out of nowhere."
	typegen_visual_stripe_color = "#c79aff"

	// boost for larger cells
	c_fuel_adjust = 100 / ((3 MINUTES) / (1 SECONDS)) * 0.01
	// static regen rate
	c_reaction_adjust = 60

/obj/item/cell/regen
	// in cell units
	// * multiplied by `c_reaction_multiplier`
	// * adjusted by `c_reaction_adjust`
	var/base_regen_static = 0
	// in % of the cell's capacity
	// * multiplied by `c_fuel_multplier`
	// * adjusted by `c_fuel_adjust`
	var/base_regen_ratio = 0

/obj/item/cell/regen/Initialize()
	. = ..()
	// TODO: automated way to update when prototypes change?
	var/c_base_regen_static = cell_datum ? \
		base_regen_static * cell_datum.c_reaction_multiplier + cell_datum.c_reaction_adjust : \
		base_regen_static
	var/c_base_regen_ratio = cell_datum ? \
		base_regen_ratio * cell_datum.c_fuel_multiplier + cell_datum.c_fuel_adjust : \
		base_regen_ratio
	self_recharge = TRUE
	self_recharge_amount = c_base_regen_static + c_base_regen_ratio * 0.01 * max_charge
	START_PROCESSING(SSobj, src)

/obj/item/cell/regen/fractal
	// TODO: relore this, the generic precursor shit is boring.
	catalogue_data = list(
		/datum/category_item/catalogue/anomalous/precursor_a/alien_void_cell,
	)
