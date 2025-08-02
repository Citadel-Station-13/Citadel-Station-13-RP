//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_network_connection_request
	/// requesting entity name
	var/r_name
	/// request message
	var/r_message
	/// requesting peer
	var/datum/r_peer
	/// requesting network
	var/datum/research_network/r_network

	/// requesting capability flags
	var/r_request_capabilities = NONE

	/// timeout in seconds, if any
	var/timeout
	/// when were we initiated? only set once started
	var/initiated_at

	/// callback to fire on success, if any. called with (src).
	var/datum/callback/on_success
	/// callback to fire on failure, if any. called with (src, string_denial_reason).
	var/datum/callback/on_failure
	/// connectivity check callback; if null, we use default. if any, called with (src)
	var/datum/callback/hook_connectivity_check

/datum/research_network_connection_request

/datum/research_network_connection_request/proc/create_connection(datum/research_network/network) as /datum/research_network_connection
	var/datum/research_network_connection/conn = new
	conn.c_network_id = network.id
	conn.c_capability_flags = r_request_capabilities
	return conn

/datum/research_network_connection_request/proc/on_success()

/datum/research_network_connection_request/proc/on_failure()

/datum/research_network_connection_request/proc/submit(datum/research_network/network)
	ASSERT(isnull(initiated_at))
	#warn impl

/datum/research_network_connection_request/proc/reconsider_connectivity()
	if(!check_connectivity())
		interrupt("connection-lost")

/datum/research_network_connection_request/proc/check_connectivity()
	if(!isnull(hook_connectivity_check))
		return hook_connectivity_check.invoke_no_sleep(src)
	#warn impl

/datum/research_network_connection_request/proc/proceed()

/datum/research_network_connection_request/proc/reject(reason_str)

/datum/research_network_connection_request/proc/interrupt(reason_str)

/datum/research_network_connection_request/Destroy()
	if(!isnull(initiated_at))
		r_network.remove_connection_request(src)
	r_peer = null
	r_network = null
	return ..()
