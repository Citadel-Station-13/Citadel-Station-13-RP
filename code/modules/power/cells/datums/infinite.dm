//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/power_cell/infinite, /infinite, "infinite")
/datum/power_cell/infinite
	cell_name = "fractal"
	cell_desc = "This one is unlike anything you've seen before, boasting a seemingly limitless energy output."

	typegen_visual_stripe_color = "#ffff00"
	typegen_worth_multiplier = null

	functional = TRUE

/datum/power_cell/infinite/use(obj/item/cell/cell, amount)
	return amount

/datum/power_cell/infinite/check(obj/item/cell/cell, amount)
	return TRUE

/datum/power_cell/infinite/give(obj/item/cell/cell, amount)
	return 0
