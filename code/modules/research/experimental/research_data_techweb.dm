//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/research_data_techweb
	/// direct refs of unlocked techweb nodes
	var/list/datum/prototype/techweb_node/nodes

/datum/research_data_techweb/serialize()
	. = ..()

/datum/research_data_techweb/deserialize(list/data)
	. = ..()

/datum/research_data_techweb/clone()
	. = ..()

/datum/research_data_techweb/proc/is_node_unlocked(datum/prototype/techweb_node/node)

/datum/research_data_techweb/proc/unlock_node(datum/prototype/techweb_node/node)

/datum/research_data_techweb/proc/remove_node(datum/prototype/techweb_node/node)


#warn impl
