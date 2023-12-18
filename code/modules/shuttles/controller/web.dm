//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * web shuttle controller
 */
/datum/shuttle_controller/web

/**
 * holds all the nodes of a web shuttle
 */
/datum/shuttle_web_map
	/// nodes by id
	var/list/keyed_nodes = list()

/datum/shuttle_web_map/New()
	construct()

/datum/shuttle_web_map/Destroy()
	QDEL_LIST_ASSOC_VAL(keyed_nodes)
	return ..()

#warn *scream

/**
 * Construct the nodes in this map.
 */
/datum/shuttle_web_map/proc/construct()
	return

/**
 * a single destination node of a web shuttle
 *
 * supports multiple docking ports
 */
/datum/shuttle_web_node
	/// connected nodes
	var/list/datum/shuttle_web_node/connections
	/// docking ports on this node
	var/list/obj/shuttle_dock/docks
	/// id - must be set, and must only be unique to the map
	var/id

#warn this shit needs a better API
