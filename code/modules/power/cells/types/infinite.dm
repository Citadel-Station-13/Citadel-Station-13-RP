//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

POWER_CELL_GENERATE_TYPES(/obj/item/cell/infinite)
/obj/item/cell/infinite
	cell_name = "fractal"
	cell_desc = "This one is unlike anything you've seen before, boasting a seemingly limitless energy output."

/obj/item/cell/infinite/use(amount)
	return amount

/obj/item/cell/infinite/check_charge(amount)
	return TRUE

/obj/item/cell/infinite/give(amount)
	return 0
