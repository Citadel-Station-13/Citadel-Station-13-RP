//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_data_techweb
	/// direct refs of unlocked techweb nodes
	var/list/datum/prototype/techweb_node/nodes

/datum/research_data_techweb/serialize()
	. = list()
	var/list/serialized_nodes = list()
	for(var/datum/prototype/techweb_node/node in nodes)
		serialized_nodes += node.id
	.["nodes"] = serialized_nodes

/datum/research_data_techweb/deserialize(list/data)
	var/list/deserializing_nodes = data["nodes"]
	nodes = RStechweb_nodes.fetch_multi(deserializing_nodes || list())

/datum/research_data_techweb/clone()
	var/datum/research_data_techweb/cloned = new
	cloned.nodes = nodes.Copy()
	return cloned

/datum/research_data_techweb/proc/is_node_unlocked(datum/prototype/techweb_node/node)
	return node in nodes

/datum/research_data_techweb/proc/unlock_node(datum/prototype/techweb_node/node)
	if(node in nodes)
		return
	nodes += nodes
	on_node_store_modified(list(node), list())

/datum/research_data_techweb/proc/forget_node(datum/prototype/techweb_node/node)
	if(!(node in nodes))
		return
	nodes -= node
	on_node_store_modified(list(), list(node))

/datum/research_data_techweb/proc/on_node_store_modified(list/datum/prototype/techweb_node/added, list/datum/prototype/techweb_node/removed)
	SEND_SIGNAL(src, COMSIG_RESEARCH_DATA_TECHWEB_MODIFIED, added, removed)
