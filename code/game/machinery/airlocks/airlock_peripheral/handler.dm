//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/machinery/airlock_peripheral/handler
	name = "airlock handler"
	desc = "A set of underfloor machinery used to interface with an atmospherics network."
	#warn sprite

	/// conencted pipenet
	var/datum/airlock_pipenet/network

#warn impl
