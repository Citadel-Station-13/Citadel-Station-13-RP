//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Warning. This file is very strongly coupled with Citade Station's rust-g repository,
 * notably geometry.rs. Do not mess with things in here unless you know what you are doing.
 */

/datum/vec2
	var/x
	var/y

/datum/vec2/New(x, y)
	src.x = x
	src.y = y

/proc/vec2_serialiez_to_rustg_call_list(list/datum/vec2/points)
	var/list/constructed = list()
	for(var/datum/vec2/point as anything in points)
		constructed[++constructed.len] = list(
			"x" = point.x,
			"y" = point.y,
		)
	return constructed

/proc/vec2_serialize_to_rustg_call_string(list/datum/vec2/points)
	return json_encode(vec2_serialiez_to_rustg_call_list(points))

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

/datum/vec2/voronoi
	/// only set if requested; area underneath this vec2
	var/area
	/// only set if requested; /datum/vec2's in the voronoi cell
	var/list/datum/vec2/cell

/**
 * returns a /datum/graph,
 *
 * vertices are vec2/voronoi
 * edges are connectoins between vertices
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
		"points" = vec2_serialiez_to_rustg_call_list(points),
		"margin" = bounidng_margin,
	)))
	var/list/decoded = json_decode(encoded)
	var/count = length(points)
	var/list/areas = decoded["areas"] || new /list(count)
	var/list/cells = decoded["cells"] || new /list(count)
	var/list/datum/vec2/voronoi/transmuted = list()
	for(var/i in 1 to length(points))
		var/datum/vec2/point = points[i]
		var/datum/vec2/voronoi/transmuting = new(point.x, point.y)
		transmuting.area = areas[i]
		transmuting.cell = cells[i]
		if(!isnull(transmuting.cell))
			var/list/datum/vec2/decoded_cell_vec2 = list()
			for(var/list/data_list as anything in transmuting.cell)
				decoded_cell_vec2 += new /datum/vec2(data_list["x"], data_list["y"])
			transmuting.cell = decoded_cell_vec2
	var/datum/graph/constructed = graph_deserialize_from_rustg_call_string(decoded["graph"], transmuted)
	return constructed
