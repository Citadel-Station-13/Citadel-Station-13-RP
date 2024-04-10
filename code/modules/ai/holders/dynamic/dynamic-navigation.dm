//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// navigation is set. we use pathfinding for navigation.
	var/navigation_active = FALSE
	/// attack stuff in the way
	var/navigation_rage = FALSE
	/// callback to execute when navigation is finished
	/// will be called with (cancelled: TRUE | FALSE, failed: TRUE | FALSE)
	var/datum/callback/on_navigation_end
	/// grace radius; if we can't *easily* get to the destination and we're
	/// in this range, count as a success and not a fail
	/// this is not 'we stop at this range',
	/// this is 'if we fail at this range we count as success'
	var/navigation_grace
	/// stored pathfinding results for this nav-path
	var/datum/ai_pathing/navigation_path
	#warn impl?

/**
 * called when our navigation has failed
 */
/datum/ai_holder/dynamic/proc/navigation_failed()
	cancel_navigation(TRUE, TRUE)

/**
 * called when our navigation has ended
 */
/datum/ai_holder/dynamic/proc/navigation_succeeded()
	navigation_active = FALSE
	navigation_path = null
	on_navigation_end?.InvokeAsync(FALSE, FALSE)
	on_navigation_end = null

/datum/ai_holder/dynamic/proc/cancel_navigation(reset_state = TRUE, failed = FALSE)
	navigation_active = FALSE
	if(reset_state)
		navigation_path = null
	on_navigation_end?.InvokeAsync(TRUE, failed)
	on_navigation_end = null

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
/datum/ai_holder/dynamic/proc/set_navigation(turf/destination, grace_radius, datum/callback/on_end)
	if(!pathfind_to(destination))
		return FALSE
	src.navigation_grace = grace_radius
	src.on_navigation_end = on_end
	propagate_navigation()
	return TRUE
