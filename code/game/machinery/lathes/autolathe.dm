//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/circuitboard/machine/lathe/autolathe
	name = T_BOARD("autolathe")
	build_path = /obj/machinery/lathe/autolathe

/obj/machinery/lathe/autolathe
	name = "autolathe"
	desc = "A versatile lathe capable of printing many objects with the right loaded designs.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	icon = 'icons/machinery/lathe/autolathe.dmi'
	icon_state = "base"
	circuit = /obj/item/circuitboard/machine/lathe/autolathe
	design_holder = /datum/design_holder/lathe/autolathe
	lathe_type = LATHE_TYPE_AUTOLATHE
	has_interface = TRUE
	active_icon_state = "active"
	print_icon_state = "print"
	paused_icon_state = "pause"
	recycle_icon_state = "load_steel"
	insert_icon_state_specific = list(
		MAT_GLASS = "load_glass",
		MAT_STEEL = "load_steel",
	)
	insert_icon_state = "load_steel"

/datum/design_holder/lathe/autolathe

/datum/design_holder/lathe/autolathe/available_ids()
	return RSdesigns.autolathe_design_ids | ..()
