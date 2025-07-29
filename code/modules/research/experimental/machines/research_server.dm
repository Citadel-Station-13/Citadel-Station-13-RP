//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Linked to one research network at a time.
 * * Does not use `research_network_connection`; these join entirely to the network and obey the will of the mainframe.
 */
/obj/machinery/research_server
	/// linked network
	/// * later on we'll use network system if we come up with one that doesn't suck;
	///   for now it can link to any mainframe in the same /map
	var/datum/research_network/network

	/// always join to a given network, without map mangling
	var/conf_network_autojoin_static_id

#warn impl

/obj/machinery/research_server/Initialize(mapload)
	. = ..()

/obj/machinery/research_server/Destroy()
	. = ..()

/obj/machinery/research_server/proc/link_network(datum/research_network/network)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(src.network)
		if(src.network == network)
			return
		unlink_network()
	src.network = network
	LAZYADD(network.servers, src)
	if(!src.network)
		return
	network.on_server_join(src)
	on_join_network(network)

/obj/machinery/research_server/proc/unlink_network()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!network)
		return
	var/datum/research_network/leaving = network
	LAZYREMOVE(network.servers, src)
	network = null
	leaving.on_server_leave(src)
	on_leave_network(leaving)

/obj/machinery/research_server/proc/on_join_network(datum/research_network/network)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/research_server/proc/on_leave_network(datum/research_network/network)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/research_server/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
