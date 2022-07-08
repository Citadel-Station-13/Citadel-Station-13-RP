/**
 * ephemeral datum used in algorithms
 * normally we don't store edges as datums at all for speed reasons.
 * this is therefore agnostic to whether or not we are a directed edge. your algorithm should take that into account
 */
/datum/graph_edge
	var/a
	var/b
	var/weight

/datum/graph_edge/New(a, b, weight)
	src.a = a
	src.b = b
	src.weight = weight

//! comparators

/proc/cmp_graph_edge_weight_asc(datum/graph_edge/a, datum/graph_edge/b)
	return a.weight - b.weight

/proc/cmp_graph_edge_weight_dsc(datum/graph_edge/a, datum/graph_edge/b)
	return b.weight - a.weight

//! functions to get edge datums from graphs

/datum/graph/proc/undirected_edges()
	RETURN_TYPE(/list)
	. = list()
	var/list/formed = list()
	for(var/a in vertices)
		for(var/b in vertices[a])
			// check for reverse
			if(formed[b] && formed[b][a])
				continue
			if(!formed[a])
				formed[a] = list()
			formed[a][b] = TRUE
			. += new /datum/graph_edge(a, b, vertices[a][b])

//! general edge helpers for graphs

// edge operations - only makes sense if vertices are equal!
// returns list of graph edges
// for union, weights are max
// for intersection, weights are min

/datum/graph/proc/undirected_edge_difference(datum/graph/other)
	RETURN_TYPE(/list)
	. = list()
	var/list/found = list()
	for(var/a in vertices)
		if(!found[a])
			found[a] = list()
		for(var/b in vertices[a])
			// this goes above other to save some lookups
			if(found[b][a])
				// we already linked reverse
				continue
			found[a][b] = TRUE
			if(other.vertices[a][b])
				continue
			. += new /datum/graph_edge(a, b, vertices[a][b])


// todo: union, intersection, difference, xor, equality for directed and undirected
