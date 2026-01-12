//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/airlock_phase
	/// should be lowercase
	var/display_verb =  "???"
	/// set when we begin, not unset when we end
	var/started_at
	/// set when we end
	var/ended_at

/**
 * * can return outside of 0 to 1, which would result in something like `2` being `"200%"`.
 * @return null if not supported or number, ideally 0 to 1
 */
/datum/airlock_phase/proc/estimate_progress_ratio()
	return null

/**
 * Called when entering this phase.
 * @return TRUE / FALSE success / failure; cycling is aborted if FALSE.
 */
/datum/airlock_phase/proc/setup(datum/airlock_cycle/cycle)
	return TRUE

/**
 * @return TRUE if finished, FALSE otherwise
 */
/datum/airlock_phase/proc/tick(datum/airlock_cycle/cycle)
	// by default, we just care that all tasks are done
	return !length(cycle.tasks)

/**
 * Called when exiting this phase.
 * @return TRUE / FALSE success / failure; cycling is aborted if FALSE.
 */
/datum/airlock_phase/proc/cleanup(datum/airlock_cycle/cycle)
	return TRUE

/**
 * Depressurize airlock to handler's waste buffer, or an exterior vent.
 */
/datum/airlock_phase/depressurize
	display_verb = "depressurizing"
	/// push air out of vents instead of through the handler's waste side
	var/try_use_vent = FALSE
	/// if no vents exist, do not pump to handler
	var/must_use_vent = FALSE
	/// stop at pressure
	var/depressurize_to_kpa = 0

/datum/airlock_phase/depressurize/vent_to_outside
	try_use_vent = TRUE

/datum/airlock_phase/depressurize/vent_to_outside/required
	must_use_vent = TRUE

/**
 * Repressurize airlock from handler's supply
 */
/datum/airlock_phase/repressurize
	display_verb = "repressurizing"
	/// stop at pressure
	var/pressurize_to_kpa = ONE_ATMOSPHERE

/datum/airlock_phase/doors
	display_verb = "operating doors"

/datum/airlock_phase/doors/seal
	display_verb = "sealing"

/datum/airlock_phase/doors/seal/interior

/datum/airlock_phase/doors/seal/exterior

/datum/airlock_phase/doors/unseal
	display_verb = "unsealing"

/datum/airlock_phase/doors/unseal/interior

/datum/airlock_phase/doors/unseal/exterior


#warn impl
