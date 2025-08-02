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
	/// network friendly name
	/// * can be very easily spoofed lol don't use this in-code for identification
	var/network_name
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

	#warn update capacities?
	var/tmp/c_available_compute_capacity = 0
	var/tmp/c_scheduled_compute_capacity = 0
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

/datum/research_network/proc/set_network_name(new_name)
	#warn update active connections

/datum/research_network/proc/create_invite(username, passkey, oplvl, capability) as /datum/research_network_invite
	if(network_invites?[username])
		return null
	if(!network_invites)
		network_invites = list()
	. = new /datum/research_network_invite(username, passkey, oplvl, capability)
	network_invites[username] = .
	network_ui_push_invites()

/datum/research_network/proc/get_invite(username)
	return network_invites?[username]

/datum/research_network/proc/delete_invite(username)
	if(!network_invites)
		return
	network_invites -= username
	network_ui_push_invites()


/datum/research_network/proc/network_ui_connection_data()
	var/list/serialized_connections = list()
	for(var/id in connections)
		var/datum/research_network_connection/conn = connections[id]
		#warn impl
	return serialized_connections

/datum/research_network/proc/network_ui_connection_request_data()
	var/list/serialized_connection_requests = list()
	for(var/datum/research_network_connection_request/req as anything in connection_requests)
		#warn impl
	return serialized_connection_requests

/datum/research_network/proc/network_ui_invite_data()
	var/list/serialized_invites = list()
	for(var/username in network_invites)
		var/datum/research_network_invite/invite = network_invites[username]
		#warn impl
	return serialized_invites

/datum/research_network/proc/network_ui_job_data()
	var/list/serialized_jobs = list()
	for(var/datum/research_batch_job/job as anything in jobs)
		#warn impl
	return serialized_jobs

/datum/research_network/proc/network_ui_data(datum/event_args/actor/actor, actor_oplvl, actor_capabilities)
	. = list()
	.["id"] = network_id
	.["name"] = network_name

	.["invites"] = network_ui_invite_data()
	.["connReqs"] = network_ui_connection_request_data()
	.["conns"] = network_ui_connection_data()
	.["jobs"] = network_ui_job_data()

	.["computeAvail"] = c_available_compute_capacity
	.["computeUsed"] = c_scheduled_compute_capacity

	#warn impl

/datum/research_network/proc/network_ui_push_invites()
	network_ui_push(data = list(
		"invites" = network_ui_invite_data(),
	))

/datum/research_network/proc/network_ui_push_connection_requests()
	network_ui_push(data = list(
		"connReqs" = network_ui_connection_request_data(),
	))

/datum/research_network/proc/network_ui_push_connections()
	network_ui_push(data = list(
		"conns" = network_ui_connection_data(),
	))

/datum/research_network/proc/network_ui_push_jobs()
	network_ui_push(data = list(
		"jobs" = network_ui_job_data(),
	))

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
		if("modifyName")
			var/new_name = params["name"]
			if(!(actor_capabilities & RESEARCH_NETWORK_CAPABILITY_ADMIN))
				return TRUE
			network_name = new_name
			#warn log + ui push
			network_ui_push(data = list(
			))
			return TRUE
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
	process_jobs()

/datum/research_network/proc/process_jobs(delta_time)
	var/list/datum/research_batch_job/require_rescheduling = list()
	for(var/datum/research_batch_job/job as anything in jobs)
		if(!job.is_running)
			continue
		job.on_work_done(delta_time * job.compute_active)
		#warn check if it finished
		if(job.compute_scheduled < job.compute_requested)
			require_rescheduling += job

	// only reschedule on some ticks
	if(prob(35))
		var/list/obj/machinery/research_server/coprocessor/free_processors = list()

		for(var/datum/research_network_connection/conn in connections)
			if(!conn.s_connected)
				continue
			if(istype(conn.s_peer, /obj/machinery/research_server/coprocessor))
				var/obj/machinery/research_server/coprocessor/connected_processor = conn.s_peer
				if(connected_processor.compute_scheduled < connected_processor.compute_capacity)
					free_processors += connected_processor

		for(var/datum/research_batch_job/reschedule in require_rescheduling)
			// good chance to skip
			if(prob(50))
				break
			if(!length(free_processors))
				break
			var/wanted_compute = reschedule.compute_requested - reschedule.compute_scheduled
			for(var/i in 1 to 3)
				var/obj/machinery/research_server/coprocessor/free_processor = pick(free_processors)
				// schedule by consuming rest if available
				var/available = free_processor.compute_capacity - free_processor.compute_scheduled
				var/adding = min(wanted_compute, available)
				reschedule.add_processor(free_processor, adding)
				wanted_compute -= adding

				if(free_processor.compute_scheduled >= free_processor.compute_capacity)
					free_processors -= free_processor

/datum/design_holder/research_network
	/// k-v list; prototype to context or list of contexts
	var/list/datum/prototype/design/projected_designs
	var/datum/design_context/default_context = new /datum/design_context/research_network

#warn context..

/datum/design_holder/research_network/get_designs_const()
	return ..() + projected_designs

/**
 * Statefully registers designs to the network to be made accessible to members.
 *
 * @params
 * * designs - list of designs, optionally associated to design_context's
 */
/datum/design_holder/research_network/proc/register_projected_designs(list/datum/prototype/design/designs)

/**
 * Statefully removes projected designs from the network.
 *
 * @params
 * * designs - list of designs
 */
/datum/design_holder/research_network/proc/unregister_projected_designs(list/datum/prototype/design/designs)

/datum/techweb_node_holder/research_network
	/// k-v list; prototype to context or list of contexts
	var/list/datum/prototype/techweb_node/projected_nodes
	var/datum/techweb_node_context/default_context = new /datum/techweb_node_context/research_network

/datum/techweb_node_holder/research_network/get_nodes_const()
	return ..() + projected_nodes

/**
 * Statefully registers nodes to the network to be made accessible to members.
 *
 * @params
 * * nodes - list of nodes, optionally associated to node_context's
 */
/datum/techweb_node_holder/research_network/proc/register_projected_nodes(list/datum/prototype/techweb_node/nodes)

/**
 * Statefully removes projected nodes from the network.
 *
 * @params
 * * nodes - list of nodes
 */
/datum/techweb_node_holder/research_network/proc/unregister_projected_nodes(list/datum/prototype/techweb_node/nodes)
