//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

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

	controller = null
	handler = null
	cycler = null
	vent = null

	invalid = FALSE
	invalid_reasons = null

	for(var/obj/machinery/airlock_component/controller/c1 in components)
		if(controller)
			LAZYADD(invalid_reasons, "More than one controller in network.")
			continue
		controller = c1

	for(var/obj/machinery/airlock_component/handler/c2 in components)
		if(handler)
			LAZYADD(invalid_reasons, "More than one handler in network.")
			continue
		handler = c2

	for(var/obj/machinery/airlock_component/cycler/c3 in components)
		if(cycler)
			LAZYADD(invalid_reasons, "More than one cycler in network.")
			continue
		cycler = c3

	for(var/obj/machinery/airlock_component/vent/c4 in components)
		if(vent)
			LAZYADD(invalid_reasons, "More than one vent in network.")
			continue
		vent = c4

/**
 * expand and consume along an interconnect
 */
/datum/airlock_gasnet/proc/build(obj/structure/airlock_interconnect/source)
	var/list/obj/structure/airlock_interconnect/processing = list(source)
	var/alist/processed = alist()
	while(length(processing))
		var/obj/structure/airlock_interconnect/current = processing[length(processing)]
		--processing.len
		processed[current] = TRUE

		var/list/obj/structure/airlock_interconnect/adjacent = current.get_adjacent_interconnects()
		for(var/obj/structure/airlock_interconnect/potential as anything in adjacent)
			if(processed[potential])
				continue
			processing += potential

		if(current.network)
			if(current.network == src)
				// do nothing
			else
				// merge them
				current.network.merge_into(src)
		else
			add_interconnect(current)

/datum/airlock_gasnet/proc/add_interconnect(obj/structure/airlock_interconnect/connector)
	interconnects += connector
	for(var/obj/machinery/airlock_component/comp as anything in connector.components)
		add_machine(comp)

/datum/airlock_gasnet/proc/remove_interconnect(obj/structure/airlock_interconnect/connector)
	interconnects -= connector
	for(var/obj/machinery/airlock_component/comp as anything in connector.components)
		remove_machine(comp)

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
	if(component.network)
		if(component.network == src)
			return TRUE
		CRASH("already had network")
	components += component
	component.network = src
	component.on_connect(src)

/datum/airlock_gasnet/proc/remove_machine(obj/machinery/airlock_component/component)
	if(component.network != src)
		CRASH("mismatched network")
	components -= component
	component.network = null
	component.on_disconnect(src)

/datum/airlock_gasnet/proc/teardown(queue_rebuilds = TRUE)
	for(var/obj/structure/airlock_interconnect/interconnect as anything in interconnects)
		remove_interconnect(interconnect)

/datum/airlock_gasnet/proc/get_door_linkers() as /list
	. = list()
	for(var/obj/machinery/airlock_component/door_linker/linker in components)
		. += linker

//* cycler ops                                                               *//
//* these are on the gasnet because we currently support only one cycler,    *//
//* and this makes the API a lot more simple.                                *//
//*                                                                          *//
//* if we really need to in the future, we can make multi-cyclers a thing.   *//

/datum/airlock_gasnet/proc/pump_impl(datum/gas_mixture/airlock_air, datum/gas_mixture/peer_air, dt, target_pressure, pumping_in)
	. = AIRLOCK_CYCLER_OP_SUCCESS

	var/available_power_kj = min(cycler.pumping_power * dt, handler.power_stored)
	if(available_power_kj < 2)
		. |= AIRLOCK_CYCLER_OP_NO_POWER

	var/before_pressure = XGM_PRESSURE(airlock_air)
	var/desired_pressure_change = target_pressure - before_pressure

	var/datum/gas_mixture/source
	var/datum/gas_mixture/sink

	if(pumping_in)
		source = peer_air
		sink = airlock_air
		if(source.total_moles <= 10)
			. |= AIRLOCK_CYCLER_OP_NO_GAS
	else
		source = airlock_air
		sink = peer_air

	// we assume airlock air temperature is the dominant temperature
	var/desired_mole_transfer = (abs(desired_pressure_change) * XGM_VOLUME(airlock_air)) / (R_IDEAL_GAS_EQUATION * XGM_TEMPERATURE(airlock_air))

	var/moles_before = XGM_TOTAL_MOLES(airlock_air)
	var/power_used = xgm_pump_gas(source, sink, desired_mole_transfer, available_power_kj * 1000)
	handler.power_stored -= power_used * 0.001
	var/moles_after = XGM_TOTAL_MOLES(airlock_air)
	if(abs(moles_after - moles_before) < min(desired_mole_transfer, 3))
		. |= AIRLOCK_CYCLER_OP_HIGH_RESISTANCE

/datum/airlock_gasnet/proc/pump_cycler_to_vent(dt, to_pressure)
	cycler?.last_pump_was_out = FALSE
	vent?.last_pump_was_out = TRUE
	return pump_impl(cycler?.get_mutable_gas_mixture_ref(), vent?.get_mutable_gas_mixture_ref(), dt, to_pressure, FALSE)

/datum/airlock_gasnet/proc/pump_vent_to_cycler(dt, to_pressure)
	cycler?.last_pump_was_out = TRUE
	vent?.last_pump_was_out = FALSE
	return pump_impl(cycler?.get_mutable_gas_mixture_ref(), vent?.get_mutable_gas_mixture_ref(), dt, to_pressure, TRUE)

/datum/airlock_gasnet/proc/pump_cycler_to_handler_waste(dt, to_pressure)
	cycler?.last_pump_was_out = FALSE
	return pump_impl(cycler?.get_mutable_gas_mixture_ref(), handler?.get_waste_gas_mixture_ref(), dt, to_pressure, FALSE)

/datum/airlock_gasnet/proc/pump_handler_supply_to_cycler(dt, to_pressure)
	cycler?.last_pump_was_out = TRUE
	return pump_impl(cycler?.get_mutable_gas_mixture_ref(), handler?.get_clean_gas_mixture_ref(), dt, to_pressure, TRUE)

/datum/airlock_gasnet/proc/reset_pumping_graphics()
	cycler?.last_pump_was_out = null
	vent?.last_pump_was_out = null

//* Tasks *//

/datum/airlock_task/gasnet/pump
	var/target_pressure = 0
	var/is_into_chamber
	var/last_status

/datum/airlock_task/gasnet/pump/describe_state()
	if(!last_status)
		return "Operating Cycler"
	var/list/descriptors = list()
	for(var/i in 1 to AIRLOCK_CYCLER_OP_MAX_BIT)
		if(last_status & i)
			descriptors += global.airlock_cycler_op_desc_lookup[i]
	return "Cycler Error ([english_list(descriptors)])"

/datum/airlock_task/gasnet/pump/proc/handle_pumping_status(cycler_status)
	last_status = cycler_status

/datum/airlock_task/gasnet/pump/vent_to_cycler
	is_into_chamber = TRUE

/datum/airlock_task/gasnet/pump/vent_to_cycler/poll(dt)
	var/status = cycling.system.controller?.network?.pump_vent_to_cycler(dt, target_pressure)
	if(isnull(status))
		status = AIRLOCK_CYCLER_OP_MISSING_COMPONENT
	handle_pumping_status(status)

/datum/airlock_task/gasnet/pump/cycler_to_vent
	is_into_chamber = FALSE

/datum/airlock_task/gasnet/pump/cycler_to_vent/poll(dt)
	var/status = cycling.system.controller?.network?.pump_cycler_to_vent(dt, target_pressure)
	if(isnull(status))
		status = AIRLOCK_CYCLER_OP_MISSING_COMPONENT
	handle_pumping_status(status)

/datum/airlock_task/gasnet/pump/handler_supply_to_cycler
	is_into_chamber = TRUE

/datum/airlock_task/gasnet/pump/handler_supply_to_cycler/poll(dt)
	var/status = cycling.system.controller?.network?.pump_handler_supply_to_cycler(dt, target_pressure)
	if(isnull(status))
		status = AIRLOCK_CYCLER_OP_MISSING_COMPONENT
	handle_pumping_status(status)

/datum/airlock_task/gasnet/pump/cycler_to_handler_waste
	is_into_chamber = FALSE

/datum/airlock_task/gasnet/pump/cycler_to_handler_waste/poll(dt)
	var/status = cycling.system.controller?.network?.pump_cycler_to_handler_waste(dt, target_pressure)
	if(isnull(status))
		status = AIRLOCK_CYCLER_OP_MISSING_COMPONENT
	handle_pumping_status(status)

/datum/airlock_task/gasnet/pump/vent_or_handler_supply_to_cycler
	is_into_chamber = FALSE

/datum/airlock_task/gasnet/pump/vent_or_handler_supply_to_cycler/poll(dt)
	var/status = cycling.system.controller?.network?.pump_vent_to_cycler(dt, target_pressure)
	if(isnull(status))
		status = AIRLOCK_CYCLER_OP_MISSING_COMPONENT
	switch(status)
		if(AIRLOCK_CYCLER_OP_SUCCESS)
			// keep going
		if(AIRLOCK_CYCLER_OP_FATAL)
			// no recovery
		if(AIRLOCK_CYCLER_OP_NO_POWER)
			// no recovery
		else
			// fallback to handler
			status = cycling.system.controller?.network?.pump_handler_supply_to_cycler(dt, target_pressure)
	handle_pumping_status(status)
