//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * provisioned invite with a given passkey
 */
/datum/research_network_invite
	/// username - **immutable once created**
	var/username
	/// passkey
	var/passkey
	/// joining oplvl
	var/join_oplvl
	/// joining capability flags
	var/join_capability
	/// design tag whitelist
	/// * lazy list
	var/list/design_tag_whitelist
	/// design tag blacklist
	/// * lazy list
	var/list/design_tag_blacklist

/datum/research_network_invite/New(username)
	src.username = username

/datum/research_network_invite/proc/create_connection(datum/research_network/network) as /datum/research_network_connection
	var/datum/research_network_connection/conn = new
	conn.c_network_id = network.id
	conn.c_operator_level = join_oplvl
	conn.c_capability_flags = join_capability
	conn.design_tag_blacklist = design_tag_blacklist
	conn.design_tag_whitelist = design_tag_whitelist
	return conn
