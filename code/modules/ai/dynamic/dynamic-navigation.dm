//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// navigation is set. we use pathfinding for navigation.
	var/navigation_active = FALSE

/datum/ai_holder/dynamic/proc/cancel_navigation(reset_state = TRUE)
	navigation_active = FALSE
	if(reset_state)
		reset_pathfinding()

/datum/ai_holder/dynamic/proc/resume_navigation()
	navigation_active = TRUE
	propagate_navigation()

/**
 * instructs our movement system to go to the next pathfinding node
 */
/datum/ai_holder/dynamic/proc/propagate_navigation()
	#warn impl

/**
 * @return TRUE / FALSE on success / failure
 */
/datum/ai_holder/dynamic/proc/set_navigation(turf/destination)
	if(!pathfind_to(destination))
		return FALSE
	propagate_navigation()
	return TRUE
