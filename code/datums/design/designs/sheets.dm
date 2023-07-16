/datum/design/sheet
	abstract_type = /datum/design/sheet

/datum/design/sheet/reinforced_glass
	id = "SheetReinforcedGlass"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials = list(
		MAT_STEEL = 1000,
		MAT_GLASS = 2000,
	)
	build_path = /obj/item/stack/material/glass/reinforced
	work = 0.2 SECONDS

/datum/design/sheet/metal_rods
	id = "SheetSteelRods"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials = list(
		MAT_STEEL = 1000
	)
	build_path = /obj/item/stack/rods
	work = 0.1 SECONDS
