/**
 *! Magma Pump Components
 *? NOTE: Comment these out after the event, or else they'll be constructable and confuse people.
 */
/obj/item/circuitboard/magma_pump
	name = T_BOARD("magma pump")
	build_path = /obj/machinery/magma_pump
	board_type = new /datum/frame/frame_types/magma_pump
	origin_tech = list(TECH_MAGNET = 9, TECH_ENGINEERING = 9, TECH_MATERIAL = 9)
	req_components = list(
		/obj/item/stack/material/durasteel = 5,
		/obj/item/stack/material/glass/phoronrglass = 2,
		/obj/item/stock_parts/capacitor/hyper = 2,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/gear = 5,
		/obj/item/stock_parts/motor = 5,
		/obj/item/stock_parts/scanning_module/hyper = 1,
	)

/datum/frame/frame_types/magma_pump
	name = "Magma Pump"
	frame_class = FRAME_CLASS_MACHINE

/**
 *! Magma Reservoir Components
 *? NOTE: Comment these out after the event, or else they'll be constructable and confuse people.
 */
/obj/item/circuitboard/magma_reservoir
	name = T_BOARD("magma reservoir")
	build_path = /obj/machinery/magma_reservoir
	board_type = new /datum/frame/frame_types/magma_reservoir
	origin_tech = list(TECH_MAGNET = 9, TECH_ENGINEERING = 9, TECH_MATERIAL = 9)
	req_components = list(
		/obj/item/stack/material/durasteel = 5,
		/obj/item/stack/material/glass/phoronrglass = 5,
		/obj/item/stock_parts/capacitor/hyper = 2,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/matter_bin/hyper = 5,
		/obj/item/stock_parts/motor = 2,
		/obj/item/stock_parts/scanning_module/hyper = 1,
	)

/datum/frame/frame_types/magma_reservoir
	name = "Magma Reservoir"
	frame_class = FRAME_CLASS_MACHINE
