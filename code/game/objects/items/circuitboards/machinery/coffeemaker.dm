#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/machine/coffeemaker
	name = T_BOARD("coffee maker")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/coffeemaker
	req_components = list(
		/obj/item/stack/material/glass = 1,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)
