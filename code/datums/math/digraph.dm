//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Warning. This file is very strongly coupled with Citade Station's rust-g repository,
 * notably geometry.rs. Do not mess with things in here unless you know what you are doing.
 */

/**
 * directed graph
 *
 * vertices can be arbitrary datums
 */
/datum/digraph
	/// vertices, associated to connected vertices
	var/list/vertices = list()

/datum/digraph/proc/add_vertex(datum/D)
	// strong assertion due to risk of corruption
	ASSERT(isnull(vertices[D]))
	vertices[D] = list()

/datum/digraph/proc/remove_vertex(datum/D)
	// strong assertion due to risk of corruption
	ASSERT(!isnull(vertices[D]))
	vertices -= D

/datum/digraph/proc/is_connected(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	return vertices[A][B]

/datum/digraph/proc/connect(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	vertices[A][B] = TRUE

/datum/digraph/proc/disconnect(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	vertices[A] -= B
