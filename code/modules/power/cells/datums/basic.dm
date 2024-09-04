//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/power_cell/basic
	abstract_type = /datum/power_cell/basic
	functional = FALSE

POWER_CELL_GENERATE_TYPES(/datum/power_cell/basic/tier_1, /basic/tier_1)
/datum/power_cell/basic/tier_1
	cell_name = "basic"
	cell_desc = "Tier 1: This one is a standard design, and performs about what you expect for a power cell."
	typegen_capacity_multiplier = /datum/power_cell/basic::typegen_capacity_multiplier * 1.0

POWER_CELL_GENERATE_TYPES(/datum/power_cell/basic/tier_2, /basic/tier_2)
/datum/power_cell/basic/tier_2
	cell_name = "upgraded"
	cell_desc = "Tier 2: This one utilizes more advanced materials in its electrolytes, allowing it to store a sizeable chunk more power than a basic cell."
	typegen_capacity_multiplier = /datum/power_cell/basic::typegen_capacity_multiplier * 1.2

POWER_CELL_GENERATE_TYPES(/datum/power_cell/basic/tier_3, /basic/tier_3)
/datum/power_cell/basic/tier_3
	cell_name = "advanced"
	cell_desc = "Tier 3: This one is even more overtuned than an upgraded cell, utilizing novel crystalline lattices to improve energy densities."
	typegen_capacity_multiplier = /datum/power_cell/basic::typegen_capacity_multiplier * 1.4

#warn new way

// POWER_CELL_GENERATE_TYPES(/obj/item/cell/basic)
// /obj/item/cell/basic
// 	materials_base = list(
// 		/datum/material/steel::id = 200,
// 		/datum/material/glass::id = 75,
// 	)

// /obj/item/cell/basic/tier_2
// 	materials_base = list(
// 		/datum/material/steel::id = 250,
// 		/datum/material/glass::id = 125,
// 		/datum/material/copper::id = 50,
// 		/datum/material/gold::id = 75,
// 		/datum/material/silver::id = 75,
// 	)

// /obj/item/cell/basic/tier_3
// 	materials_base = list(
// 		/datum/material/steel::id = 175,
// 		/datum/material/glass::id = 100,
// 		/datum/material/copper::id = 100,
// 		/datum/material/gold::id = 100,
// 		/datum/material/silver::id = 100,
// 		/datum/material/diamond::id = 50,
// 	)
