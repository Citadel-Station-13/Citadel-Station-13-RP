//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * undirected graph
 *
 * vertices can be arbitrary datums
 */
/datum/graph
	/// vertices, associated to connected vertices
	var/list/vertices = list()

/datum/graph/proc/add_vertex(datum/D)
	// strong assertion due to risk of corruption
	ASSERT(isnull(vertices[D]))
	vertices[D] = list()

/datum/graph/proc/remove_vertex(datum/D)
	// strong assertion due to risk of corruption
	ASSERT(!isnull(vertices[D]))
	for(var/datum/other in vertices[D])
		vertices[other] -= D
	vertices -= D

/datum/graph/proc/is_connected(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	return vertices[A][B]

/datum/graph/proc/connect(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	vertices[A][B] = TRUE
	vertices[B][A] = TRUE

/datum/graph/proc/disconnect(datum/A, datum/B)
	// no assertion - this will runtime if it's not there
	vertices[A] -= B
	vertices[B] -= A
