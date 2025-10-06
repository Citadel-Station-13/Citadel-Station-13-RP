/datum/prototype/design/sheet
	abstract_type = /datum/prototype/design/sheet
	category = DESIGN_CATEGORY_ENGINEERING

/datum/prototype/design/sheet/reinforced_glass
	id = "SheetReinforcedGlass"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials_base = list(
		/datum/prototype/material/steel = 1000,
		/datum/prototype/material/glass = 2000,
	)
	build_path = /obj/item/stack/material/glass/reinforced
	work = 0.2 SECONDS

/datum/prototype/design/sheet/metal_rods
	id = "SheetSteelRods"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials_base = list(
		/datum/prototype/material/steel = 1000
	)
	build_path = /obj/item/stack/rods
	work = 0.1 SECONDS
