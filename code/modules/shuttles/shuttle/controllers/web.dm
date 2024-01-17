//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: this entire file needs to be persistence-capable, right now we don't need it tho so everything uses typepaths.

/**
 * web shuttle controller
 */
/datum/shuttle_controller/web

#warn impl all

/**
 * holds all the nodes of a web shuttle
 */
/datum/shuttle_web_map
	/// nodes by id
	var/list/keyed_nodes = list()
	/// deferred connection hooks by node type
	var/list/deferred_auto_connect_type_hooks = list()
	/// nodes by type
	var/list/nodes_by_type = list()

/datum/shuttle_web_map/New()
	construct()

/datum/shuttle_web_map/Destroy()
	QDEL_LIST_ASSOC_VAL(keyed_nodes)
	nodes_by_type = null
	deferred_auto_connect_type_hooks = null
	return ..()

/**
 * Construct the nodes in this map.
 */
/datum/shuttle_web_map/proc/construct()
	return

/**
 * register node, perform auto connects, etc
 *
 * todo: an unregistration proc?
 */
/datum/shuttle_web_map/proc/auto_register_node(datum/shuttle_web_node/node)
	ASSERT(isnull(keyed_nodes[node.id]))
	ASSERT(isnull(nodes_by_type[node.type]))
	nodes_by_type[node.type] = node
	for(var/connect_type in node.auto_connect_node_types)
		if(nodes_by_type[connect_type])
			node.connect(nodes_by_type[connect_type])
		LAZYDISTINCTADD(deferred_auto_connect_type_hooks[connect_type], node)
	keyed_nodes[node.id] = node

/**
 * a single destination node of a web shuttle
 *
 * supports multiple docking ports
 */
/datum/shuttle_web_node
	/// our host map
	var/datum/shuttle_web_map/map
	/// connected nodes
	var/list/datum/shuttle_web_node/connections
	/// docking ports on this node
	var/list/obj/shuttle_dock/docks
	/// id - must be set, and must only be unique to the map
	var/id
	/// shuttle web map type to automatically join to
	var/auto_join_map_type
	/// automatically form bidirectional connections to these node types in the auto join'd web map type
	/// only supports types, not ids, for now
	var/list/auto_connect_node_types

/datum/shuttle_web_node/proc/initialize()
	ASSERT(istext(id))
	if(isnull(auto_join_map_type))
		return
	var/datum/shuttle_web_map/map = SSshuttle.fetch_or_load_shuttle_web_type(auto_join_map_type)
	map.auto_register_node(src)

/datum/shuttle_web_node/Destroy()
	for(var/obj/shuttle_dock/dock in docks)
		dock.web_node = null
	docks = null
	for(var/datum/shuttle_web_node/node in connections)
		node.connections -= src
	map.keyed_nodes -= id
	for(var/connect_type in auto_connect_node_types)
		if(!map.deferred_auto_connect_type_hooks[connect_type])
			continue
		map.deferred_auto_connect_type_hooks[connect_type] -= src
	map.nodes_by_type -= type
	return ..()

/datum/shuttle_web_node/proc/connect(datum/shuttle_web_node/other)
	other.connections |= src
	connections |= other
