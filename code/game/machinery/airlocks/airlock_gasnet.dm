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

	var/recheck_queued = FALSE

	#warn hook all

/datum/airlock_gasnet/New(obj/structure/airlock_interconnect/origin)
	if(origin)
		build(origin)

/datum/airlock_gasnet/Destroy()
	teardown()
	return ..()

/datum/airlock_gasnet/proc/queue_recheck()
	if(recheck_queued)
		return
	recheck_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(recheck)), 0)

/datum/airlock_gasnet/proc/recheck()
	recheck_queued = FALSE
	#warn impl

/**
 * expand and consume along an interconnect
 */
/datum/airlock_gasnet/proc/build(obj/structure/airlock_interconnect/source)
	var/list/obj/structure/airlock_interconnect/processing = list(source)
	var/list/processed = list()
	while(length(processing))

	#warn impl

/datum/airlock_gasnet/proc/add_interconnect(obj/structure/airlock_interconnect/connector)
	interconnects += connector

/**
 * Merge into another gasnet and delete ourselves
 */
/datum/airlock_gasnet/proc/merge_into(datum/airlock_gasnet/other)
	for(var/obj/structure/airlock_interconnect/interconnect as anything in interconnects)
		interconnect.network = other
		other.interconnects += interconnect
	interconnects.Cut()
	for(var/obj/machinery/airlock_component/component as anything in components)
		component.on_disconnect(src)
		component.network = other
		component.on_connect(other)
	other.components += components
	components.Cut()
	qdel(src)

/datum/airlock_gasnet/proc/add_machine(obj/machinery/airlock_component/component)
	#warn impl

/datum/airlock_gasnet/proc/remove_machine(obj/machinery/airlock_component/component)
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

	var/datum/gas_mixture/source = cycler?.get_mutable_gas_mixture_ref()
	var/datum/gas_mixture/sink = vent?.get_mutable_gas_mixture_ref()

	if(!source || !sink)
		return AIRLOCK_CYCLER_OP_MISSING_COMPONENT


/datum/airlock_gasnet/proc/pump_vent_to_cycler(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

	var/datum/gas_mixture/source = cycler?.get_mutable_gas_mixture_ref()
	var/datum/gas_mixture/sink = vent?.get_mutable_gas_mixture_ref()

	if(!source || !sink)
		return AIRLOCK_CYCLER_OP_MISSING_COMPONENT

/datum/airlock_gasnet/proc/pump_cycler_to_handler_waste(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

	var/datum/gas_mixture/source = cycler?.get_mutable_gas_mixture_ref()
	var/datum/gas_mixture/sink = handler?.get_waste_gas_mixture_ref()

	if(!source || !sink)
		return AIRLOCK_CYCLER_OP_MISSING_COMPONENT

/datum/airlock_gasnet/proc/pump_handler_supply_to_cycler(dt, to_pressure)
	. = AIRLOCK_CYCLER_OP_FATAL

	var/datum/gas_mixture/source = handler?.get_clean_gas_mixture_ref()
	var/datum/gas_mixture/sink = cycler?.get_mutable_gas_mixture_ref()

	if(!source || !sink)
		return AIRLOCK_CYCLER_OP_MISSING_COMPONENT

#warn impl

//* Tasks *//

/datum/airlock_task/gasnet/pump
	var/target_pressure = 0

/datum/airlock_task/gasnet/pump/vent_to_cycler

/datum/airlock_task/gasnet/pump/cycler_to_vent

/datum/airlock_task/gasnet/pump/handler_supply_to_cycler

/datum/airlock_task/gasnet/pump/cycler_to_handler_waste

#warn impl all
