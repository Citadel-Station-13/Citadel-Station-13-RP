//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * the simplified gasnet / control plane used for airlock handling and control
 *
 * * the gasnet itself is stateless.
 */
/datum/airlock_gasnet
	/// all interconnects
	var/list/obj/structure/airlock_interconnect/interconnects = list()
	/// all components
	var/list/obj/machinery/airlock_component/components = list()

	/// controller; there can only be one
	var/obj/machinery/airlock_component/controller/controller
	/// handler; there can only be one
	var/obj/machinery/airlock_component/handler/handler
	/// cycler; there can only be one
	var/obj/machinery/airlock_component/cycler/cycler
	/// vent; there can only be one
	var/obj/machinery/airlock_component/vent/vent

	/// doors
	var/list/obj/machinery/airlock_component/door_linker/doors

	/// invalid setup
	var/invalid = FALSE
	/// invalid setup reasons
	/// * as plaintext
	var/list/invalid_reasons

	#warn hook all

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

