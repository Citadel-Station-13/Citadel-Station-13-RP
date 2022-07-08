/**
 * wrapper datum for values that can't be list keys
 */
/datum/graph_vertex
	/// key
	var/key

/datum/graph_vertex/New(key)
	src.key = key

//! general vertex helpers for graphs

/datum/graph/proc/vertex_union(datum/graph/other)
	. = list()
	for(var/a in (vertices | other.vertices))
		. += a

/datum/graph/proc/vertex_intersection(datum/graph/other)
	. = list()
	for(var/a in (vertices & other.vertices))
		. += a

/datum/graph/proc/vertex_difference(datum/graph/other)
	. = list()
	for(var/a in (vertices - other.vertices))
		. += a

/datum/graph/proc/vertex_xor(datum/graph/other)
	. = list()
	for(var/a in (vertices ^ other.vertices))
		. += a

/datum/graph/proc/vertex_equality(datum/graph/other)
	return !length(vertex_xor(other))
