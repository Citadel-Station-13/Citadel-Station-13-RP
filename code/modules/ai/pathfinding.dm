//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn remove lmfao

/datum/pathfinding
/datum/pathfinding/proc/search()

/datum/ai_holder
	/// pathfinding in node mode - returned nodes are what we use, rather than
	/// individual turfs
	var/pathed_via_node
	/// current stored path
	var/list/pathed_stored
	/// last world.time of repath
	var/pathed_last
	/// currently walking path
	var/walking_path

/datum/ai_holder/proc/

#warn impl all
