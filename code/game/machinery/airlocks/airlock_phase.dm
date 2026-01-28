//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * * Stateless
 */
/datum/airlock_phase
	/// should be lowercase
	var/display_verb =  "???"

/**
 * * can return outside of 0 to 1, which would result in something like `2` being `"200%"`.
 * @return null if not supported or number, ideally 0 to 1
 */
/datum/airlock_phase/proc/estimate_progress_ratio(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return null

/**
 * Called when entering this phase.
 * @return AIRLOCK_PHASE_SETUP_* enum
 */
/datum/airlock_phase/proc/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return AIRLOCK_PHASE_SETUP_SUCCESS

/**
 * * 'dt' is in seconds
 * @return TRUE if finished, FALSE otherwise
 */
/datum/airlock_phase/proc/tick(datum/airlock_system/system, datum/airlock_cycling/cycling, dt)
	// by default, we just care that all tasks are done
	if(!length(cycling.running_tasks))
		return AIRLOCK_PHASE_TICK_FINISH
	return AIRLOCK_PHASE_TICK_CONTINUE

/**
 * Called when exiting this phase.
 */
/datum/airlock_phase/proc/cleanup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	return

/datum/airlock_phase/merge_blackboard
	var/list/merge_system_blackboard
	var/list/merge_cycling_blackboard

/datum/airlock_phase/merge_blackboard/setup(datum/airlock_system/system, datum/airlock_cycling/cycling)
	#warn impl

/**
 * Depressurize airlock to handler's waste buffer, or an exterior vent.
 */
/datum/airlock_phase/depressurize
	display_verb = "depressurizing"
	/// push air out of vents instead of through the handler's waste side
	var/vent_to_outside = FALSE
	/// stop at pressure
	var/depressurize_to_kpa = 0

/datum/airlock_phase/depressurize/vent_to_outside
	vent_to_outside = TRUE

/datum/airlock_phase/depressurize/drain_to_handler
	vent_to_outside = FALSE

/**
 * Repressurize airlock from handler's supply
 */
/datum/airlock_phase/repressurize
	display_verb = "repressurizing"
	/// stop at pressure
	var/pressurize_to_kpa = ONE_ATMOSPHERE
	/// pull from exterior vent if possible
	var/pull_from_outside_if_possible = FALSE
	/// must pull from outside
	/// * requires [pull_from_outside_if_possible]
	var/pull_from_outside_required = FALSE

/datum/airlock_phase/repressurize/allow_external_air
	pull_from_outside_if_possible = TRUE

/datum/airlock_phase/repressurize/require_external_air
	pull_from_outside_if_possible = TRUE
	pull_from_outside_required = TRUE

/datum/airlock_phase/repressurize/from_handler_supply

/datum/airlock_phase/doors
	display_verb = "operating doors"

#warn set X_DOOR_SEALED blackboard on these phases

/datum/airlock_phase/doors/seal
	display_verb = "sealing"

/datum/airlock_phase/doors/seal/interior

/datum/airlock_phase/doors/seal/exterior

/datum/airlock_phase/doors/unseal
	display_verb = "unsealing"

/datum/airlock_phase/doors/unseal/interior

/datum/airlock_phase/doors/unseal/exterior


#warn impl
