//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * the simplified gasnet / control plane used for airlock handling and control
 *
 * * the gasnet itself is stateless.
 *
 * ## Linkage
 *
 * Unlike pipenets, components may never bridge another component. This means
 * components never need to worry about forcing a full rebuild when they move, only
 * when the interconnects are moved.
 *
 * Interconnects maintain a list of their components, but not other interconnects.
 * Rebuilds are designed to be entirely idempotent for call order.
 */
/datum/airlock_gasnet
	/// all interconnects
	var/list/obj/structure/airlock_interconnect/interconnects = list()
	/// all components
	var/list/obj/machinery/airlock_component/components = list()

	/// controller; there can only be one
	/// * If there is more than one, it is undefined which one will be referenced,
	///   but 'invalid' and 'invalid reasons' will be set.
	var/obj/machinery/airlock_component/controller/controller
	/// handler; there can only be one
	/// * If there is more than one, it is undefined which one will be referenced,
	///   but 'invalid' and 'invalid reasons' will be set.
	var/obj/machinery/airlock_component/handler/handler
	/// cycler; there can only be one
	/// * If there is more than one, it is undefined which one will be referenced,
	///   but 'invalid' and 'invalid reasons' will be set.
	var/obj/machinery/airlock_component/cycler/cycler
	/// vent; there can only be one
	/// * If there is more than one, it is undefined which one will be referenced,
	///   but 'invalid' and 'invalid reasons' will be set.
	var/obj/machinery/airlock_component/vent/vent

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


/datum/airlock_gasnet/proc/recheck()
	#warn impl

/**
 * expand and consume along an interconnect
 */
/datum/airlock_gasnet/proc/build(obj/structure/airlock_interconnect/source)
	#warn impl

/datum/airlock_gasnet/proc/add_interconnect(obj/structure/airlock_interconnect/connector)
	interconnects += connector

/datum/airlock_gasnet/proc/merge_into(datum/airlock_gasnet/other)
	#warn impl

/datum/airlock_gasnet/proc/add_machine(obj/machinery/airlcok_component/component)
	#warn impl

/datum/airlock_gasnet/proc/remove_machine(obj/machinery/airlcok_component/component)
	#warn impl

/datum/airlock_gasnet/proc/teardown(queue_rebuilds = TRUE)
	#warn impl

/datum/airlock_gasnet/proc/get_door_linkers() as /list
	. = list()
	for(var/obj/machinery/airlock_component/door_linker/linker in components)
		. += linker

#warn impl

//* cycler ops                                                               *//
//* these are on the gasnet because we currently support only one cycler,    *//
//* and this makes the API a lot more simple.                                *//
//*                                                                          *//
//* if we really need to in the future, we can make multi-cyclers a thing.   *//

/datum/airlock_gasnet/proc/pump_cycler_to_vent(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

/datum/airlock_gasnet/proc/pump_vent_to_cycler(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

/datum/airlock_gasnet/proc/pump_cycler_to_handler_waste(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

/datum/airlock_gasnet/proc/pump_handler_supply_to_cycler(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

#warn impl
