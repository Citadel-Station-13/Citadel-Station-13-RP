//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Warning. This file is very strongly coupled with Citade Station's rust-g repository,
 * notably geometry.rs. Do not mess with things in here unless you know what you are doing.
 */

/datum/vec2
	var/x
	var/y

	//* for usage in voronoi / delaunay graphs *//
	/// only set if requested; area underneath this vec2
	var/voronoi_area
	/// only set if requested; /datum/vec2's in the voronoi cell
	var/list/datum/vec2/voronoi_cells

/datum/vec2/New(x, y)
	src.x = x
	src.y = y

/datum/vec2/proc/euclidean_distance_to(datum/vec2/other)
	return sqrt((other.x - x) ** 2 + (other.y - y) ** 2)

/datum/vec2/proc/chebyshev_distance_to(datum/vec2/other)
	return max(abs(other.y - y), abs(other.x - x))

/datum/vec2/proc/manhattan_distance_to(datum/vec2/other)
	return abs(other.y - y) + abs(other.x - x)

/proc/vec2_serialize_to_rustg_call_list(list/datum/vec2/points)
	var/list/constructed = list()
	for(var/datum/vec2/point as anything in points)
		constructed[++constructed.len] = list(
			"x" = point.x,
			"y" = point.y,
		)
	return constructed

/proc/vec2_serialize_to_rustg_call_string(list/datum/vec2/points)
	return json_encode(vec2_serialize_to_rustg_call_list(points))

/proc/vec2_deserialize_from_rustg_call_string(string)
	var/list/decoded = json_decode(string)
	var/list/datum/vec2/built = list()
	for(var/list/list as anything in decoded)
		built[++built.len] = new /datum/vec2(list["x"], list["y"])

/**
 * returns a /datum/graph,
 *
 * vertices are vec2
 * edges are connections
 */
/proc/vec2_delaunay_triangulation_to_graph(list/datum/vec2/points)
	var/encoded = rustg_geometry_delaunay_triangulate_to_graph(vec2_serialize_to_rustg_call_string(points))
	return graph_deserialize_from_rustg_call_string(encoded, points)

/**
 * returns a /datum/graph,
 *
 * vertices are vec2 datums
 * edges are connections between vertices
 *
 * @params
 * * points - vec2 datums
 * * bounding_margin - amount of space to put on the edges; the bounding box will otherwise be min(points), max(points).
 * * area - populate area
 * * cell - populate cell
 */
/proc/vec2_dual_delaunay_voronoi_graph(list/datum/vec2/points, bounding_margin = 0, area = TRUE, cell = FALSE)
	var/encoded = rustg_geometry_delaunay_voronoi_graph(json_encode(list(
		"area" = area,
		"cell" = cell,
		"points" = vec2_serialize_to_rustg_call_list(points),
		"margin" = bounding_margin,
	)))
	var/list/decoded = json_decode(encoded)
	var/count = length(points)
	var/list/areas = decoded["areas"] || new /list(count)
	var/list/cells = decoded["cells"] || new /list(count)
	for(var/i in 1 to length(points))
		var/datum/vec2/point = points[i]
		point.voronoi_area = areas[i]
		point.voronoi_cells = cells[i]
		if(!isnull(point.voronoi_cells))
			var/list/datum/vec2/decoded_cell_vec2 = list()
			for(var/list/data_list as anything in point.voronoi_cells)
				decoded_cell_vec2 += new /datum/vec2(data_list["x"], data_list["y"])
			point.voronoi_cells = decoded_cell_vec2
	var/datum/graph/constructed = graph_deserialize_from_rustg_call_list(decoded["graph"], points)
	return constructed
