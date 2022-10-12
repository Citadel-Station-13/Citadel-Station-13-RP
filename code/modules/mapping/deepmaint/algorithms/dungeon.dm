/obj/landmark/deepmaint_root/dungeon
	name = "deepmaint generator - dungeon"
	algorithm = /datum/deepmaint_algorithm/dungeon

/**
 * modified dungeongen algorithm found off reddit
 *
 * 1. randomly place rooms
 * 2. add to graph with delauany triangulation
 * 3. store graph, clone
 * 4. compute MST of graph
 * 5. readd random edges that's missing from the initial triangulation graph
 * 6. load rooms
 * 7. generate paths
 * 8. for multiz, place rooms up/down from the possible multiz traversal rooms, which count as preseeded.
 */
/datum/deepmaint_algorithm/dungeon
	name = "dungeon"
	desc = "Uses a complex algorithm to attempt to generate roguelike dungeons."

/datum/deepmaint_algorithm/dungeon/generate(obj/landmark/deepmaint_root/host, turf/from, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	host.blackboard["rooms"] = list()

	// detect levels
	var/list/level_detect = list(host.z)
	host.blackboard["levels"] = level_detect
	var/turf/current = get_turf(host)
	for(var/i in 1 to host.multiz_spread_up)
		current = current.Above()
		if(level_detect.Find(current.z))
			stack_trace("collision when spreading up against level - are we somehow looped?")
			break
		level_detect += current.z

	current = get_turf(host)
	for(var/i in 1 to host.multiz_spread_down)
		current = current.Below()
		if(level_detect.Find(current.z))
			stack_trace("collision when spreading up against level - are we somehow looped?")
			break
		level_detect += current.z

	spread(host, from, markers, templates)

/**
 * spreads out at a specific centerpoint on the zlevel
 */
/datum/deepmaint_algorithm/dungeon/proc/spread(obj/landmark/deepmaint_root/host, turf/from, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates, list/inserted_rooms)
	// step 0: init
	var/turf/host_turf = get_turf(host)
	var/list/datum/deepmaint_room/rooms_current = inserted_rooms? inserted_rooms.Copy() : list()
	var/list/datum/deepmaint_room/rooms_totality = host.blackboard["rooms"]

	// step 1: seed rooms
	#warn use the common algorithm
	var/list/datum/deepmaint_room/rooms = seed(host, from, markers, templates)

	// step 2: triangulation, create graph
	var/datum/graph/triangulation = delaunay_triangulation(rooms)

	// step 3: get MST
	var/datum/graph/minimum = triangulation.undirected_create_mst()

	// step 4: seed random paths to make it more realistic
	if(host.path_pruning_bias)
		if(host.path_pruning_bias > 0)
			var/list/unnecessary = triangulation.undirected_edge_difference(minimum)
			for(var/datum/graph_edge/E as anything in unnecessary)
				if(!prob(host.path_pruning_bias))
					continue
				minimum.Connect(E.a, E.b)
		else
			var/list/necessary = minimum.undirected_edges()
			for(var/datum/graph_edge/E as anything in necessary)
				if(!prob(-host.path_pruning_bias))
					continue
				minimum.Disconnect(E.a, E.b)

	// step 5: path culling for invalid paths if necessary
	if(host.path_culling)

	// step 6: load rooms

	// step 7: path generation


	// step 8: check for multiz spread. if so, pre-seed rooms beneath where transit rooms allow for it, and move down and repeat
	var/turf/above = host_turf.Above()
	if(above && (above.z in host.blackboard["levels"]))

	var/turf/below = host_turf.Below()
	if(below && (below.z in host.blackboard["levels"]))

/datum/deepmaint_algorithm/dungeon/proc/seed(obj/landmark/deepmaint_root/host, turf/from, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	. = list()

/**
 * performs delanuay triangulation on a set of rooms
 *
 * if you don't know what this is, look it up
 */
/datum/deepmaint_algorithm/dungeon/proc/delaunay_triangulation(list/datum/deepmaint_room/rooms)
	var/list/datum/geometry/point/points = list()
	for(var/datum/deepmaint_room/room as anything in rooms)
		var/list/center_coords = room.Center()
		points += new /datum/geometry/point(center_coords[1], center_coords[2], room)
	var/datum/graph/original = point_delaunay_triangulation(points)

