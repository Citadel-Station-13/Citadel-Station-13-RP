/obj/item/circuitboard/machine/lathe/medi_mini
	name = T_BOARD("medical MiniLathe")
	build_path = /obj/machinery/lathe/medical

/obj/machinery/lathe/medical
	name = "medical MiniLathe"
	desc = "A standard minilathe, this one seems to print medical consumables."
	lathe_type = LATHE_TYPE_AUTOLATHE

	has_interface = TRUE

	icon = 'icons/machinery/lathe/microlathe.dmi'
	active_icon_state = "active"
	print_icon_state = "print"
	paused_icon_state = "pause"

	idle_power_usage = POWER_USAGE_LATHE_IDLE / 2
	active_power_usage = POWER_USAGE_LATHE_ACTIVE_SCALE(1) / 2
	circuit = /obj/item/circuitboard/machine/lathe/medi_mini
	design_holder = /datum/design_holder/lathe/medi_mini_lathe

/datum/design_holder/lathe/medi_mini_lathe/available_ids()
	return SSresearch.medical_mini_design_ids | ..()

