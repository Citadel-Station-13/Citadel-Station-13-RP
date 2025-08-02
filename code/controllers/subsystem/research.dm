//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(research)
	name = "Research"
	subsystem_flags = SS_NO_INIT

	/// k-v list id to network
	//  TODO: recover() logic
	var/static/list/network_lookup = list()
	/// loaded connections by id
	/// * used to restore connection post-failure
	var/static/list/connection_lookup = list()

	var/list/datum/research_network/ticking_currentrun

/datum/controller/subsystem/research/fire(resumed)
	if(!resumed)
		ticking_currentrun = list()
		for(var/id in network_lookup)
			ticking_currentrun += network_lookup[id]
	var/dt = nominal_dt_s
	while(length(ticking_currentrun))
		var/datum/research_network/ticking = ticking_currentrun[length(ticking_currentrun)]
		ticking_currentrun.len--
		ticking.process(dt)

/datum/controller/subsystem/research/proc/register_network(datum/research_network/network)
	if(network_lookup[network.network_id])
		stack_trace("network id collision on [network.network_id]")
		return FALSE
	network_lookup[network.network_id] = network
	return TRUE

/datum/controller/subsystem/research/proc/unregister_network(datum/research_network/network)
	network_lookup -= network.network_id
	return TRUE

/datum/controller/subsystem/research/proc/get_network_by_id(id)
	return network_lookup[id]

/datum/controller/subsystem/research/proc/on_connection_created(datum/research_network_connection/connection)

/datum/controller/subsystem/research/proc/on_connection_destroyed(datum/research_network_connection/connection)
