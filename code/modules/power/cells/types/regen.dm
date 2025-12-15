//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/regen, /regen, "regen")
/datum/prototype/power_cell/regen
	cell_name = "void"
	cell_desc = "This one is unlike anything you've seen before, able to generate energy seemingly out of nowhere."
	typegen_visual_stripe_color = "#aa00aa"

	// ~15 seconds per laser shot for a weapon cell.
	c_fuel_adjust = 0.01 * (2 / 3)

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/regen/fractal, /regen/fractal, "fractal")
/datum/prototype/power_cell/regen/fractal
	cell_name = "fractal"
	cell_desc = "You can't even begin to comprehend what this is, other than the fact it's out of this world and \
	making energy out of nowhere."
	typegen_visual_stripe_color = "#c79aff"

	// ~7.5 seconds per laser shot for a weapon cell.
	c_fuel_adjust = 0.02 * (2 / 3)

/obj/item/cell/regen
	// in cell units
	// * multiplied by `c_reaction_multiplier`
	// * adjusted by `c_reaction_adjust`
	var/base_regen_static = 0
	// in % of the cell's capacity
	// * multiplied by `c_fuel_multplier`
	// * adjusted by `c_fuel_adjust`
	var/base_regen_percent = 0

/obj/item/cell/regen/Initialize()


#warn impl

#warn use power_cell datum vars
