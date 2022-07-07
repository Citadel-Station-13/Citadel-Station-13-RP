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

	// step 1: sort
	var/list/edges = undirected_edges()
