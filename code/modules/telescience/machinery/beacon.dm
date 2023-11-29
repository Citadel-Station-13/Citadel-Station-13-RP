//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_beacon/integrated

/obj/item/bluespace_beacon/integrated/draw_power(amount)
	#warn impl

/obj/machinery/bluespace_beacon
	#warn name, desc, icon, icon state

	default_deconstruct = TOOL_CROWBAR
	default_unanchor = TOOL_WRENCH
	default_panel = TOOL_SCREWDRIVER

	/// our integrated bluespace beacon
	var/obj/item/bluespace_beacon/beacon

/obj/machinery/bluespace_beacon/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()


#warn circuit

/obj/machinery/bluespace_beacon/pylon
	name = "experimental lensing beacon"
	desc = "An unreasonably expensive and fragile piece of technology used to act as a passive locator signal. While most teleportation beacons are powered, this one instead reflects pulses sent by specialized machinery to provide locking information."

