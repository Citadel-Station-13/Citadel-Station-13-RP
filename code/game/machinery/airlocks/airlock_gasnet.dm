//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * the simplified gasnet used for airlock handling
 *
 * for modularity / sake of not bloating things, this system is intentionally
 * separate from the wirenet and pipenet APIs, which are
 * used for datanet/conduits/powernets and atmospherics respectively
 *
 * here's the general lifecycle of airlock handling:
 *
 * * airlock_handler will draw power from grid, and also handle gas operations on standalone buffers independently
 */
/datum/airlock_gasnet
	/// interconnects
	var/list/obj/structure/airlock_interconnect/interconnects = list()
	/// handlers
	var/list/obj/machinery/airlock_peripheral/gasnet/handler/handlers = list()
	/// cyclers
	var/list/obj/machinery/airlock_peripheral/gasnet/cycler/cyclers = list()
	/// vents
	var/list/obj/machinery/airlock_peripheral/gasnet/vent/vents = list()

	/// total power storage in kj
	var/power_capacity = 0
	/// total power stored in kj
	var/power_stored = 0

	/// total handler pumping power in kw; used to handle our buffer reshuffling
	var/pumping_power = 0

	/// injection buffer
	var/datum/gas_mixture/injection_buffer
	/// buffer for dumping out of handlers / vents; this should be waste gas.
	var/datum/gas_mixture/dumping_buffer

/datum/airlock_gasnet/New(obj/structure/airlock_interconnect/origin)
	if(origin)
		build(origin)

/datum/airlock_gasnet/Destroy()
	teardown()
	return ..()

//* Networking *//

/**
 * expand and consume along an interconnect
 */
/datum/airlock_gasnet/proc/build(obj/structure/airlock_interconnect/source)
	#warn impl

/datum/airlock_gasnet/proc/add_interconnect(obj/structure/airlock_interconnect/connector)
	interconnects += connector

/datum/airlock_gasnet/proc/merge_into(datum/airlock_gasnet/other)
	#warn impl

/datum/airlock_gasnet/proc/add_machine(obj/machinery/airlock_peripheral/peripheral)
	#warn impl

/datum/airlock_gasnet/proc/teardown(queue_rebuilds = TRUE)
	#warn impl

//* Reconcile / Operations *//

/// These are on /datum/airlock_gasnet
/// because it didn't make sense to put it on the controller
/// the tl;dr is this is technically a generic 'miniature-atmospherics'
/// gasnet system.
///
/// I'm okay with people using airlock gasnets for their own purposes, therefore.
/// You just need to understand what you're doing.



#warn impl

