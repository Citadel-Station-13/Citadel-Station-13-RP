//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Common techweb node API for things like research consoles to use.
 */
/datum/techweb_node_holder

/**
 * * Do not edit passed back list.
 * @return list(techweb_node instance = techweb_node_context instance, ...)
 */
/datum/techweb_node_holder/proc/get_nodes_const() as /list
	CRASH("get_nodes_const not implemented.")

/**
 * @return list(techweb_node instance = techweb_node_context instance, ...)
 */
/datum/techweb_node_holder/proc/get_nodes() as /list
	return get_nodes_const().Copy()

/**
 * Gets if we have a techweb_node context for a given techweb_node.
 * @return null if no context exists, or the techweb_node isn't in us.
 */
/datum/techweb_node_holder/proc/get_node_context(datum/prototype/techweb_node/node)
	CRASH("get_node_context not implemented.")

/datum/techweb_node_holder/proc/has_node(datum/prototype/techweb_node/node)
	CRASH("has_node not implemented.")

/**
 * Basic techweb_node holder that hard-references its techweb_nodes.
 */
/datum/techweb_node_holder/basic
	/// techweb_nodes we contain, associated to contexts
	var/list/datum/prototype/techweb_node/nodes = list()

/datum/techweb_node_holder/basic/Destroy()
	nodes.Cut()
	return ..()

/datum/techweb_node_holder/basic/proc/add_node(datum/prototype/techweb_node/node, datum/techweb_node_context/node_context)
	nodes[node] = node_context

/datum/techweb_node_holder/basic/proc/remove_node(datum/prototype/techweb_node/node)
	nodes -= node

/datum/techweb_node_holder/basic/has_node(datum/prototype/techweb_node/node)
	return node in nodes

/datum/techweb_node_holder/basic/get_node_context(datum/prototype/techweb_node/node)
	return nodes[node]

/datum/techweb_node_holder/basic/get_nodes_const()
	return nodes
