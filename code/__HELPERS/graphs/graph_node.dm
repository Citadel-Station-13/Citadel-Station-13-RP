/**
 * wrapper datum for values that can't be list keys
 */
/datum/graph_node
	/// key
	var/key

/datum/graph_node/New(key)
	src.key = key
