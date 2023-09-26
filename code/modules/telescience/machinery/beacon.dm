//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/bluespace_beacon
	#warn name, desc, icon, icon state

	allow_deconstruct = TRUE
	allow_unanchor = TRUE

	/// our internal, actual beacon. this saves us needing to duplicate code.
	var/obj/item/bluespace_beacon/beacon

#warn circuit

/obj/machinery/bluespace_beacon/pylon
	name = "experimental lensing beacon"
	desc = "An unreasonably expensive and fragile piece of technology used to act as a passive locator signal. While most teleportation beacons are powered, this one instead reflects pulses sent by specialized mahcinery to provide locking information."

