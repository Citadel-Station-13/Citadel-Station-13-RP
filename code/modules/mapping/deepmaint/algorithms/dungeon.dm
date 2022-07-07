/**
 * modified dungeongen algorithm found off reddit
 *
 * 1. randomly place rooms
 * 2. add to graph with delauany triangulation
 * 3. store graph, clone
 * 4. compute MST of graph
 * 5. readd random edges that's missing from the initial triangulation graph
 * 6. generate paths
 * 7 . for multiz, place rooms up/down from the possible multiz traversal rooms, which count as preseeded.
 */
/datum/deepmaint_algorithm/dungeon
	name = "dungeon"

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
/datum/deepmaint_algorithm/dungeon/proc/spread(obj/landmark/deepmaint_root/host, turf/from, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	// step 0: init
	var/turf/host_turf = get_turf(host)

	// step 1: get room positions
	var/list/datum/deepmaint_room/rooms_current = list()
	var/list/datum/deepmaint_room/rooms_totality = host.blackboard["rooms"]

	// step 2: triangulation, create graph
	var/datum/graph/triangulation = delaunay_triangulation(rooms)

	// step 3: get MST
	var/datum/graph/minimum = triangulation.undirected_create_mst()

	// step 4: seed random paths to make it more realistic

	// step 5: path culling for invalid paths if necessary

	// step 6: path generation

	// step 7: check for multiz spread. if so, pre-seed rooms beneath where transit rooms allow for it, and move down and repeat
	var/turf/above = host_turf.Above()
	if(above && (above.z in host.blackboards["levels"]))

	var/turf/below = host_turf.Below()
	if(below && (below.z in host.blackboards["levels"]))
