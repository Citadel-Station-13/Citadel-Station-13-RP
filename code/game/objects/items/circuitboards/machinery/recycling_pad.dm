#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/recycling_pad
	name = T_BOARD("recycling pad")
	build_path = /obj/machinery/recycling_pad
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 4, TECH_POWER = 3, TECH_ENGINEERING = 5)
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 1,
	)
