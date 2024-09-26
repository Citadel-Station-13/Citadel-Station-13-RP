//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Pathfinding results.
 */
/datum/ai_pathing
	/// pathfinding in node mode - returned nodes are what we use, rather than
	/// individual turfs
	var/is_node_path
	/// current stored path
	var/list/path

/datum/ai_pathing/New(list/path, is_node_path)
	src.path = path
	src.is_node_path = is_node_path
