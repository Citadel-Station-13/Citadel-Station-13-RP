//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Stores data about a transit stage like docking / undocking / takeoff / landing
 */
/datum/shuttle_transit_stage
	/// owning cycle
	var/datum/shuttle_transit_cycle/cycle
	/// stage enum
	var/stage = SHUTTLE_TRANSIT_STAGE_IDLE
	/**
	 * List of blockers
	 */
	var/list/datum/shuttle_transit_blocker/blockers

	/// timeout set on us
	/// * this isn't actually enforced on our side; it's enforced on the shuttle controller's side.
	var/timeout_duration
	/// world.time we will time out on
	var/timeout_at

#warn impl all

/**
 * implies [force()]
 */
// /datum/event_args/shuttle/proc/dangerously_force()
// 	force()
// 	if(dangerously_forcing)
// 		return
// 	dangerously_forcing = TRUE
// 	#warn impl

// /datum/event_args/shuttle/proc/finish(success)
// 	succeeded = success
// 	finished = TRUE

// 	for(var/datum/shuttle_hook/hook in waiting_on_hooks)
// 		release(hook)

// /datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
// 	. = FALSE
// 	if(!blockable)
// 		// it is YOUR job to check if an event is blockable.
// 		CRASH("attempted to block an unblockable event")
// 	ASSERT(!(src in hook.blocking))
// 	LAZYADD(hook.blocking, src)
// 	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)
// 	if(dangerous)
// 		forcing_could_be_dangerous = TRUE
// 	return TRUE

// /datum/event_args/shuttle/proc/release(datum/shuttle_hook/hook)
// 	waiting_on_hooks -= hook
// 	LAZYREMOVE(hook.blocking, src)

// /datum/event_args/shuttle/proc/update(datum/shuttle_hook/hook, list/reason_or_reasons)
// 	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)
