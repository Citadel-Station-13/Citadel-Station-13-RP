//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network_connection
	/// research network
	var/datum/research_network/network
	/// operator level
	var/c_operator_level
	/// capability flags
	var/c_capability_flags
	/// filter design tags - whitelist
	var/list/design_tag_whitelist
	/// filter design tags - blacklist
	/// * overrides whitelist
	var/list/design_tag_blacklist

/datum/research_network_connection/New(datum/research_network/network)
