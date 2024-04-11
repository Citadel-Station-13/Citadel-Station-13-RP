//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// navigation ahs been set
	var/navigation_set = FALSE
	/// navigation is active. we should move via navigation.
	var/navigation_active = FALSE
	/// attack stuff in the way
	var/navigation_rage = FALSE
	/// current navigation scheduling priority
	var/navigation_priority
	/// callback to execute when navigation is finished
	/// will be called with (status: AI_DYNAMIC_NAVIGATION_FINISHED_*)
	var/datum/callback/on_navigation_end
	/// grace radius; if we can't *easily* get to the destination and we're
	/// in this range, count as a success and not a fail
	/// this is not 'we stop at this range',
	/// this is 'if we fail at this range we count as success'
	var/navigation_grace
	/// stored pathfinding results for this nav-path
	var/datum/ai_pathing/navigation_path

/datum/ai_holder/dynamic/proc/stop_navigation(status = AI_DYNAMIC_NAVIGATION_FINISHED_CANCELLED)
	navigation_active = FALSE
	navigation_set = FALSE
	on_navigation_end?.InvokeAsync(status)
	on_navigation_end = null
	// todo: should we do pluggable movement loops?
	return TRUE

/datum/ai_holder/dynamic/proc/pause_navigation()
	if(!navigation_set)
		return TRUE
	navigation_active = FALSE
	// todo: should we do pluggable movement loops?
	return TRUE

/datum/ai_holder/dynamic/proc/resume_navigation()
	if(!navigation_set)
		return FALSE
	navigation_active = TRUE
	// todo: should we do pluggable movement loops?
	return TRUE

/**
 * starts navigation somewhere
 *
 * please use named arguments.
 *
 * scheduling_priority is automatically demoted by 1 if it's at INTERRUPT tier.
 *
 * @params
 * * destination - where to go
 * * grace_radius - within what radius is this considered successful?
 * * on_end - what to call when we're done for any reason
 * * scheduling_priority - AI_DYNAMIC_SCHEDULING_*; we interrupt navigation of lower priority.
 * * interrupt_priority - AI_DYNAMIC_SCHEULING_*; we interrupt navigation of a lower priority. defaults to scheduling_priority.
 */
/datum/ai_holder/dynamic/proc/set_navgiation(
	turf/destination,
	grace_radius = 1,
	datum/callback/on_end,
	scheduling_priority = AI_DYNAMIC_SCHEDULING_INTERRUPT,
	interrupt_priority = scheduling_priority,
)
	if(navigation_set)
		if(navigation_priority <= interrupt_priority)
			return FALSE

	var/datum/ai_pathing/found = pathfind(
		destination = destination,
		slack = grace_radius,
	)

	if(isnull(found))
		return FALSE

	// todo: interrupt before/after found should be a param
	if(navigation_set)
		stop_navigation(AI_DYNAMIC_NAVIGATION_FINISHED_INTERRUPTED)

	navigation_set = TRUE
	navigation_active = TRUE
	navigation_path = found
	navigation_grace = grace_radius
	on_navigation_end = on_end
	navigation_priority = scheduling_priority == AI_DYNAMIC_SCHEDULING_INTERRUPT? (AI_DYNAMIC_SCHEDULING_INTERRUPT - 1) : scheduling_priority
