//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * the simplified pipenet used for airlock handling
 */
/datum/airlock_pipenet
	/// interconnects
	var/list/obj/structure/airlock_interconnect/interconnects = list()
	/// handlers
	var/list/obj/machinery/airlock_peripheral/handler/handlers = list()
	/// cyclers
	var/list/obj/machinery/airlock_peripheral/cycler/cyclers = list()
	/// vents
	var/list/obj/machinery/airlock_peripheral/vent/vents = list()

	/// total power storage in kj
	var/power_capacity = 0
	/// total power stored in kj
	var/power_stored = 0


#warn impl

