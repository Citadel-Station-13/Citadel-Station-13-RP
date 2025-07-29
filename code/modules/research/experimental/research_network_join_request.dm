//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network_join_request
	/// requesting entity name
	var/r_name
	/// request message
	var/r_message
	/// weakref to requester
	var/datum/weakref/r_requester_weakref
	/// requesting network
	var/datum/research_network/r_requested_network

	/// requesting capability flags
	var/r_request_capabilities
	/// requesting

/datum/research_network_join_request/New(datum/research_network/network, datum/requester)

/datum/research_network_join_request/Destroy()
