//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network
	/// network ID
	/// TODO: persistence-stable if randomgen!
	#warn impl
	var/network_id
	/// network passkey
	/// * things need passkey or click-to-allow to join
	/// * null lets anything join
	var/network_passkey

	/// join requests (exonet protected setup, legally distinct from the router push button irl)
	/// * lazy list
	#warn impl
	var/list/datum/research_network_join_request/join_requests

	/// our owning mainframe
	var/obj/machinery/research_mainframe/mainframe
	/// linked servers
	var/list/obj/machinery/research_server/servers

	var/tmp/c_available_compute_capacity = 0
	var/tmp/datum/design_holder/research_network/c_design_holder = new
	var/tmp/datum/techweb_node_holder/research_network/c_node_holder = new


/datum/research_network/proc/rebuild()
	#warn impl

/datum/research_network/proc/on_server_join(obj/machinery/research_server/server)
	return

/datum/research_network/proc/on_server_leave(obj/machinery/research_server/server)
	return

/datum/research_network/proc/on_mainframe_associate(obj/machinery/research_mainframe/mainframe)
	return

/datum/research_network/proc/on_mainframe_disassociate(obj/machinery/research_mainframe/mainframe)
	return

/datum/research_network/proc/request_design_holder() as /datum/design_holder
	return c_design_holder

/datum/research_network/proc/request_node_holder() as /datum/techweb_node_holder
	return c_node_holder

/datum/design_holder/research_network

/datum/techweb_node_holder/research_network
