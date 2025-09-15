/datum/prototype/design/tool/cable
	id = "StackCableCoil"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	work = 0.1 SECONDS
	build_path = /obj/item/stack/cable_coil

/datum/prototype/design/tool/crowbar
	id = "ToolCrowbar"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/crowbar

/datum/prototype/design/tool/multitool
	id = "ToolMultitool"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/multitool

/datum/prototype/design/tool/tray_scanner
	id = "ToolTrayScanner"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/t_scanner

/datum/prototype/design/tool/welder
	id = "ToolWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool

/datum/prototype/design/tool/industrial_welder
	id = "ToolIndustrialWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool/largetank

/datum/prototype/design/tool/electric_welder
	id = "ToolElectricWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool/electric/unloaded

/datum/prototype/design/tool/screwdriver
	id = "ToolScrewdriver"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/screwdriver

/datum/prototype/design/tool/wirecutters
	id = "ToolWirecutter"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/wirecutters

/datum/prototype/design/tool/wrench
	id = "ToolWrench"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/wrench

/datum/prototype/design/tool/hatchet
	id = "ToolHatchet"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/material/knife/machete/hatchet
	material_autodetect_tags = list(
		"structure" = MATERIAL_TAG_BASIC_STRUCTURAL,
	)

/datum/prototype/design/tool/minihoe
	id = "ToolMinihoe"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/material/minihoe
	materials_base = list(
		/datum/prototype/material/steel = 50,
	)
	material_costs = list(
		"tip" = 250
	)
	material_constraints = list(
		"tip" = MATERIAL_CONSTRAINT_RIGID
	)
	material_autodetect_tags = list(
		"tip" = MATERIAL_TAG_BASIC_STRUCTURAL,
	)

/datum/prototype/design/tool/prybar
	id = "ToolPrybar"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/prybar

/datum/prototype/design/tool/flashlight
	id = "ToolFlashlight"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/flashlight

/datum/prototype/design/tool/maglight
	id = "ToolMaglight"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/flashlight/maglight

/datum/prototype/design/tool/welding_goggles
	id = "ToolWeldingGoggles"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/clothing/glasses/welding

/datum/prototype/design/tool/welding_mask
	id = "ToolWeldingMask"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/clothing/head/welding

/datum/prototype/design/tool/extinguisher
	id = "ToolExtinguisher"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/extinguisher

/datum/prototype/design/tool/extinguisher/mini
	id = "ToolExtinguisherMini"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/extinguisher/mini
