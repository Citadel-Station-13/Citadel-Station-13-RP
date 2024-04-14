//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * A method of ending the round, basically.
 *
 * These generally have a spoolup, 'active' period, and then their finalization is called.
 * These are instanced, and can be stateful.
 *
 * 'call': start the finale's execution
 * 'recall': cancel
 */
/datum/map_finale
	/// requires constant ticking; can't modify this at runtime
	var/requires_constant_ticking = FALSE
	/// currently active / called
	var/currently_called = FALSE
	/// last call time
	var/last_call_time
	/// last recall time
	var/last_recall_time

#warn comms console shit ugh (can call, can recall, messages, etc)

/**
 * called when being added to the ticker's registered finales
 */
/datum/map_finale/proc/on_register()
	return

/**
 * called when being removed from the ticker's registered finales
 */
/datum/map_finale/proc/on_unregister()
	return

/**
 * called when someone initiates this finale
 */
/datum/map_finale/proc/on_call(datum/event_args/actor/actor, datum/via_source)
	return

/**
 * called when someone cancels this finale
 */
/datum/map_finale/proc/on_recall(datum/event_args/actor/actor, datum/via_source)
	return

/**
 * called while called
 *
 * @params
 * * dt - seconds
 */
/datum/map_finale/proc/on_active_tick(dt)
	return

/**
 * called if requires_constant_ticking is on, per ticker tick
 *
 * * called even while active
 *
 * @params
 * * dt - seconds
 */
/datum/map_finale/proc/on_idle_tick(dt)
	return

/**
 * Call this to end the round.
 */
/datum/map_finale/proc/finish()
	return

/**
 * Stat entry to display
 */
/datum/map_finale/proc/stat_entry()
	return

/**
 * Automated one-phase finale
 */
/datum/map_finale/one_phase
	#warn impl

/**
 * Just end the round without doing anything
 */
/datum/map_finale/one_phase/end_the_shift
	#warn impl

/**
 * Automated two-phase finale
 */
/datum/map_finale/two_phase
	#warn impl

/**
 * Shuttle evac or transfer
 */
/datum/map_finale/two_phase/shuttle
	var/should_fire_pods = TRUE
	#warn impl

/**
 * Evacuate via available shuttles and pods
 */
/datum/map_finale/two_phase/shuttle/evacuation
	should_fire_pods = TRUE
	#warn impl

/**
 * Transfer via available shuttles
 */
/datum/map_finale/two_phase/shuttle/crew_transfer
	should_fire_pods = FALSE
	#warn impl

/**
 * Initiate a FTL jump
 */
// /datum/map_finale/ftl_jump
// todo.
// tl;dr
// 1. during call, charge FTL
// 2. when FTL is charged, check that minimum time elapsed.
// 3. when charged AND minimum time elapsed, do final charge
// 4. after final charge, initiate ftl
// 5. if ftl interrupted for any reason, immediately call /two_phase/evacuation
// 6. try again while that goes on
