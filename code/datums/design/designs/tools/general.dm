/datum/design/tool/cable
	identifier = "StackCableCoil"
	build_path = /obj/item/stack/cable_coil

	#warn impl?
	/*
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits
	*/

/datum/design/tool/crowbar
	identifier = "ToolCrowbar"
	build_path = /obj/item/tool/crowbar

/datum/design/tool/multitool
	identifier = "ToolMultitool"
	build_path = /obj/item/tool/multitool

/datum/design/tool/tray_scanner
	identifier = "ToolTrayScanner"
	build_path = /obj/item/t_scanner

/datum/design/tool/welder
	identifier = "ToolWelder"
	build_path = /obj/item/weldingtool

/datum/design/tool/industrial_welder
	identifier = "ToolIndustrialWelder"
	build_path = /obj/item/weldingtool/largetank

/datum/design/tool/electric_welder
	identifier = "ToolElectricWelder"
	build_path = /obj/item/weldingtool/electric/unloaded

/datum/design/tool/screwdriver
	identifier = "ToolScrewdriver"
	build_path = /obj/item/tool/screwdriver

/datum/design/tool/wirecutters
	identifier = "ToolWirecutter"
	build_path = /obj/item/tool/wirecutters

/datum/design/tool/wrench
	identifier = "ToolWrench"
	build_path = /obj/item/tool/wrench

/datum/design/tool/hatchet
	identifier = "ToolHatchet"
	build_path = /obj/item/knife/machete/hatchet

/datum/design/tool/minihoe
	identifier = "ToolMinihoe"
	build_path = /obj/item/material/minihoe
	materials = list(MAT_STEEL = 50)
	material_parts = list(
		"tip" = 250
	)

/datum/design/tool/prybar
	identifier = "ToolPrybar"
	build_path = /obj/item/tool/prybar

/datum/design/tool/flashlight
	identifier = "ToolFlashlight"
	build_path = /obj/item/flashlight

/datum/design/tool/maglight
	identifier = "ToolMaglight"
	build_path = /obj/item/flashlight/maglight
