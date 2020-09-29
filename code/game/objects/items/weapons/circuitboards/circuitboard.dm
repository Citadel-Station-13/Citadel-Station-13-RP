//Define a macro that we can use to assemble all the circuit board names
#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name)	"circuit board (" + (name) + ")"

/obj/item/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	origin_tech = list(TECH_DATA = 2)
	density = 0
	anchored = 0
	w_class = ITEMSIZE_SMALL
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	var/build_path = null
	var/board_type = new /datum/frame/frame_types/computer
	var/list/req_components = null
	var/contain_parts = 1

//Called when the circuitboard is used to contruct a new machine.
/obj/item/circuitboard/proc/construct(var/obj/machinery/M)
	if(istype(M, build_path))
		return 1
	return 0

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if(istype(M, build_path))
		return 1
	return 0

//Should be called from the constructor of any machine to automatically populate the default parts
/obj/item/circuitboard/proc/apply_default_parts(var/obj/machinery/M)
	if(!istype(M))
		return
	if(!req_components)
		return
	M.component_parts = list()
	for(var/comp_path in req_components)
		var/comp_amt = req_components[comp_path]
		if(!comp_amt)
			continue

		if(ispath(comp_path, /obj/item/stack))
			M.component_parts += new comp_path(contain_parts ? M : null, comp_amt)
		else
			for(var/i in 1 to comp_amt)
				M.component_parts += new comp_path(contain_parts ? M : null)
	return

// Virgo specific circuit boards!

// Board for the parts lathe in partslathe.dm
/obj/item/circuitboard/partslathe
	name = T_BOARD("parts lathe")
	build_path = /obj/machinery/partslathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/console_screen = 1)

// Board for the algae oxygen generator in algae_generator.dm
/obj/item/circuitboard/algae_farm
	name = T_BOARD("algae oxygen generator")
	build_path = /obj/machinery/atmospherics/binary/algae_farm
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/console_screen = 1)

// Board for the thermal regulator in airconditioner_vr.dm
/obj/item/circuitboard/thermoregulator
	name = T_BOARD("thermal regulator")
	build_path = /obj/machinery/power/thermoregulator
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/stock_parts/capacitor/super = 3)

// Board for the bomb tester in bomb_tester_vr.dm
/obj/item/circuitboard/bomb_tester
	name = T_BOARD("explosive effect simulator")
	build_path = /obj/machinery/bomb_tester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin/adv = 1,
							/obj/item/stock_parts/scanning_module = 5)

// Board for the timeclock terminal in timeclock_vr.dm
/obj/item/circuitboard/timeclock
	name = T_BOARD("timeclock")
	build_path = /obj/machinery/computer/timeclock
	board_type = new /datum/frame/frame_types/timeclock_terminal
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

// Board for the ID restorer in id_restorer_vr.dm
/obj/item/circuitboard/id_restorer
	name = T_BOARD("ID restoration console")
	build_path = /obj/machinery/computer/id_restorer
	board_type = new /datum/frame/frame_types/id_restorer
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
