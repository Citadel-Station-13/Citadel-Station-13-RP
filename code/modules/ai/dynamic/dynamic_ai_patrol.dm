//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a patrol route
 */
/datum/dynamic_ai_patrol
	/// number of steps
	var/list/datum/dynamic_ai_patrol_step/steps = list()
	/// allow step eviction if we can't get to a step
	/// without this, we will instead immediately abort.
	var/allow_step_eviction = TRUE
	/// allow violently making a path to the step
	var/road_rage = TRUE
	/// heuristic for amount of 'out of my way-ness' can be allowed by pathfinding
	/// before [road_rage] triggers if we can smash through
	/// if [road_rage] is disabled, we will instead evict this step.
	var/road_rage_ratio = 1.5
