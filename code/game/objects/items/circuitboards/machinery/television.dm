#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/television
	name = T_BOARD("television")
	build_path = /obj/machinery/television
	board_type = new /datum/frame/frame_types/machine
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/console_screen = 1
	)
