//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network
	/// our owning mainframe
	var/obj/machinery/resaerch_mainframe/mainframe
	/// linked servers
	var/list/obj/machinery/research_server/servers

/datum/research_network/proc/request_design_holder() as /datum/design_holder

