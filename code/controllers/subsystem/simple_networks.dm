//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Just a simple way for things to send / receive data
 */
SUBSYSTEM_DEF(simple_networks)
	name = "Simple Networks"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT
	// no init order for now
	// no fire priority for now

	// Simple networks
	/// id lookup to a list of devices
	var/static/list/simple_network_lookup = list()

/**
 * Returns list of devices on a simple network.
 *
 * **WARNING: LIST IS NOT A COPY FOR PERFORMANCE - DO NOT MODIFY WITHOUT COPYING.**
 */
/datum/controller/subsystem/simple_networks/proc/get_devices(id)
	return simple_network_lookup[id] || list()

/**
 * Returns list of devices on a simple network within distance of atom
 */
/datum/controller/subsystem/simple_networks/proc/get_devices_in_range(id, atom/center, range = 25)
	center = get_turf(center)
	if(!center)
		return list()
	. = list()
	for(var/atom/A in get_devices(id))
		if(get_dist(A, center) <= range)
			. += A

//* /datum API *//

/datum/proc/simple_network_register(id)
	AddElement(/datum/element/simple_network, id)

/**
 * Sends a simple network message.
 *
 * @params
 * * id - id of network to send to
 * * message - message to send or null
 * * data - arbitrary list or null
 */
/datum/proc/simple_network_send(id, message, list/data)
	var/list/devices = SSsimple_networks.get_devices(id)
	for(var/datum/D as anything in devices)
		D.simple_network_receive(id, message, data, src)

/**
 * Called on receiving a simple network message - register to these by adding the element.
 */
/datum/proc/simple_network_receive(id, message, list/data, datum/sender)
	return

//* /atom API *//

/**
 * Sends a simple network message.
 *
 * @params
 * * id - id of network to send to
 * * message - message to send or null
 * * data - arbitrary list or null
 * * range - range from the current atom, defaults to ignoring.
 */
/atom/simple_network_send(id, message, list/data, range = INFINITY)
	if(range == INFINITY)
		return ..()
	var/list/devices = SSsimple_networks.get_devices_in_range(id, src, range)
	for(var/datum/D as anything in devices)
		D.simple_network_receive(id, message, data, src)

//* Internal Element *//

/datum/element/simple_network
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 1
	var/id

/datum/element/simple_network/Attach(datum/target, id)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	src.id = id
	if(SSsimple_networks.simple_network_lookup[id])
		SSsimple_networks.simple_network_lookup[id] |= target
	else
		SSsimple_networks.simple_network_lookup[id] = list(target)

/datum/element/simple_network/Detach(datum/source)
	SSsimple_networks.simple_network_lookup[id] -= source
	if(!length(SSsimple_networks.simple_network_lookup[id]))
		SSsimple_networks.simple_network_lookup -= id
	return ..()
