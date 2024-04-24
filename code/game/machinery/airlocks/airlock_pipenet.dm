//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * the simplified pipenet used for airlock handling
 *
 * here's the general lifecycle of airlock handling:
 *
 * * airlock_handler will draw power from grid, and also handle gas operations on standalone buffers independently
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

	/// total handler pumping power in kw; used to handle our buffer reshuffling
	var/pumping_power = 0

	/// temperature of gas buffers
	var/air_buffer_temperature = TCMB
	/// gas buffer; gasid to moles
	var/list/air_buffer = list()

	/// buffer for dumping out of handlers / vents; this should be waste gas.
	var/datum/gas_mixture/dumping_buffer

//* Reconcile / Operations *//

/// These are on /datum/airlock_pipenet
/// because it didn't make sense to put it on the controller
/// the tl;dr is this is technically a generic 'miniature-atmospherics'
/// pipenet system.
///
/// I'm okay with people using airlock pipenets for their own purposes, therefore.
/// You just need to understand what you're doing.



#warn impl

