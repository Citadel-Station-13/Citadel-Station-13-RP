//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/circuitboard/machine/research_server
	/// our unique id - must be persistence stable
	var/c_id
	/// stored network connection
	var/datum/research_network_connection/c_connection

/**
 * Linked to one research network at a time.
 * * Does not use `research_network_connection`; these join entirely to the network and obey the will of the mainframe.
 */
/obj/machinery/research_server
	// TODO: NEW SPRITE PLEASE
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	/// our id
	var/id
	/// our network connection, if any
	var/datum/research_network_connection/connection
	/// active network join request, if any
	var/datum/research_network_connection_request/connection_request
	/// if network connected is active, this is our network
	var/datum/research_network/connected

	/// always join to a given network, without map mangling
	var/conf_network_autojoin_static_id

#warn impl

/obj/machinery/research_server/Initialize(mapload)
	. = ..()

/obj/machinery/research_server/Destroy()
	unlink_network()
	QDEL_NULL(network_connection_request)
	return ..()

/obj/machinery/research_server/proc/create_connection_request(datum/research_network/network)
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

/obj/machinery/research_server/proc/join_network_id(id)

/obj/machinery/research_server/proc/autojoin_network_id(id)

/obj/machinery/computer/research_console/proc/on_connection_add(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)


/obj/machinery/computer/research_console/proc/on_connection_remove(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)


/obj/machinery/computer/research_console/proc/on_connection_active(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/on_connection_inactive(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/check_network_connectivity(datum/research_network/network)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/research_server/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["network"] = network ? list(
		"id" = network.network_id,
	) : null

/obj/machinery/research_server/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("requestNetworkJoin")
			var/datum/research_network/target_network = SSresearch.get_network_by_id(params["id"])
			if(!target_network)
				return
		if("passwordNetworkJoin")
			var/datum/research_network/target_network = SSresearch.get_network_by_id(params["id"])
			if(!target_network)
				return
		if("disconnectNetwork")

/datum/research_network_connection/research_server
	c_capability_flags = RESEARCH_NETWORK_CAPABILITY_SERVER

/datum/research_network_connection/research_server/on_connection_active(datum/research_network/network, datum/peer)

/datum/research_network_connection/research_server/on_connection_inactive(datum/research_network/network, datum/peer)

