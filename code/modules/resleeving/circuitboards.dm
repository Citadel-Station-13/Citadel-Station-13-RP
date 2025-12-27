#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

#warn all

/obj/item/circuitboard/transhuman_clonepod
	name = T_BOARD("grower pod")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/resleeving/body_printer/grower_pod
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/transhuman_synthprinter
	name = T_BOARD("SynthFab 3000")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/resleeving/body_printer/synth_fab
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 2)

/obj/item/circuitboard/transhuman_resleever
	name = T_BOARD("resleeving pod")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/resleeving/resleeving_pod
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/resleeving_control
	name = T_BOARD("resleeving control console")
	build_path = /obj/machinery/computer/resleeving
	origin_tech = list(TECH_DATA = 5)

#warn replace these with design macros

/datum/prototype/design/circuit/clonecontrol
	design_name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/cloning

/datum/prototype/design/circuit/clonepod
	design_name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/clonepod

/datum/prototype/design/circuit/transhuman_clonepod
	design_name = "grower pod"
	id = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod

/datum/prototype/design/circuit/transhuman_synthprinter
	design_name = "SynthFab 3000"
	id = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter

/datum/prototype/design/circuit/transhuman_resleever
	design_name = "Resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever

// Resleeving

/datum/prototype/design/circuit/resleeving_control
	design_name = "Resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control
