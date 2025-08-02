//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network_connection
	/// persistent id (this is dumb but we need it, unfortunately)
	/// * doesn't need to be player readable; just used to model
	///   reconnects
	var/id

	/// network id
	/// * stored separately from the actual network; this allows
	///   for auto-reconnection when an unloaded network is reloaded.
	var/c_network_id
	/// operator level
	var/c_operator_level = RESEARCH_NETWORK_OPLVL_DEFAULT
	/// capability flags
	var/c_capability_flags = NONE

	/// active network entity
	var/datum/research_network/s_network
	/// active peer entity
	var/datum/s_peer
	/// are we connected?
	var/s_connected = FALSE

	/// filter design tags - whitelist
	var/list/design_tag_whitelist
	/// filter design tags - blacklist
	/// * overrides whitelist
	var/list/design_tag_blacklist

/datum/research_network_connection/New()
	SSresearch.on_connection_created(src)

/datum/research_network_connection/Destroy()
	SSresearch.on_connection_destroyed(src)
	return ..()

/**
 * gets our unique id. this should never change. used for indexing and rejoins.
 * * must be overridden on subtypes.
 */
/datum/research_network_connection/proc/get_unique_id()
	CRASH("get_unique_id not implemented")

/datum/research_network_connection/proc/reconsider_connectivity()
	#warn impl

/datum/research_network_connection/proc/check_connectivity(datum/research_network/network)
	return TRUE

/datum/research_network_connection/proc/link_network(datum/research_network/network)
	ASSERT(!s_network)
	s_network = network
	reconsider_connectivity()
	return TRUE

/datum/research_network_connection/proc/unlink_network()
	if(!s_network)
		return
	var/datum/research_network/unlinking = s_network
	s_network = null
	if(s_connected)
		on_connection_inactive(unlinking, s_peer)

/datum/research_network_connection/proc/link_peer(datum/peer)
	ASSERT(!s_peer)
	s_peer = peer
	reconsider_connectivity()
	return TRUE

/datum/research_network_connection/proc/unlink_peer()
	if(!s_peer)
		return
	var/datum/unlinking = s_peer
	s_peer = null
	if(s_connected)
		on_connection_inactive(s_network, unlinking)

/**
 * called when connectivity is established
 * * connectivity is established if connectivity can occur, and both
 *   the network and the peer exists.
 */
/datum/research_network_connection/proc/on_connection_active(datum/research_network/network, datum/peer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when connectivity is dropped
 * * connectivity is dropped if connectivity cannot occur, or
 *   if either the network or the peer is destroyed.
 */
/datum/research_network_connection/proc/on_connection_inactive(datum/research_network/network, datum/peer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * checks if the connection is still active.
 */
/datum/research_network_connection/proc/is_active()
	return s_connected

/datum/research_network_connection/proc/capability_set_flags(flags)
	var/allowed = capability_allow_edit_flags()
	c_capability_flags = (c_capability_flags & (~allowed)) | (flags & allowed)

/datum/research_network_connection/proc/capability_get_flags()
	return c_capability_flags

/datum/research_network_connection/proc/capability_allow_edit_flags()
	return ALL & ~(RESEARCH_NETWORK_CAPABILITY_SERVER)
