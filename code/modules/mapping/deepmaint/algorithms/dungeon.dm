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

/datum/deepmaint_algorithm/dungeon/generate(atom/movable/landmark/deepmaint_root/host, turf/from, list/atom/movable/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
