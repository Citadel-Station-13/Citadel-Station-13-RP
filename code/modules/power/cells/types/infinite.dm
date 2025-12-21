//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/infinite, /infinite, "infinite")
/datum/prototype/power_cell/infinite
	cell_name = "fractal"
	cell_desc = "This one is unlike anything you've seen before, boasting a seemingly limitless energy output."

	typegen_visual_stripe_color = "#ffff00"
	typegen_worth_multiplier = null

/obj/item/cell/infinite/use(amount)
	return amount

/obj/item/cell/infinite/give(amount, force)
	return 0

/obj/item/cell/infinite/check_charge(amount)
	return TRUE

/obj/item/cell/infinite/amount_missing()
	return 0

/obj/item/cell/infinite/fully_charged()
	return TRUE
