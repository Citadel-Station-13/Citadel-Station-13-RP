//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/power_cell/infinite)
/datum/power_cell/infinite

/datum/power_cell/infinite
	cell_name = "fractal"
	cell_desc = "This one is unlike anything you've seen before, boasting a seemingly limitless energy output."

	typegen_visual_stripe_color = "#ffff00"

#warn new way below

/obj/item/cell/infinite/use(amount)
	return amount

/obj/item/cell/infinite/check_charge(amount)
	return TRUE

/obj/item/cell/infinite/give(amount)
	return 0
