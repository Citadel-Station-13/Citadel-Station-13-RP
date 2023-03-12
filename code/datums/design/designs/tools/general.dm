/datum/design/tool/cable
	identifier = "StackCableCoil"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	work = 0.1 SECONDS
	build_path = /obj/item/stack/cable_coil

/datum/design/tool/crowbar
	identifier = "ToolCrowbar"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/crowbar

/datum/design/tool/multitool
	identifier = "ToolMultitool"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/multitool

/datum/design/tool/tray_scanner
	identifier = "ToolTrayScanner"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/t_scanner

/datum/design/tool/welder
	identifier = "ToolWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool

/datum/design/tool/industrial_welder
	identifier = "ToolIndustrialWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool/largetank

/datum/design/tool/electric_welder
	identifier = "ToolElectricWelder"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/weldingtool/electric/unloaded

/datum/design/tool/screwdriver
	identifier = "ToolScrewdriver"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/screwdriver

/datum/design/tool/wirecutters
	identifier = "ToolWirecutter"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/wirecutters

/datum/design/tool/wrench
	identifier = "ToolWrench"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/wrench

/datum/design/tool/hatchet
	identifier = "ToolHatchet"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/knife/machete/hatchet

/datum/design/tool/minihoe
	identifier = "ToolMinihoe"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/material/minihoe
	materials = list(MAT_STEEL = 50)
	material_parts = list(
		"tip" = 250
	)

/datum/design/tool/prybar
	identifier = "ToolPrybar"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/tool/prybar

/datum/design/tool/flashlight
	identifier = "ToolFlashlight"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/flashlight

/datum/design/tool/maglight
	identifier = "ToolMaglight"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/flashlight/maglight

/datum/design/tool/welding_goggles
	identifier = "ToolWeldingGoggles"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/clothing/glasses/welding

/datum/design/tool/welding_mask
	identifier = "ToolWeldingMask"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/clothing/head/welding
