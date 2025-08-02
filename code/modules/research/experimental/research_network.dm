//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Research networks
 */
/datum/research_network
	/// network ID
	/// * this is not shown to players, a hash is.
	#warn impl
	var/network_id
	/// network invites by username
	/// * lazy list
	var/list/network_invites

	/// join requests (exonet protected setup, legally distinct from the router push button irl)
	/// * lazy list
	var/list/datum/research_network_connection_request/connection_requests
	/// connections by id
	/// * lazy list
	var/list/datum/research_network_connection/connections

	/// batch jobs, whether or not they're active
	var/list/datum/research_batch_job/jobs

	/// our owning mainframe
	var/obj/machinery/research_mainframe/mainframe

	var/tmp/c_available_compute_capacity = 0
	var/tmp/datum/design_holder/research_network/c_design_holder = new
	var/tmp/datum/techweb_node_holder/research_network/c_node_holder = new

/datum/research_network/New(force_id)
	#warn id?

/datum/research_network/Destroy()
	mainframe?.leave_network()
	QDEL_LIST(connection_requests)
	QDEL_LIST_ASSOC_VAL(network_invites)
	QDEL_LIST(jobs)
	for(var/datum/research_network_connection/connection in connections)
		connection.unlink_network()
	connections = null
	return ..()

// TODO: ser/de

/datum/research_network/proc/get_display_id()
	return copytext(md5("[network_id]"), 1, 5)

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

/datum/research_network/proc/create_invite(username) as /datum/research_network_invite
	if(network_invites?[username])
		return null
	if(!network_invites)
		network_invites = list()
	. = new /datum/research_network_invite(username)
	network_invites[username] = .

/datum/research_network/proc/get_invite(username)
	return network_invites?[username]

/**
 * Statefully registers designs to the network to be made accessible to members.
 *
 * @params
 * * designs - list of designs, optionally associated to design_context's
 */
/datum/research_network/proc/register_projected_designs(list/datum/prototype/design/designs)

/**
 * Statefully registers nodes to the network to be made accessible to members.
 *
 * @params
 * * nodes - list of nodes, optionally associated to node_context's
 */
/datum/research_network/proc/register_projected_nodes(list/datum/prototype/techweb_node/nodes)

/**
 * Statefully removes projected designs from the network.
 *
 * @params
 * * designs - list of designs
 */
/datum/research_network/proc/unregister_projected_designs(list/datum/prototype/design/designs)

/**
 * Statefully removes projected nodes from the network.
 *
 * @params
 * * nodes - list of nodes
 */
/datum/research_network/proc/unregister_projected_nodes(list/datum/prototype/techweb_node/nodes)

/datum/research_network/proc/network_ui_data(datum/event_args/actor/actor, actor_oplvl, actor_capabilities)

/**
 * relayed up from accessor with authentication data so we know what they are
 * allowed to modify
 */
/datum/research_network/proc/network_ui_act(action, list/params, datum/event_args/actor/actor, actor_oplvl, actor_capabilities)
	switch(action)
		if("acceptJoinRequest")
			var/conn_id = params["id"]
			var/capabilities = params["capabilities"]
			var/oplvl = params["oplvl"]
			var/list/design_blacklist = params["designBlacklist"]
			var/list/design_whitelist = params["designWhitelist"]
		if("createInvite")
			var/username = params["username"]
		if("modifyInvitePasskey")
			var/username = params["username"]
			var/passkey = params["passkey"]
		if("modifyInviteOplvl")
			var/username = params["username"]
			var/oplvl = params["oplvl"]
		if("modifyInviteCapabilities")
			var/username = params["username"]
			var/capabilities = params["capabilities"]
		if("modifyInviteAddDesignBlacklist")
			var/username = params["username"]
			var/tag = params["tag"]
		if("modifyInviteAddDesignWhitelist")
			var/username = params["username"]
			var/tag = params["tag"]
		if("modifyInviteRemoveDesignBlacklist")
			var/username = params["username"]
			var/tag = params["tag"]
		if("modifyInviteRemoveDesignWhitelist")
			var/username = params["username"]
			var/tag = params["tag"]
		if("kick")
			var/conn_id = params["id"]
		if("modifyConnectionOplvl")
			var/conn_id = params["id"]
			var/oplvl = params["oplvl"]
		if("modifyConnectionCapabilities")
			var/conn_id = params["id"]
			var/capabilities = params["capabilities"]
		if("modifyConnectionAddDesignBlacklist")
			var/conn_id = params["id"]
			var/design_tag = params["tag"]
		if("modifyConnectionRemoveDesignBlacklist")
			var/conn_id = params["id"]
			var/design_tag = params["tag"]
		if("modifyConnectionAddDesignWhitelist")
			var/conn_id = params["id"]
			var/design_tag = params["tag"]
		if("modifyConnectionRemoveDesignBlacklist")
			var/conn_id = params["id"]
			var/design_tag = params["tag"]
		if("evictComputeJob")
			var/ref = params["ref"]
		if("toggleComputeJob")
			var/ref = params["ref"]
			var/active = params["active"]

/datum/research_network/proc/network_ui_push(list/data, filter_oplvl, filter_capabilities)
	SEND_SIGNAL(src, COMSIG_RESEARCH_NETWORK_UI_DATA_PUSH, data, filter_oplvl, filter_capabilities)

/datum/research_network/process(delta_time)

/datum/design_holder/research_network
	var/list/datum/prototype/design/projected_designs

/datum/design_holder/research_network/get_designs_const()
	return ..() + projected_designs

/datum/techweb_node_holder/research_network
	var/list/datum/prototype/design/projected_nodes

/datum/techweb_node_holder/research_network/get_nodes_const()
	return ..() + projected_nodes
