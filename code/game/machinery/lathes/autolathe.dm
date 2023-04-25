/obj/machinery/lathe/autolathe
	#warn sprite
	design_holder = /datum/design_holder/autolathe
	lathe_type = LATHE_TYPE_AUTOLATHE
	has_interface = TRUE

/datum/design_holder/autolathe

/datum/design_holder/autolathe/available_ids()
	return SSresearch.autolathe_design_ids | ..()

#warn impl all
