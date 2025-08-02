//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Research networks
 */
/datum/research_network
	/// network ID
	/// TODO: persistence-stable if randomgen!
	/// * this is not shown to players, a hash is.
	#warn impl
	var/network_id
	/// network passkey
	/// * things need passkey or click-to-allow to join
	/// * null lets anything join
	var/network_passkey
	/// let things join as a specific oplvl if joining with passkey
	var/network_passkey_oplvl
	/// let things join with a specific capability flag set if joining with passkey
	var/network_passkey_capabilities

	/// join requests (exonet protected setup, legally distinct from the router push button irl)
	/// * lazy list
	#warn impl
	var/list/datum/research_network_connection_request/connection_requests
	/// connections by id
	/// * lazy list
	#warn impl
	var/list/datum/research_network_connection/connections

	/// batch jobs, whether or not they're active
	var/list/datum/research_batch_job/jobs

	/// our owning mainframe
	var/obj/machinery/research_mainframe/mainframe

	var/tmp/c_available_compute_capacity = 0
	var/tmp/datum/design_holder/research_network/c_design_holder = new
	var/tmp/datum/techweb_node_holder/research_network/c_node_holder = new

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

/datum/research_network/proc/network_ui_data()

/datum/research_network/proc/network_ui_static_data()

/datum/research_network/proc/network_ui_act(action, list/params, datum/event_args/actor/actor)

/datum/research_network/proc/network_push_ui_data(list/data)

/datum/research_network/process(delta_time)

/datum/design_holder/research_network
	var/list/datum/prototype/design/projected_designs

/datum/design_holder/research_network/get_designs_const()
	return ..() + projected_designs

/datum/techweb_node_holder/research_network
	var/list/datum/prototype/design/projected_nodes

/datum/techweb_node_holder/research_network/get_nodes_const()
	return ..() + projected_nodes
