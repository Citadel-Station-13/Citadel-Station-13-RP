/obj/item/circuitboard/tesla_coil
	name = T_BOARD("tesla coil")
	build_path = /obj/machinery/power/tesla_coil
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	req_components = list(/obj/item/stock_parts/capacitor = 1)

/datum/design/circuit/tesla_coil
	name = "Machine Design (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "CircuitTeslaCoil"
	build_path = /obj/item/circuitboard/tesla_coil
	req_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)

/obj/item/circuitboard/grounding_rod
	name = T_BOARD("grounding rod")
	build_path = /obj/machinery/power/grounding_rod
	board_type = new /datum/frame/frame_types/machine
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list()

/datum/design/circuit/grounding_rod
	name = "Machine Design (Grounding Rod)"
	desc = "The circuit board for a grounding rod."
	id = "CircuitGroundingRod"
	build_path = /obj/item/circuitboard/grounding_rod
	req_tech = list(TECH_MAGNET = 2, TECH_POWER = 2)
