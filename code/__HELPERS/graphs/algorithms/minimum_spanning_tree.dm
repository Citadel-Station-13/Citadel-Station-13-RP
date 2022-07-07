//? WARNING I HAVE NO CLUE HOW THE CODE IN HERE WORKS OTHER THAN IT DOES I DID NOT STUDY GRAPH THEORY ENOUGH TO TALK ABOUT UNION FIND ALGORITHMS

/**
 * makes a new minimum spanning tree from a graph
 *
 * returns null if not a connected graph
 */
/datum/graph/proc/undirected_create_mst()
	if(!undirected_connectivity())
		return

	// kruskal's algorithm
	var/datum/graph/mst = new

	if(!vertices.len)
		return mst

	// step 1: sort
	var/list/edges = undirected_edges()
	sortTim(edges, /proc/cmp_graph_edge_weight_asc)

	// step 2: continuously pick smallest edge, adding if it doesn't form a cycle

	// we will use the union-find algorithm to do this since it's so much faster than naive DFS
	var/created_count = 0
	var/vertices_count = vertices.len

	// make subset holder
	var/datum/_graph_subset_holder/subsets = new
	for(var/i in 1 to vertices_count)
		subsets.subsets += new /datum/__graph_subset(i, 0)

	for(var/i in 1 to edges.len)
		if(created_count == vertices_count - 1)
			break
		// get edge
		var/datum/graph_edge/E = edges[i]

		var/xi = subsets.find(E.a)
		var/yi = subsets.find(E.b)

		// has cycle
		if(xi == yi)
			continue

		// add to MST, union to the subset holder
		mst.Connect(E.a, E.b, FALSE, E.weight)
		subsets.union(xi, yi)

	. = mst

	if(created_count != vertices_count - 1)
		CRASH("Failed to make MST - mismatch in counts detected. Spitting out broken graph as output.")

/datum/_graph_subset_holder
	var/list/datum/__graph_subset/subsets = list()

/datum/_graph_subset_holder/proc/union(x, y)
	var/xi = find(x)
	var/yi = find(y)
	if(subsets[xi].rank < subsets[yi].rank)
		subsets[xi].parent = yi
	else if(subsets[xi].rank > subsets[yi].rank)
		subsets[yi].parent = xi
	else
		subsets[yi].parent = xi
		subsets[xi].rank++

/datum/_graph_subset_holder/proc/find(i)
	if(subsets[i].parent != i)
		subsets[i].parent = find(subsets[i].parent)
	return subsets[i].parent

/datum/__graph_subset
	var/parent
	var/rank

/datum/__graph_subset/New(parent, rank)
	src.parent = parent
	src.rank = rank
