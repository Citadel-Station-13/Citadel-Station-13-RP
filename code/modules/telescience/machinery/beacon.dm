//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_beacon/integrated

/obj/item/bluespace_beacon/integrated/draw_power(amount)
	#warn impl

/obj/item/bluespace_beacon/integrated/ui_host(mob/user, datum/tgui_module/module)
	return loc.ui_host(arglist(args))

/obj/machinery/bluespace_beacon
	name = "teleporter beacon"
	desc = "A high-power beacon used to facilitate teleporter locks."
	#warn icon, icon state

	default_deconstruct = TOOL_CROWBAR
	default_unanchor = TOOL_WRENCH
	default_panel = TOOL_SCREWDRIVER

	/// our integrated bluespace beacon
	var/obj/item/bluespace_beacon/integrated/beacon = /obj/item/bluespace_beacon/integrated

/obj/machinery/bluespace_beacon/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()


#warn circuit

/obj/machinery/bluespace_beacon/pylon
	name = "experimental lensing beacon"
	desc = "An unreasonably expensive and fragile piece of technology used to act as a passive locator signal. While most teleportation beacons are powered, this one instead reflects pulses sent by specialized machinery to provide locking information."

