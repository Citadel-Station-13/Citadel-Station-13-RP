#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// The circuit boards

/obj/item/circuitboard/telesci_console
	name = T_BOARD("Telepad Control Console")
	build_path = /obj/machinery/computer/telescience
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)

/obj/item/circuitboard/telesci_pad
	name = T_BOARD("Telepad")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/telepad
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	req_components = list(
							/obj/item/ore/bluespace_crystal = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

// Bamfpads! Ported from /tg/
/obj/item/circuitboard/quantumpad
	name = T_BOARD("quantum pad")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/power/quantumpad
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4, TECH_BLUESPACE = 4)
	req_components = list(
		/obj/item/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 5)

// The Designs

/datum/design/circuit/telesci_console
	name = "Telepad Control Console"
	id = "telesci_console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/circuitboard/telesci_console
	sort_string = "HAAEA"

/datum/design/circuit/telesci_pad
	name = "Telepad"
	id = "telesci_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/telesci_pad
	sort_string = "HAAEB"

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
	id = "quantum_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/quantumpad
	sort_string = "HAAC"

/datum/design/item/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials = list(MAT_DIAMOND = 1500, MAT_PHORON = 1500)
	build_path = /obj/item/ore/bluespace_crystal/artificial
	sort_string = "HAAED"
