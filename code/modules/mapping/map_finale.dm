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

/**
 * called when being added to the ticker's registered finales
 */
/datum/map_finale/proc/register()

/**
 * called when being removed from the ticker's registered finales
 */
/datum/map_finale/proc/unregister()

/**
 *
 */
/datum/map_finale/proc/on_call(datum/event_args/actor/actor, datum/via_source)

/**
 *
 */
/datum/map_finale/proc/on_recall(datum/event_args/actor/actor, datum/via_source)

/**
 * called while called
 *
 * @params
 * * dt - seconds
 */
/datum/map_finale/proc/active_tick(dt)
	return

/**
 * called if requires_constant_ticking is on, per ticker tick
 *
 * * called even while active
 *
 * @params
 * * dt - seconds
 */
/datum/map_finale/proc/idle_tick(dt)
	return

/**
 *
 */
/datum/map_finale/proc/

/**
 *
 */
/datum/map_finale/proc/

/**
 * Just end the round without doing anything
 */
/datum/map_finale/end_the_shift

/**
 * Evacuate via available shuttles and pods
 */
/datum/map_finale/evacuation

/**
 * Transfer via available shuttles
 */
/datum/map_finale/crew_transfer

/**
 * Initiate a FTL jump
 */
/datum/map_finale/ftl_jump

