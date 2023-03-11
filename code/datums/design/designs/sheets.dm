/datum/design/sheet
	abstract_type = /datum/design/sheet

/datum/design/sheet/reinforced_glass
	identifier = "SheetReinforcedGlass"
	materials = list(
		MAT_STEEL = 1000,
		MAT_GLASS = 2000,
	)
	build_path = /obj/item/stack/material/glass/reinforced
	work = 0.2 SECONDS

/datum/design/sheet/metal_rods
	identifier = "SheetSteelRods"
	materials = list(
		MAT_STEEL = 1000
	)
	build_path = /obj/item/stack/rods
	work = 0.1 SECONDS
