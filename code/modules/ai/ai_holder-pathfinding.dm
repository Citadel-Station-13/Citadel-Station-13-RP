//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn remove lmfao

/datum/ai_holder
	/// our default pathfinding type
	var/ai_pathfinder_type = /datum/ai_pathfinder/generic_jps


	/// pathfinding in node mode - returned nodes are what we use, rather than
	/// individual turfs
	var/pathed_via_node
	/// current stored path
	var/list/pathed_stored
	/// last world.time of repath
	var/pathed_last
	/// currently walking path
	var/walking_path

/datum/ai_holder/proc/reset_pathfinding()

/datum/ai_holder/proc/pathfind_to(atom/destination)

#warn impl all
