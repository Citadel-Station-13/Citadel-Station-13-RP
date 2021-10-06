#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	req_components = list(/obj/item/smes_coil = 1, /obj/item/stack/cable_coil = 30)

/obj/item/circuitboard/smes/construct(var/obj/machinery/power/smes/buildable/S)
	if(..(S))
		S.output_attempt = 0 //built SMES default to off

/obj/item/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/cell = 3)

/obj/item/circuitboard/ghettosmes
	name = T_BOARD("makeshift PSU")
	desc = "An APC circuit repurposed into some power storage device controller"
	build_path = /obj/machinery/power/smes/batteryrack/makeshift
	board_type = new /datum/frame/frame_types/machine
	req_components = list(/obj/item/cell = 3)

/obj/item/circuitboard/grid_checker
	name = T_BOARD("power grid checker")
	build_path = /obj/machinery/power/grid_checker
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(/obj/item/stock_parts/capacitor = 3, /obj/item/stack/cable_coil = 10)

/obj/item/circuitboard/breakerbox
	name = T_BOARD("breaker box")
	build_path = /obj/machinery/power/breakerbox
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/stock_parts/spring = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 10)

/obj/item/circuitboard/machine/rtg
	name = T_BOARD("radioisotope TEG")
	build_path = /obj/machinery/power/rtg
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/material/uranium = 10) // We have no Pu-238, and this is the closest thing to it.

/obj/item/circuitboard/machine/rtg/advanced
	name = T_BOARD("advanced radioisotope TEG")
	build_path = /obj/machinery/power/rtg/advanced
	origin_tech = list(TECH_DATA = 5, TECH_POWER = 5, TECH_PHORON = 5, TECH_ENGINEERING = 5)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/material/uranium = 10,
		/obj/item/stack/material/phoron = 5)

/obj/item/circuitboard/machine/abductor/core
	name = T_BOARD("void generator")
	build_path = /obj/machinery/power/rtg/abductor
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 8, TECH_POWER = 8, TECH_PHORON = 8, TECH_ENGINEERING = 8)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor/omni = 1)

/obj/item/circuitboard/machine/abductor/core/hybrid
	name = T_BOARD("void generator (hybrid)")
	build_path = /obj/machinery/power/rtg/abductor/hybrid
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 8, TECH_POWER = 8, TECH_PHORON = 8, TECH_ENGINEERING = 8)
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor/omni = 1,
		/obj/item/stock_parts/micro_laser/omni = 1)
