/**
 * check connectivity, assuming we are not directed
 */
/datum/graph/proc/undirected_connectivity()
	if(!vertices.len)
		return TRUE
	var/start = pick(vertices)
	var/list/found = list(start = TRUE)
	var/list/searching = list(start)
	while(searching.len)
		var/list/potential = Edges(searching[1])
		searching.Cut(1, 2)
		for(var/b in potential)
			if(found[b])
				continue
			found[b] = TRUE
			seraching += b
	return found.len == vertices.len

/**
 * all keys reachable from a key in an undirected graph
 */
/datum/graph/proc/undirected_component(key)
	RETURN_TYPE(/list)
	ASSERT(vertices[key])
	var/list/found = list()
	var/list/searching = list(key)
	for(var/a in searching)
		if(found[a])
			continue
		found[a] = TRUE
		searching += Edges(a)
	// flatten
	. = list()
	for(var/a in found)
		. += a

/**
 * get connected components of undirected graph as a list of lists of vertices
 */
/datum/graph/proc/undirected_components()
	RETURN_TYPE(/list)
	var/list/found = list()
	var/list/searching = vertices.Copy()
	for(var/a in searching)
		var/list/component = undirected_component(a)
		found[++found.len] = component
		searching -= component
	return found

/**
 * forks into connected components, preserving edges and weights
 */
/datum/graph/proc/undirected_split_into_components()
	RETURN_TYPE(/list)
	. = list()
	for(var/list/component as anything in undirected_components())
		var/datum/graph/subgraph = new(component)
		for(var/a in component)
			var/list/edges = Edges(A)
			for(var/b in edges)
				if(!subgraph.Has(b))
					continue
				subgraph.Connect(a, b, FALSE, edges[b])
		. += subgraph

// todo: directed graph connectivity
