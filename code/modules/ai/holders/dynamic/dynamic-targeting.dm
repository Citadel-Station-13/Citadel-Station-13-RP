//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// primary target (this is the one we're chasing if we're chasing or fleeing from if fleeing)
	var/atom/primary_target
	/// all targets we're engaged with right now
	var/list/engaged_targets
	/// all valid targets; this is a list because
	/// special / user defined behavior might want a targeting
	/// sweep and we don't want to make them do their own sweeps
	/// as that's just a waste of CPU + they probably don't know
	/// how to code it as well as the main system is written.
	var/list/valid_targets

	/// targeting sweep delay in combat
	var/targeting_interval_combat = 3.5 SECONDS
	/// targeting sweep delay out of combat
	var/targeting_interval_noncombat = 10 SECONDS
	/// targeting sweep range
	/// this drastically affects performance
	/// changes will not be allowed without good reason.
	var/targeting_sweep_range = 9
	/// last targeting sweep
	var/targeting_sweep_last

/**
 * Perform targeting sweep if it's been long enough
 */
/datum/ai_holder/dynamic/proc/auto_run_targeting()
	var/wanted_delay = mode == AI_DYNAMIC_MODE_COMBAT? targeting_interval_combat : targeting_interval_noncombat
	if(targeting_sweep_last > world.time + wanted_delay)
		return
	run_targeting()

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
