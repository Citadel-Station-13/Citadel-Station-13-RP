//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * interface nodes of airlock networks
 * they handle the buffering of gas and power.
 */
/obj/machinery/airlock_peripheral/handler
	name = "airlock handler"
	desc = "A set of underfloor machinery used to interface with an atmospherics and power network."
	#warn sprite

	/// conencted pipenet
	var/datum/airlock_pipenet/network

	/// power storage in kilojoules
	var/power_storage = 1000
	/// power draw in kilowatts
	var/power_draw = 75

#warn impl
