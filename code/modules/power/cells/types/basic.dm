//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/power_cell/basic
	abstract_type = /datum/prototype/power_cell/basic
	typegen_capacity_multiplier = /datum/prototype/power_cell::typegen_capacity_multiplier * 1.0

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/basic/tier_1, /basic/tier_1, "basic-t1")
/datum/prototype/power_cell/basic/tier_1
	cell_name = "basic"
	cell_desc = "Tier 1: This one is a standard design, and performs about what you expect for a power cell."
	typegen_capacity_multiplier = /datum/prototype/power_cell/basic::typegen_capacity_multiplier * 1.0
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 200,
		/datum/prototype/material/glass::id = 75,
	)
	typegen_visual_stripe_color = "#adfff3"

GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_1/small, /power_cell/basic/tier_1/small, "powercell-basic-tier_1-small")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_1/medium, /power_cell/basic/tier_1/medium, "powercell-basic-tier_1-medium")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_1/large, /power_cell/basic/tier_1/large, "powercell-basic-tier_1-large")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_1/weapon, /power_cell/basic/tier_1/weapon, "powercell-basic-tier_1-weapon")

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/basic/tier_2, /basic/tier_2, "basic-t2")
/datum/prototype/power_cell/basic/tier_2
	cell_name = "improved"
	cell_desc = "Tier 2: This one utilizes more advanced materials in its electrolytes, allowing it to store a sizeable chunk more power than a basic cell."
	typegen_capacity_multiplier = /datum/prototype/power_cell/basic::typegen_capacity_multiplier * 1.2
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 250,
		/datum/prototype/material/glass::id = 125,
		/datum/prototype/material/copper::id = 50,
		/datum/prototype/material/gold::id = 75,
		/datum/prototype/material/silver::id = 75,
	)
	typegen_visual_stripe_color = "#005a75"

GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_2/small, /power_cell/basic/tier_2/small, "powercell-basic-tier_2-small")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_2/medium, /power_cell/basic/tier_2/medium, "powercell-basic-tier_2-medium")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_2/large, /power_cell/basic/tier_2/large, "powercell-basic-tier_2-large")
GENERATE_DESIGN_FOR_NT_AUTOLATHE(/obj/item/cell/basic/tier_2/weapon, /power_cell/basic/tier_2/weapon, "powercell-basic-tier_2-weapon")

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/basic/tier_3, /basic/tier_3, "basic-t3")
/datum/prototype/power_cell/basic/tier_3
	cell_name = "advanced"
	cell_desc = "Tier 3: This one is even more overtuned than an upgraded cell, utilizing novel crystalline lattices to improve energy densities."
	typegen_capacity_multiplier = /datum/prototype/power_cell/basic::typegen_capacity_multiplier * 1.45
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 175,
		/datum/prototype/material/glass::id = 100,
		/datum/prototype/material/copper::id = 100,
		/datum/prototype/material/gold::id = 100,
		/datum/prototype/material/silver::id = 100,
		/datum/prototype/material/diamond::id = 50,
	)
	typegen_visual_stripe_color = "#003fc6"

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_3/small, /power_cell/basic/tier_3/small, "powercell-basic-tier_3-small")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_3/medium, /power_cell/basic/tier_3/medium, "powercell-basic-tier_3-medium")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_3/large, /power_cell/basic/tier_3/large, "powercell-basic-tier_3-large")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_3/weapon, /power_cell/basic/tier_3/weapon, "powercell-basic-tier_3-weapon")

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/basic/tier_4, /basic/tier_4, "basic-t4")
/datum/prototype/power_cell/basic/tier_4
	cell_name = "superdense"
	cell_desc = "Tier 4: An ultradense power cell made from special, low-resistance alloys."
	typegen_capacity_multiplier = /datum/prototype/power_cell/basic::typegen_capacity_multiplier * 1.85
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 200,
		/datum/prototype/material/glass::id = 200,
		/datum/prototype/material/copper::id = 200,
		/datum/prototype/material/silver::id = 450,
		/datum/prototype/material/durasteel::id = 100,
		/datum/prototype/material/hydrogen/mhydrogen::id = 600,
		/datum/prototype/material/verdantium::id = 450,
	)
	typegen_visual_stripe_color = "#7451ff"

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_4/small, /power_cell/basic/tier_4/small, "powercell-basic-tier_4-small")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_4/medium, /power_cell/basic/tier_4/medium, "powercell-basic-tier_4-medium")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_4/large, /power_cell/basic/tier_4/large, "powercell-basic-tier_4-large")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_4/weapon, /power_cell/basic/tier_4/weapon, "powercell-basic-tier_4-weapon")

POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/basic/tier_5, /basic/tier_5, "basic-t5")
/datum/prototype/power_cell/basic/tier_5
	cell_name = "ultratech"
	cell_desc = "Tier 5: This indecipherable cell crams unbelievable amounts of energy \
	into a storage matrix fabricated out of exotic materials."
	typegen_capacity_multiplier = /datum/prototype/power_cell/basic::typegen_capacity_multiplier * 2.25
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 175,
		/datum/prototype/material/glass::id = 350,
		/datum/prototype/material/copper::id = 250,
		/datum/prototype/material/gold::id = 350,
		/datum/prototype/material/silver::id = 250,
		/datum/prototype/material/verdantium::id = 50,
		/datum/prototype/material/morphium::id = 300,
		/datum/prototype/material/valhollide::id = 350,
	)
	typegen_visual_stripe_color = "#ff81fd"

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_5/small, /power_cell/basic/tier_5/small, "powercell-basic-tier_5-small")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_5/medium, /power_cell/basic/tier_5/medium, "powercell-basic-tier_5-medium")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_5/large, /power_cell/basic/tier_5/large, "powercell-basic-tier_5-large")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/basic/tier_5/weapon, /power_cell/basic/tier_5/weapon, "powercell-basic-tier_5-weapon")
