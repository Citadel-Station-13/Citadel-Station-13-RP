/**
 * graph datum implemented with lists
 *
 * memory inefficient but optimized for fast lookup
 *
 * vertices can be anything that's a valid list key
 *
 * constructor: can accept a graph to clone, or a list. list will just add the vertices with no further ops.
 *
 * this datum is intentionally very error intolerant, and procs will crash if you do illegal operations.
 */
/datum/graph
	/// vertices associated to lists of connected vertices by weight.
	var/list/vertices = list()

/datum/graph/New(from)
	if(!isdatum(from))
		return
	var/datum/cloning = from
	switch(cloning.type)
		if(/datum/graph)
			var/datum/graph/copying = cloning
			for(var/a in copying.vertices)
				Insert(a)
				var/list/edges = copying.vertices[a]
				for(var/b in edges)
					Connect(a, b, FALSE, edges[b])
		if(/list)
			var/list/inserting = cloning
			for(var/a in copying)
				Insert(a)

/datum/graph/Destroy()
	vertices.Cut()
	return ..()

/datum/graph/proc/Insert(key)
	ASSERT(!vertices[key])
	vertices[key] = list()

/datum/graph/proc/Remove(key)
	ASSERT(vertices[key])
	var/list/edges = vertices[key]
	if(edges.len)
		for(var/other in edges)
			Disconnect(key, other, FALSE)
	vertices -= key

/datum/graph/proc/Connect(a, b, directed, weight = 0)
	ASSERT(vertices[a] && vertices[b])
	vertices[a][b] = weight
	if(!directed)
		vertices[b][a] = weight

/datum/graph/proc/Disconnect(a, b, directed)
	ASSERT(vertices[a] && vertices[b])
	vertices[a] -= b
	if(!directed)
		vertices[b] -= a

/datum/graph/proc/Has(key)
	return !!vertices[key]

/datum/graph/proc/Connected(a, b)
	ASSERT(vertices[a] && vertices[b])
	return !isnull(vertices[a][b])

/datum/graph/proc/Weight(a, b)
	ASSERT(vertices[a] && vertices[b])
	return vertices[a][b]

/datum/graph/proc/Clone()
	return new /datum/graph(src)

/**
 * **only checks outgoing edges for digraphs**
 */
/datum/graph/proc/Edges(a)
	ASSERT(vertices[a])
	return vertices[a].Copy()
