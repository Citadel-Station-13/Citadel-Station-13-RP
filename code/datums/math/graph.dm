//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Warning. This file is very strongly coupled with Citade Station's rust-g repository,
 * notably geometry.rs. Do not mess with things in here unless you know what you are doing.
 */

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

/**
 * serialize a graph to be a rust_g string
 *
 * this way, vertex datums can be arbitrary without making rust_g code different
 */
/proc/graph_serialize_to_rustg_call_string(datum/graph/graph)
	// construct reverse lookup
	var/list/vertex_map = list()
	for(var/i in 1 to length(graph.vertices))
		var/vertex = graph.vertices[i]
		vertex_map[vertex] = i
	// edges.
	var/list/serializing_edges = list()
	// build
	for(var/i in 1 to length(graph.vertices))
		var/vertex = graph.vertices[i]
		var/list/edges = graph.vertices[vertex]
		var/list/resolved = list()
		for(var/edge in edges)
			resolved += vertex_map[edge]
		serializing_edges[++serializing_edges.len] = resolved
	// serialize and return
	var/list/serializing = list(
		"count" = length(graph.vertices),
		"edges" = serializing_edges,
	)
	return json_encode(serializing)

/**
 * rust_g will return a list of edges
 *
 * edge list are lists of A, B where A and B are indices in ordered_vertices
 *
 * ordered_vertices are referenced, not copied.
 */
/proc/graph_deserialize_from_rustg_call_string(string, list/ordered_vertices)
	var/list/decoded = json_decode(string)
	return graph_deserialize_from_rustg_call_list(decoded, ordered_vertices)

/proc/graph_deserialize_from_rustg_call_list(list/decoded, list/ordered_vertices)
	ASSERT(decoded["count"] == length(ordered_vertices))
	var/datum/graph/building = new
	var/list/vertices = list()
	var/list/edges = decoded["edges"]
	for(var/i in 1 to length(ordered_vertices))
		vertices[ordered_vertices[i]] = list()
	ASSERT(length(vertices) == decoded["count"])
	for(var/a in 1 to length(edges))
		var/list/connections = edges[a]
		for(var/b in connections)
			// rust is 0 indexed; we don't have to increment a because a was turned to 1
			// indexing by json_decode list positioning, but this isn't!
			b++
			var/node_a = ordered_vertices[a]
			var/node_b = ordered_vertices[b]
			vertices[node_a][node_b] = TRUE
			vertices[node_b][node_a] = TRUE
	building.vertices = vertices
	return building
