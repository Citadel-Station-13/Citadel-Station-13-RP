//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// active patrol route, if any
	var/datum/dynamic_ai_patrol/patrol_route
	/// force road rage to be on/off for the next patrol step
	/// if non-null, will override patrol route environmental attack settings
	var/patrol_violently_to_next_step

/datum/ai_holder/dynamic/proc/start_patrol(datum/dynamic_ai_patrol/route)

/datum/ai_holder/dynamic/proc/resume_patrol()
	patrol_violently_to_next_step = FALSE

/**
 * @params
 * * failed - did this patrol end due to a node being evicted, or a failure when nodes aren't allowed to be evicted?
 */
/datum/ai_holder/dynamic/proc/stop_patrol(failed)
	on_patrl_end(failed)

/datum/ai_holder/dynamic/proc/process_patrol(cycles)

/**
 * @params
 * * failed - did this patrol end due to a node being evicted, or a failure when nodes aren't allowed to be evicted?
 */
/datum/ai_holder/dynamic/proc/on_patrol_end(failed)

#warn impl
