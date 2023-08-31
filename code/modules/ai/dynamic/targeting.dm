//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// targeting sweep delay in combat
	var/targeting_interval_combat = 2 SECONDS
	/// targeting sweep delay out of combat
	var/targeting_interval_noncombat = 10 SECONDS
	/// targeting sweep range
	/// this drastically affects performance
	/// changes will not be allowed without good reason.
	var/targeting_sweep_range = 7

/**
 * Perform targeting sweep
 */
/datum/ai_holder/dynamic/proc/run_targeting()
	var/list/targets = targeting_sweep()
	#warn perform reactions, etc

/**
 * Returns list of potential entities
 */
/datum/ai_holder/dynamic/proc/targeting_sweep()
	var/list/sweep_output
	var/sweep_center = get_turf(agent)
	if(isnull(sweep_center))
		return list()
	DVIEW(sweep_output, targeting_sweep_range, sweep_center, SEE_INVISIBLE_LIVING)
	return targeting_filter(sweep_output)

/**
 * Filters entities for what we should target.
 */
/datum/ai_holder/dynamic/proc/targeting_filter(list/atom/movable/entities)
	. = list()
	#warn check for vision, faction, cooperation, etc???
