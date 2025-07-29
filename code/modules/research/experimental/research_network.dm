//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network
	/// our owning mainframe
	var/obj/machinery/resaerch_mainframe/mainframe
	/// linked servers
	var/list/obj/machinery/research_server/servers

	var/tmp/c_available_compute_capacity = 0
	var/tmp/datum/design_holder/research_network/c_design_holder = new
	var/tmp/datum/techweb_node_holder/research_network/c_node_holder = new


/datum/research_network/proc/rebuild()
	#warn impl

/datum/research_network/proc/request_design_holder() as /datum/design_holder

/datum/research_network/proc/request_node_holder() as /datum/techweb_node_holder

/datum/design_holder/research_network

/datum/techweb_node_holder/research_network
